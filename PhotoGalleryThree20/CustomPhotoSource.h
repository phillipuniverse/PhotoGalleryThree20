#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface CustomPhotoSource : TTURLRequestModel <TTPhotoSource>{
	NSString *_title;
	NSString *_url;
	NSString *_element;
	NSMutableArray *_results;
}

@property (nonatomic, readonly) NSArray *results;

@property (nonatomic, retain) NSString *url;


/**
 * The title of this collection of photos.
 */
@property (nonatomic, copy) NSString* title;

/**
 * The total number of photos in the source, independent of the number that have been loaded.
 */
@property (nonatomic, readonly) NSInteger numberOfPhotos;

/**
 * The maximum index of photos that have already been loaded.
 */
@property (nonatomic, readonly) NSInteger maxPhotoIndex;

- (id<TTPhoto>)photoAtIndex:(NSInteger)index;
- (id)initWithURL:(NSString *)url elementName:(NSString *)elementName;
- (id)initWithURL:(NSString *)url;

@end
