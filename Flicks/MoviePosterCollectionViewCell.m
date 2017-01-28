//
//  MoviePosterCollectionViewCell.m
//  Flicks
//
//  Created by Yi Chen on 1/26/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "MoviePosterCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface MoviePosterCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MoviePosterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}


- (void)reloadData {
    // assumes model is set
    //[self.imageView setImageWithURL: self.model.posterURLString];
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", self.model.posterURLString]]];
    
    // Makes sure `layoutSubviews` is called
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    // image view is same size as cell
    self.imageView.frame = self.contentView.bounds;
    //self.imageView.frame = CGRectMake(0, 0, 100, 100);
}


@end
