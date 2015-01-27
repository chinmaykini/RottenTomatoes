//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Chinmay Kini on 1/24/15.
//  Copyright (c) 2015 Chinmay Kini. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
#import "AFHTTPRequestOperationManager.h"
#import "MovieDetaisScrollViewController.h"



@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [SVProgressHUD show];
    
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    self.tableView.rowHeight    = 132;
    self.title                  = @"Box Office Movies";
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    [self loadStartupPage];
    
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell             = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movieData     = self.movies[indexPath.row];
    
    cell.titleCellField.text    = movieData[@"title"];
    cell.synopsisCellField.text = movieData[@"synopsis"];
    
    
    NSString *thumbnailUrl  = [movieData valueForKeyPath:@"posters.thumbnail"];
    thumbnailUrl            = [thumbnailUrl stringByReplacingOccurrencesOfString:@"tmb" withString:@"pro"];
    NSLog(@"%@", thumbnailUrl);
    [cell.imageCellField setImageWithURL:[NSURL URLWithString:thumbnailUrl]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.movies.count;
}

- (void)onRefresh {

    [self loadStartupPage];
    [self.refreshControl endRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    MovieDetaisScrollViewController *mdvc = [[MovieDetaisScrollViewController alloc] init];
    mdvc.movie                      = self.movies[indexPath.row];
    
    
    [self.navigationController pushViewController:mdvc animated:YES];
    
}

-(BOOL)dropdownAlertWasTapped:(RKDropdownAlert*)alert {
    // Handle the tap, then return whether or not the alert should hide.
    return true;
}

- (void) loadMoviesView{
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=y9fsqggwzyhd8ddxe54aetf6&limit=50&country=us"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *responseDictionary    = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies                         = responseDictionary[@"movies"];
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    
    }];
}

- (void) loadStartupPage{
    
    NSURL *baseURL = [NSURL URLWithString:@"http://api.rottentomatoes.com"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"IS REACHABILE");
                [self loadMoviesView];
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"IS REACHABILE");
                [self loadMoviesView];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"NOT REACHABILE");
                [RKDropdownAlert show];
                [RKDropdownAlert title:@"No Internet Connection!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:5];
            }
            default:{
                NSLog(@"NOT REACHABILE");
                [RKDropdownAlert show];
                [RKDropdownAlert title:@"No Internet Connection!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:5];
                [operationQueue setSuspended:YES];
                break;
            }
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}


@end
