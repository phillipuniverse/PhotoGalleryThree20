#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

/**
 *  Very general photo source.  This assumes that you have an XML source that looks like this:
 *      <photo>
            <caption></caption>
            <thumb>
                <width></width>
                <height></height>
                <url></url>
            </thumb>
            <medium>
                <width></width>
                <height></height>
                <url></url>
            <large>
                <width></width>
                <height></height>
                <url></url>
            </large>
        </photo>
 
    If elementName is specified, then it will use that instead of "photo" (for instance, you could pass in "image")
 */
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

/**
 *  Initialize the PhotoSource with with the image as the root element
 */
- (id)initWithURL:(NSString *)url elementName:(NSString *)elementName;
- (id)initWithURL:(NSString *)url;

@end
