//
//  GalleryDataSource.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GalleryDataSource.h"
#import "GalleryModel.h"

@implementation GalleryDataSource

- (id)initWithCategory:(NSString *)category {
    if((self = [super init])) {
        self.model = [[GalleryModel alloc] initWithCategory:category];
    }
         
    return self;
}

@end
