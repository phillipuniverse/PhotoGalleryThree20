//
//  GalleryViewController.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryDataSource.h"

#import "Album.h"
#import "CustomPhotoSource.h"

@implementation GalleryViewController

@synthesize category = _category;

- (id)initWithCategory:(NSString *)category {
    if ((self = [super init])) {
        self.category = category;
        self.variableHeightRows = YES;
        TTDPRINT(@"Category is: %@", category);
    }
    
    return self;
}

- (void)createModel {
    self.dataSource = [[[GalleryDataSource alloc] initWithCategory:_category] autorelease];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    Album *selectedAlbum = [(TTTableItem *)object userInfo];
    NSString *url = selectedAlbum.photoListURL;
    
    CustomPhotoSource *photoSource = [[CustomPhotoSource alloc] initWithURL:url elementName:@"photo"];
    //TTPhotoViewController *photos = [[TTPhotoViewController alloc] initWithPhotoSource:photoSource];
    TTThumbsViewController *photos = [[TTThumbsViewController alloc] init];
    photos.photoSource = photoSource;
    
    [self.navigationController pushViewController:photos animated:YES];
    
    [photos release];
    [photoSource release];
}

@end
