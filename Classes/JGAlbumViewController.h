//
//  JGAlbumViewController.h
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGAlbumTrackTableViewCell, MPMediaItemCollection, MPMediaItem;

@interface JGAlbumViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (strong, nonatomic) IBOutlet UILabel *albumArtistLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumReleaseDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumTrackCountTimeLabel;

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) MPMediaItemCollection *albumCollection;

@property (weak, nonatomic) IBOutlet JGAlbumTrackTableViewCell *albumTrackTableViewCell;

@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL allowsSelectionOfNonPlayableItem;

@end

@protocol JGAlbumViewController <NSObject>
@optional

- (void)jgAlbumViewController:(JGAlbumViewController *)albumViewController didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem;

@end
