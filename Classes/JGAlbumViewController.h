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

@property (retain, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (retain, nonatomic) IBOutlet UILabel *albumArtistLabel;
@property (retain, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *albumReleaseDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *albumTrackCountTimeLabel;

@property (retain, nonatomic) id delegate;
@property (retain, nonatomic) MPMediaItemCollection *albumCollection;

@property (assign, nonatomic) IBOutlet JGAlbumTrackTableViewCell *albumTrackTableViewCell;

@end

@protocol JGAlbumViewController <NSObject>
@optional

- (void)jgAlbumViewController:(JGAlbumViewController *)albumViewController didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem;

@end
