//
//  CustomPhotoSource.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomPhotoSource.h"
#import "PhotoItem.h"

@implementation CustomPhotoSource

@synthesize title = _title;
@synthesize url = _url;

/*
 *	I had it pass in an element name to specify where the photos element started and this is really just unique to XML
 */
- (id)initWithURL:(NSString *)url elementName:(NSString *)elementName {
    self = [super init];
	if (self) {
		_url = url;
		_element = elementName;
	}
	
	return self;
}

/*
 *	You would probably initialize with this method if you were going to do JSON parsing
 */
- (id)initWithURL:(NSString *)url {
    self = [super init];
	if (self) {
		_url = url;
		_element = nil;
	}
    
	return self;
}

- (void)dealloc {
	[_results release];
	[super dealloc];
}

/*
 *	Kick off the request, pulling from cache if possible. Parsing will be handled in the 
 */
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	TTDPRINT(@"Starting the request");
    
	TTDPRINT(@"Url is: %@", _url);
	
	/*
	 *	IMPORTANT: If your images are big, you need to set this
	 *				or else some of your images won't load.  See http://groups.google.com/group/three20/browse_thread/thread/b313fec26961219a/5dc5ceb4da6c0ce5
	 *				for more details
	 */
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	
	TTURLRequest *request = [TTURLRequest requestWithURL:_url delegate:self];
	//Don't use a cache because it can be pretty dynamic content
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	id<TTURLResponse> response = [[TTURLDataResponse alloc] init];
	request.response = response;
	request.httpMethod = @"GET";
	
	//send out the request to be processed by the response parser
	[request send];
}

/*
 *	Edit this method for parsing. For instance, you might use some different JSON parsing if you don't want to do XML
 */
- (void)requestDidFinishLoad:(TTURLRequest *)request {
	
	//NSString *responseBody = [[NSString	alloc] initWithData:data encoding:NSASCIIStringEncoding];
	//TTDPRINT(@"Made it to the response! The response was: %@", responseBody);
	TTURLDataResponse *response = request.response;
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:response.data 
														   options:0 error:nil];
	
	//Now that I have the XML document, start parsing through;
	NSArray *images = [doc.rootElement elementsForName:_element];
	_results = [[NSMutableArray alloc] init];
	
	for (GDataXMLElement *image in images) {
		/*
		 *	Note: I commented out the thumbWidth/Height and mediumWidth/Height because they're currently unused and
		 *	it was generating a warning. The size that I pass in when creating the PhotoItem is the size 
		 *	of the image that should be returned when the PhotoViewController calls "URLForVersion:TTPhotoVersionLarge" on the PhotoItem
		 */ 
		
		GDataXMLElement *thumb = [[image elementsForName:@"thumb"] objectAtIndex:0];
		//CGFloat thumbWidth = [[[[thumb elementsForName:@"width"] objectAtIndex:0] stringValue] doubleValue];
		//CGFloat thumbHeight = [[[[thumb elementsForName:@"height"] objectAtIndex:0] stringValue] doubleValue];
		NSString *thumbURL = [[[thumb elementsForName:@"url"] objectAtIndex:0] stringValue];
		TTDPRINT(@"thumb: %@", thumbURL);
		
		GDataXMLElement *medium = [[image elementsForName:@"medium"] objectAtIndex:0];
		CGFloat mediumWidth = [[[[medium elementsForName:@"width"] objectAtIndex:0] stringValue] doubleValue];
		CGFloat mediumHeight = [[[[medium elementsForName:@"height"] objectAtIndex:0] stringValue] doubleValue];
		NSString *mediumURL = [[[medium elementsForName:@"url"] objectAtIndex:0] stringValue];
		TTDPRINT(@"medium: %@", mediumURL);
		
		GDataXMLElement *large = [[image elementsForName:@"large"] objectAtIndex:0];
		CGFloat largeWidth = [[[[large elementsForName:@"width"] objectAtIndex:0] stringValue] doubleValue];
		CGFloat largeHeight = [[[[large elementsForName:@"height"] objectAtIndex:0] stringValue] doubleValue];
		NSString *largeURL = [[[large elementsForName:@"url"] objectAtIndex:0] stringValue];
		TTDPRINT(@"large: %@", largeURL);
		
		PhotoItem *item = [PhotoItem itemWithThumbImageURL:(NSString*)thumbURL 
											mediumImageURL:(NSString*)mediumURL 
											 largeImageURL:(NSString*)largeURL 
												   caption:@"" 
													  size:CGSizeMake(largeWidth, largeHeight)];
		
		[_results addObject:item];
	}
	
    TTDPRINT(@"Images added: %i", [_results count]);
	
    [doc release];
	
	//IMPORTANT: if you don't call this method, then your model states will not update
	[super requestDidFinishLoad:request];
}

- (NSArray *)results {
    return [[_results copy] autorelease];
}

- (NSInteger)numberOfPhotos {
	return [_results count];
}

- (NSInteger)maxPhotoIndex {
	return [_results count] - 1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index {
    if (index < 0 || index > [self maxPhotoIndex]) {
        return nil;
    }
    
	id<TTPhoto> photo = [_results objectAtIndex:index];
	photo.index = index;
	photo.photoSource = self;
	return photo;
}

@end
