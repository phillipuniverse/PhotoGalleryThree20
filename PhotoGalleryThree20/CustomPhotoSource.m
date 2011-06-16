#import "CustomPhotoSource.h"

// -----------------------------------------------------------------------
#pragma mark -
#pragma mark PhotoItem
@interface PhotoItem : NSObject <TTPhoto>
{
    NSString *caption;
    NSString *thumbnailURL;
    NSString *mediumURL;
	NSString *largeURL;
    id <TTPhotoSource> photoSource;
    CGSize size;
    NSInteger index;
}
@property (nonatomic, retain) NSString *thumbnailURL;
@property (nonatomic, retain) NSString *mediumURL;
@property (nonatomic, retain) NSString *largeURL;
+ (id)itemWithThumbImageURL:(NSString*)thumbImageURL mediumImageURL:(NSString*)mediumImageURL largeImageURL:(NSString*)largeImageURL caption:(NSString*)caption size:(CGSize)size;
@end

@implementation PhotoItem

@synthesize caption, photoSource, size, index; // properties declared in the TTPhoto protocol
@synthesize thumbnailURL, mediumURL, largeURL; // PhotoItem's own properties

+ (id)itemWithThumbImageURL:(NSString*)thumbImageURL mediumImageURL:(NSString*)mediumImageURL largeImageURL:(NSString*)largeImageURL caption:(NSString*)theCaption size:(CGSize)theSize;
{
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
- (NSString*)URLForVersion:(TTPhotoVersion)version
{
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
		//Other possible cases:
			//TTPhotoVersionNone
			//TTPhotoVersionSmall
	}
    
	return largeURL;
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(caption);
	TT_RELEASE_SAFELY(thumbnailURL);
	TT_RELEASE_SAFELY(mediumURL);
	TT_RELEASE_SAFELY(largeURL);
    [super dealloc];
}

@end

#pragma mark -
#pragma	mark CustomPhotoSource
@implementation CustomPhotoSource

@synthesize title = _title;
@synthesize url = _url;

/*
 *	I had it pass in an element name to specify where the photos element started and this is really just unique to XML
 */
- (id)initWithURL:(NSString *)url elementName:(NSString *)elementName {
	if(self = [super init]){
		_url = url;
		_element = elementName;
	}
	
	return self;
}

/*
 *	You would probably initialize with this method if you were going to do JSON parsing
 */
- (id)initWithURL:(NSString *)url {
	if(self = [super init]) {
		_url = url;
		_element = nil;
	}
	   
	return self;
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
- (void) requestDidFinishLoad:(TTURLRequest *)request {
	
	//NSString *responseBody = [[NSString	alloc] initWithData:data encoding:NSASCIIStringEncoding];
	//TTDPRINT(@"Made it to the response! The response was: %@", responseBody);
	TTURLDataResponse *response = request.response;
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:response.data 
														   options:0 error:nil];
	
	//Now that I have the XML document, start parsing through;
	NSArray *images = [doc.rootElement elementsForName:_element];
	_results = [[NSMutableArray alloc] init];
	
	for(GDataXMLElement *image in images) {
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
													  size:CGSizeMake(mediumWidth, mediumHeight)];
		
		[_results addObject:item];
	}
	
    TTDPRINT(@"Images added: %i", [_results count]);
	
    [doc release];
	
	//IMPORTANT: if you don't call this method, then your model states will not update
	[super requestDidFinishLoad:request];
}

- (void)dealloc {
	[_results release];
	[super dealloc];
}

- (NSArray *) results {
 return [[_results copy] autorelease];
}

- (NSInteger) numberOfPhotos {
	return [_results count];
}

- (NSInteger) maxPhotoIndex {
	return [_results count] - 1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index {
    if (index < 0 || index > [self maxPhotoIndex])
        return nil;

	id<TTPhoto> photo = [_results objectAtIndex:index];
	photo.index = index;
	photo.photoSource = self;
	return photo;
}

@end
