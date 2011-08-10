//
//  GalleryModel.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GalleryModel.h"
#import "GDataXMLNode.h"
#import "Album.h"

@implementation GalleryModel

@synthesize category = _category;

- (id)initWithCategory:(NSString *)category {
    self = [super init];
    if (self) {
        _results = [[NSMutableArray alloc] init];
        self.category = category;
    }
    
    return self;
}

- (void)dealloc {
    [_results release];
    [_category release];
    
    [super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	
    NSString *url = [BASE_URL stringByAppendingFormat:@"%@", _category];
    TTDPRINT(@"Going to URL: %@", url);
    
	TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
	//Don't use a cache because it can be pretty dynamic content
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	id<TTURLResponse> response = [[[TTURLDataResponse alloc] init] autorelease];
	request.response = response;
    	
	//send out the request to be processed by the response parser
	[request send];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString	alloc] initWithData:response.data encoding:NSASCIIStringEncoding];
	TTDPRINT(@"Made it to the response! The response was: %@", responseBody);
    
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:response.data 
														   options:0 error:nil];
    NSArray *albums = [doc.rootElement elementsForName:@"album"];
    for (GDataXMLElement *element in albums) {
        Album *album = [[Album alloc] init];
        album.title = [[[element elementsForName:@"title"] objectAtIndex:0] stringValue];
        album.description = [[[element elementsForName:@"description"] objectAtIndex:0] stringValue];
        album.coverThumb = [[[element elementsForName:@"coverThumb"] objectAtIndex:0] stringValue];
        album.photoListURL = [[[element elementsForName:@"photolist"] objectAtIndex:0] stringValue];
        
        [_results addObject:album];
        [album release];
    }
    
    [doc release];
    [super requestDidFinishLoad:request];
}

- (NSArray *)results {
    return [[_results copy] autorelease];
}

@end
