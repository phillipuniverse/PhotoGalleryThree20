//
//  PhotoItem.h
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhotoItem : NSObject <TTPhoto> {
    NSString *caption;
    NSString *thumbnailURL;
    NSString *mediumURL;
	NSString *largeURL;
    id <TTPhotoSource> photoSource;
    CGSize size;
    NSInteger index;
}

@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *mediumURL;
@property (nonatomic, copy) NSString *largeURL;

+ (id)itemWithThumbImageURL:(NSString*)thumbImageURL mediumImageURL:(NSString*)mediumImageURL largeImageURL:(NSString*)largeImageURL caption:(NSString*)caption size:(CGSize)size;

@end
