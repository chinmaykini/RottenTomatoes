//
//  MovieDetaisScrollViewController.m
//  RottenTomatoes
//
//  Created by Chinmay Kini on 1/26/15.
//  Copyright (c) 2015 Chinmay Kini. All rights reserved.
//

#import "MovieDetaisScrollViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"


@interface MovieDetaisScrollViewController ()


@end

@implementation MovieDetaisScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    
    // set up scrolling
    [self.scroller setScrollEnabled:YES];
    [self.scroller flashScrollIndicators];
    
    self.title           = self.movie[@"title"];
    [self loadPoster];
    
    self.titleField.text = [NSString stringWithFormat:@"%@ (%@)", self.movie[@"title"], self.movie[@"year"]];
    self.synopsisField.text = self.movie[@"synopsis"];
    self.scoreField.text = [NSString stringWithFormat:@"Critics Score : %@    Audience Score : %@",
                            [self.movie valueForKeyPath:@"ratings.critics_score"],
                            [self.movie valueForKeyPath:@"ratings.audience_score"]];
    
    
    // the text table is set to sizetoFit
    [self.synopsisField sizeToFit];
    self.synopsisField.text = self.movie[@"synopsis"];
    
    // calculating the size of Scrollable area
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.scroller.subviews)
    {
        scrollViewHeight += view.frame.size.height + 30;
    }
    NSLog(@"%f", scrollViewHeight);
    [self.scroller setContentSize:(CGSizeMake(320, scrollViewHeight))];
    
    

    
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

- (void) loadPoster{
    
    NSString *posterUrl  = [self.movie valueForKeyPath:@"posters.thumbnail"];
    posterUrl            = [posterUrl stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];

    [self.posterField setImageWithURL:[NSURL URLWithString:posterUrl]];
    
    
    // TODO : HOw to make teh laoding bar for a image?????
    [SVProgressHUD dismiss];
}

@end
