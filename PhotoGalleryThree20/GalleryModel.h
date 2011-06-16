//
//  GalleryModel.h
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GalleryModel : TTURLRequestModel {
    NSMutableArray *_results;
    NSString *_category;
}

@property (nonatomic, readonly) NSArray *results;
@property (nonatomic, copy) NSString *category;

@end
