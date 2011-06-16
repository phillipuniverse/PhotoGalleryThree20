//
//  Album.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Album.h"


@implementation Album

@synthesize title, description, coverThumb, photoListURL;

- (void)dealloc {
    [title release];
    [description release];
    [coverThumb release];
    [photoListURL release];
    
    [super dealloc];
}

@end
