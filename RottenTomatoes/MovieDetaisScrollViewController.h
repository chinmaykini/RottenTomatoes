//
//  MovieDetaisScrollViewController.h
//  RottenTomatoes
//
//  Created by Chinmay Kini on 1/26/15.
//  Copyright (c) 2015 Chinmay Kini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetaisScrollViewController : UIViewController
@property (nonatomic, strong) NSDictionary *movie;
@property (weak, nonatomic) IBOutlet UIImageView *posterField;
@property (weak, nonatomic) IBOutlet UILabel *synopsisField;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UILabel *titleField;
@property (weak, nonatomic) IBOutlet UILabel *scoreField;
@property (weak, nonatomic) IBOutlet UILabel *ratingField;
@end
