//
//  Album.h
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Album : NSObject {
    NSString *title;
    NSString *description;
    NSString *coverThumb;
    NSString *photoListURL;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *coverThumb;
@property (nonatomic, copy) NSString *photoListURL;

@end
