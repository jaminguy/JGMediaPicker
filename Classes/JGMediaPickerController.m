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

@interface JGMediaPickerController () <UITabBarControllerDelegate>

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UIViewController *viewController;

//Controls whether non-playable items are selectable.
@property (nonatomic, assign) BOOL allowsSelectionOfNonPlayableItem;

- (void)setupViewControllers;
- (void)updateTabBarControllerIndex;

@end

@implementation JGMediaPickerController

@synthesize viewController;
@synthesize tabBarController;
@synthesize delegate;
@synthesize selectedTabIndex;
@synthesize allowsSelectionOfNonPlayableItem;

- (id)init {
    self = [super init];
    if(self) {
        selectedTabIndex = JGMediaPickerTabIndex_Artists;
        allowsSelectionOfNonPlayableItem = YES;
        [self setupViewControllers];
    }
    return self;
}

- (void)setupViewControllers {
    JGMediaQueryViewController *playlistsViewController = [[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil];
    playlistsViewController.queryType = JGMediaQueryTypePlaylists;
    playlistsViewController.mediaQuery = [MPMediaQuery playlistsQuery];
    playlistsViewController.title = NSLocalizedString(@"Playlists", @"Playlists");
    playlistsViewController.tabBarItem.image = [UIImage imageNamed:@"Playlists.png"];
    playlistsViewController.delegate = self;
    playlistsViewController.showsCancelButton = YES;
    playlistsViewController.allowsSelectionOfNonPlayableItem = self.allowsSelectionOfNonPlayableItem;
    UINavigationController *playlistsNavigationController = [[UINavigationController alloc] initWithRootViewController:playlistsViewController];
    
    JGMediaQueryViewController *artistsViewController = [[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil];
    artistsViewController.queryType = JGMediaQueryTypeArtists;
    artistsViewController.mediaQuery = [MPMediaQuery artistsQuery];
    artistsViewController.title = NSLocalizedString(@"Artists", @"Artists");
    artistsViewController.tabBarItem.image = [UIImage imageNamed:@"Artists.png"];
    artistsViewController.delegate = self;
    artistsViewController.showsCancelButton = YES;
    artistsViewController.allowsSelectionOfNonPlayableItem = self.allowsSelectionOfNonPlayableItem;
    UINavigationController *artistsNavigationController = [[UINavigationController alloc] initWithRootViewController:artistsViewController];
    
    JGMediaQueryViewController *albumsViewController = [[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil];
    albumsViewController.queryType = JGMediaQueryTypeAlbums;
    albumsViewController.mediaQuery = [MPMediaQuery albumsQuery];
    albumsViewController.title = NSLocalizedString(@"Albums", @"Albums");
    albumsViewController.tabBarItem.image = [UIImage imageNamed:@"Albums.png"];
    albumsViewController.delegate = self;
    albumsViewController.showsCancelButton = YES;
    albumsViewController.allowsSelectionOfNonPlayableItem = self.allowsSelectionOfNonPlayableItem;
    UINavigationController *albumsNavigationController = [[UINavigationController alloc] initWithRootViewController:albumsViewController];
    
    JGMediaQueryViewController *songsViewController = [[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil];
    songsViewController.queryType = JGMediaQueryTypeSongs;
    songsViewController.mediaQuery = [MPMediaQuery songsQuery];
    songsViewController.title = NSLocalizedString(@"Songs", @"Songs");
    songsViewController.tabBarItem.image = [UIImage imageNamed:@"Songs.png"];
    songsViewController.delegate = self;
    songsViewController.showsCancelButton = YES;
    songsViewController.allowsSelectionOfNonPlayableItem = self.allowsSelectionOfNonPlayableItem;
    UINavigationController *songsNavigationController = [[UINavigationController alloc] initWithRootViewController:songsViewController];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:playlistsNavigationController, artistsNavigationController, albumsNavigationController, songsNavigationController, nil];
    self.tabBarController.delegate = self;
    [self updateTabBarControllerIndex];

    self.viewController = self.tabBarController;
}

- (void)setSelectedTabIndex:(JGMediaPickerTabIndex)newTabIndex {
    if(selectedTabIndex != newTabIndex) {
        selectedTabIndex = newTabIndex;
        [self updateTabBarControllerIndex];
    }
}

- (void)updateTabBarControllerIndex {
    if(self.tabBarController.selectedIndex != selectedTabIndex) {
        self.tabBarController.selectedIndex = selectedTabIndex;
    }
}

- (void)tabBarController:(UITabBarController *)aTabBarController didSelectViewController:(UIViewController *)viewController {
    self.selectedTabIndex = aTabBarController.selectedIndex;
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
