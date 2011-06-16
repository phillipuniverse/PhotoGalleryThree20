//
//  GalleryModel.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GalleryModel.h"
#import "GDataXMLNode.h"

@implementation GalleryModel

@synthesize category = _category;

- (id)initWithCategory:(NSString *)category {
    if((self = [super init])) {
        self.category = category;
    }
    
    return self;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	
    NSString *url = [BASE_URL stringByAppendingFormat:@"%@/albums.xml", _category];
    TTDPRINT(@"Going to URL: %@", url);
    
	TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
	//Don't use a cache because it can be pretty dynamic content
	request.cachePolicy = TTURLRequestCachePolicyNoCache;
	id<TTURLResponse> response = [[[TTURLDataResponse alloc] init] autorelease];
	request.response = response;
	//request.httpMethod = @"GET";
	
	//send out the request to be processed by the response parser
	[request send];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString	alloc] initWithData:response.data encoding:NSASCIIStringEncoding];
	TTDPRINT(@"Made it to the response! The response was: %@", responseBody);
    
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:response.data 
														   options:0 error:nil];
    
    [doc release];
    [super requestDidFinishLoad:request];
}

- (NSArray *)results {
    return [[_results copy] autorelease];
}

@end
