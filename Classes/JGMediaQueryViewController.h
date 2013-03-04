//
//  ItemsViewController.h
//  MusicBrowser
//
//  Created by Jamin Guy on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMediaQuery, MPMediaItemCollection, MPMediaItem;

typedef enum {
    JGMediaQueryTypePlaylists,
    JGMediaQueryTypeArtists,
    JGMediaQueryTypeAlbums,
    JGMediaQueryTypeSongs,
    JGMediaQueryTypeAlbumArtist
} JGMediaQueryType;

@interface JGMediaQueryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *itemTableView;

@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) JGMediaQueryType queryType;
@property (nonatomic, strong) MPMediaQuery *mediaQuery;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL allowsSelectionOfNonPlayableItem;

@end

@protocol JGMediaQueryViewControllerDelegate <NSObject>
@optional

- (void)jgMediaQueryViewController:(JGMediaQueryViewController *)mediaQueryViewController didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem;
- (void)jgMediaQueryViewControllerDidCancel:(JGMediaQueryViewController *)mediaPicker;

@end
