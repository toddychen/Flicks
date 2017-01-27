//
//  MovieDetailViewController.m
//  Flicks
//
//  Created by Yi Chen on 1/24/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "MovieDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    CGFloat xMargin = 48;
    CGFloat cardHeight = 200; // arbitrary value
    CGFloat bottomPadding = 64;
    CGFloat cardOffset = cardHeight * 0.75;
    self.scrollView.frame = CGRectMake(xMargin, // x
                                       CGRectGetHeight(self.view.bounds) - cardHeight - bottomPadding, // y
                                       CGRectGetWidth(self.view.bounds) - 2 * xMargin, // width
                                       cardHeight); // height
    
    self.cardView.frame = CGRectMake(0, cardOffset, CGRectGetWidth(self.scrollView.bounds), cardHeight);
    
    // content height is the height of the card plus the offset we want
    CGFloat contentHeight =  cardHeight + cardOffset;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, contentHeight);
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width,  self.overviewLabel.frame.size.height);
    
    
    self.titleLabel.text = self.movieModel.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.overviewLabel.text = self.movieModel.movieDescription;
    self.overviewLabel.textColor = [UIColor whiteColor];
    [self.overviewLabel sizeToFit];
    self.cardView.frame = CGRectMake(0, cardOffset, CGRectGetWidth(self.scrollView.bounds), self.titleLabel.frame.size.height + self.overviewLabel.frame.size.height + 20);
    self.cardView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

    [self.posterImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", self.movieModel.posterURLString]]];
    
    
    
    //NSLog(@"%@", self.scrollView);
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

@end
