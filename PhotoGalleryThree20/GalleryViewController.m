//
//  GalleryViewController.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryDataSource.h"

@implementation GalleryViewController

@synthesize category = _category;

- (id)initWithCategory:(NSString *)category {
    if ((self = [super init])) {
        self.category = category;
        TTDPRINT(@"Category is: %@", category);
    }
    
    return self;
}

- (void)createModel {
    self.dataSource = [[[GalleryDataSource alloc] initWithCategory:_category] autorelease];
}

@end
