//
//  PhotoItem.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoItem.h"


@implementation PhotoItem

@synthesize caption, photoSource, size, index; // properties declared in the TTPhoto protocol
@synthesize thumbnailURL, mediumURL, largeURL; // PhotoItem's own properties

+ (id)itemWithThumbImageURL:(NSString*)thumbImageURL mediumImageURL:(NSString*)mediumImageURL largeImageURL:(NSString*)largeImageURL caption:(NSString*)theCaption size:(CGSize)theSize {
    PhotoItem *item = [[[[self class] alloc] init] autorelease];
    item.caption = theCaption;
    item.thumbnailURL = thumbImageURL;
	item.mediumURL = mediumImageURL;
    item.largeURL = largeImageURL;
	item.size = theSize;
	
	//TTDPRINT(@"Creating photo with image: %@, thumb: %@, caption: %@, size: (%f, %f)", theImageURL, theThumbImageURL, theCaption, theSize.width, theSize.height);
	
    return item;
}

// ----------------------------------------------------------
#pragma mark TTPhoto protocol

/**
 *	The logic behind this is:
 *		- No mediumURL set, use the largeURL. No largeURL, use the thumbnail
 - No largeURL set, use the mediumURL. No mediumURL, use the thumbnail
 */
- (NSString*)URLForVersion:(TTPhotoVersion)version {
	switch (version) {
		case TTPhotoVersionThumbnail:
			TTDPRINT(@"Getting thumb URL: %@", thumbnailURL);
			return (thumbnailURL) ? thumbnailURL : @"";
			break;
		case TTPhotoVersionMedium:
			TTDPRINT(@"Getting medium URL: %@", mediumURL);
			return (mediumURL) ? mediumURL : ((largeURL) ? largeURL : thumbnailURL);
			break;
		case TTPhotoVersionLarge:
			TTDPRINT(@"Getting large URL: %@", largeURL);
			//Fall through 
			return (mediumURL) ? largeURL : ((mediumURL) ? mediumURL : thumbnailURL);
			break;
        default:
            return thumbnailURL;
            //Other possible cases:
			//TTPhotoVersionNone
			//TTPhotoVersionSmall
	}
    
	return largeURL;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(caption);
	TT_RELEASE_SAFELY(thumbnailURL);
	TT_RELEASE_SAFELY(mediumURL);
	TT_RELEASE_SAFELY(largeURL);
    [super dealloc];
}

@end
