//
//  Home.m
//  PhotoGalleryThree20
//
//  Created by Phillip Verheyden on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Home.h"
#import "GalleryViewController.h"

@implementation Home

#pragma mark UIViewController Additions
//Default init override when opening with TTNavigator
- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
    if ((self = [super initWithNavigatorURL:URL query:query])) {
        
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController
- (void)loadView {
    //Called in order to instantiate this viewcontroller's view
    [super loadView];
    
    TTLauncherView *launcher = [[TTLauncherView alloc] initWithFrame:self.view.bounds];
    launcher.backgroundColor = [UIColor blackColor];
    launcher.delegate = self;
    launcher.columnCount = 3;
    launcher.pages = [NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                                [[[TTLauncherItem alloc] initWithTitle:@"Nature" image:@"bundle://launcher-icon.jpg" URL:@"nature" canDelete:NO] autorelease], 
                                                [[[TTLauncherItem alloc] initWithTitle:@"ATVs" image:@"bundle://launcher-icon.jpg" URL:@"atvs" canDelete:NO] autorelease], 
                                                [[[TTLauncherItem alloc] initWithTitle:@"Sports" image:@"bundle://launcher-icon.jpg" URL:@"sports" canDelete:NO] autorelease],
                                                nil],
                      nil];
    
    [self.view addSubview:launcher];
}

- (void)viewDidLoad {
    self.title = @"Home";
    
}

#pragma mark -
#pragma mark TTLauncherViewDelegate
- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
    NSString *category = item.URL;
    GalleryViewController *albums = [[GalleryViewController alloc] initWithCategory:category];
    [self.navigationController pushViewController:albums animated:YES];
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:launcher action:@selector(endEditing)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
    self.navigationItem.rightBarButtonItem = nil;
}


@end
