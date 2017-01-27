//
//  MovieDetailViewController.h
//  Flicks
//
//  Created by Yi Chen on 1/24/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "ViewController.h"
#import "MovieModel.h"


@interface MovieDetailViewController : ViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (nonatomic) MovieModel *movieModel;

@end
