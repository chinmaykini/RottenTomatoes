//
//  MovieCell.h
//  RottenTomatoes
//
//  Created by Chinmay Kini on 1/24/15.
//  Copyright (c) 2015 Chinmay Kini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageCellField;
@property (weak, nonatomic) IBOutlet UILabel *titleCellField;
@property (weak, nonatomic) IBOutlet UILabel *synopsisCellField;

@end
