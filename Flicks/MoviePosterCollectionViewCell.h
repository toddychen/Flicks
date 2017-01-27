//
//  MoviePosterCollectionViewCell.h
//  Flicks
//
//  Created by Yi Chen on 1/26/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface MoviePosterCollectionViewCell : UICollectionViewCell
- (void)reloadData;

@property (strong, nonatomic) MovieModel *model;

@end
