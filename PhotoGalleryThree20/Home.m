//
//  Home.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Home.h"


@implementation Home

//Default init override when opening with TTNavigator
- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
    if ((self = [super init])) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    self.title = @"Home";
    self.view.backgroundColor = [UIColor redColor];
}

@end
