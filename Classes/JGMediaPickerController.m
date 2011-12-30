//
//  JGMediaPickerController.m
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JGMediaPickerController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "JGMediaQueryViewController.h"

@interface JGMediaPickerController ()

@property (nonatomic, retain) UITabBarController *tabBarController;

- (void)initialSetup;

@end

@implementation JGMediaPickerController

@synthesize tabBarController;
@synthesize delegate;

- (void)dealloc {
    self.tabBarController = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[self initialSetup];
    }
    return self;
}

- (id)init {
    self = [super init];
    if(self) {
        //[self initialSetup];
    }
    return self;
}

- (void)initialSetup {
    JGMediaQueryViewController *playlistsViewController = [[[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil] autorelease];
    playlistsViewController.queryType = JGMediaQueryTypePlaylists;
    playlistsViewController.mediaQuery = [MPMediaQuery playlistsQuery];
    playlistsViewController.title = NSLocalizedString(@"Playlists", @"Playlists");
    playlistsViewController.tabBarItem.image = [UIImage imageNamed:@"first"];
    playlistsViewController.delegate = self;
    playlistsViewController.showsCancelButton = YES;
    UINavigationController *playlistsNavigationController = [[[UINavigationController alloc] initWithRootViewController:playlistsViewController] autorelease];
    
    JGMediaQueryViewController *artistsViewController = [[[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil] autorelease];
    artistsViewController.queryType = JGMediaQueryTypeArtists;
    artistsViewController.mediaQuery = [MPMediaQuery artistsQuery];
    artistsViewController.title = NSLocalizedString(@"Artists", @"Artists");
    artistsViewController.tabBarItem.image = [UIImage imageNamed:@"first"];
    artistsViewController.delegate = self;
    artistsViewController.showsCancelButton = YES;
    UINavigationController *artistsNavigationController = [[[UINavigationController alloc] initWithRootViewController:artistsViewController] autorelease];
    
    JGMediaQueryViewController *albumsViewController = [[[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil] autorelease];
    albumsViewController.queryType = JGMediaQueryTypeAlbums;
    albumsViewController.mediaQuery = [MPMediaQuery albumsQuery];
    albumsViewController.title = NSLocalizedString(@"Albums", @"Albums");
    albumsViewController.tabBarItem.image = [UIImage imageNamed:@"first"];
    albumsViewController.delegate = self;
    albumsViewController.showsCancelButton = YES;
    UINavigationController *albumsNavigationController = [[[UINavigationController alloc] initWithRootViewController:albumsViewController] autorelease];
    
    JGMediaQueryViewController *songsViewController = [[[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil] autorelease];
    songsViewController.queryType = JGMediaQueryTypeSongs;
    songsViewController.mediaQuery = [MPMediaQuery songsQuery];
    songsViewController.title = NSLocalizedString(@"Songs", @"Songs");
    songsViewController.tabBarItem.image = [UIImage imageNamed:@"first"];
    songsViewController.delegate = self;
    songsViewController.showsCancelButton = YES;
    UINavigationController *songsNavigationController = [[[UINavigationController alloc] initWithRootViewController:songsViewController] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:playlistsNavigationController, artistsNavigationController, albumsNavigationController, songsNavigationController, nil];
    [[self tabBarController] setSelectedIndex:0];
    [[self view] addSubview:self.tabBarController.view];
}

- (void)loadView {
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tabBarController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)jgMediaQueryViewController:(JGMediaQueryViewController *)mediaQueryViewController didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem {
    if([self.delegate respondsToSelector:@selector(jgMediaPicker:didPickMediaItems:selectedItem:)]) {
        [self.delegate jgMediaPicker:self didPickMediaItems:mediaItemCollection selectedItem:selectedItem];
    }
}


- (void)jgMediaQueryViewControllerDidCancel:(JGMediaQueryViewController *)mediaPicker {
    if([self.delegate respondsToSelector:@selector(jgMediaPickerDidCancel:)]) {
        [self.delegate jgMediaPickerDidCancel:self];
    }
}

@end
