//
//  MovieModel.m
//  Flicks
//
//  Created by Yi Chen on 1/23/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"original_title"];
        self.movieDescription = dictionary[@"overview"];
        self.posterURLString = dictionary[@"poster_path"];
    }
    return self;
    
}

@end
