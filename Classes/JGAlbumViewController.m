//
//  JGAlbumViewController.m
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JGAlbumViewController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MPMediaItem+JGExtensions.h"
#import "MPMediaItemCollection+JGExtensions.h"
#import "JGAlbumTrackTableViewCell.h"

@interface JGAlbumViewController ()

- (void)updateUI;

@end

@implementation JGAlbumViewController

#define kSeparatorColor [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]
#define kGrayBackgroundColor [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]

@synthesize albumArtImageView;
@synthesize albumArtistLabel;
@synthesize albumTitleLabel;
@synthesize albumReleaseDateLabel;
@synthesize albumTrackCountTimeLabel;
@synthesize albumTrackTableViewCell;

@synthesize delegate;
@synthesize albumCollection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[self tableView] setSeparatorColor:kSeparatorColor];
}

- (void)viewDidUnload
{
    [self setAlbumArtImageView:nil];
    [self setAlbumArtistLabel:nil];
    [self setAlbumTitleLabel:nil];
    [self setAlbumReleaseDateLabel:nil];
    [self setAlbumTrackCountTimeLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)updateUI {
    MPMediaItem *mediaItem = [[self albumCollection] representativeItem];
    if(mediaItem) {
        self.title = [mediaItem artist];
        self.albumArtistLabel.text = [mediaItem artist];
        self.albumTitleLabel.text = [mediaItem albumTitle];
        self.albumArtImageView.image = [mediaItem artworkWithSize:self.albumArtImageView.bounds.size] ?: [UIImage imageNamed:@"AlbumArtPlaceholderLarge.png"];
        
        NSString *yearString = [mediaItem releaseYearString];
        self.albumReleaseDateLabel.text = yearString ? [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Released", @"Released"), yearString] : nil;
        NSNumber *totalTimeInSeconds = [[self albumCollection] playbackLength];
        NSInteger totalTimeInMinutes = (NSInteger)[totalTimeInSeconds doubleValue] / 60;
        self.albumTrackCountTimeLabel.text = [NSString stringWithFormat:@"%d Songs, %d Mins.", self.albumCollection.count, totalTimeInMinutes];
    }
}

- (void)setAlbumCollection:(MPMediaItemCollection *)newAlbumCollection {
    if(newAlbumCollection != albumCollection) {
        [albumCollection release];
        albumCollection = [newAlbumCollection retain];
        [self.tableView reloadData];
        [self updateUI];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumCollection.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlbumTrackCell";
    JGAlbumTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"JGAlbumTrackTableViewCell" owner:self options:nil];
        cell = self.albumTrackTableViewCell;
        self.albumTrackTableViewCell = nil;
    }
    
    MPMediaItem *mediaItem = [[[self albumCollection] items] objectAtIndex:indexPath.row];
    cell.trackNumberLabel.text = [NSString stringWithFormat:@"%d",[[mediaItem trackNumber] intValue]];
    cell.trackNameLabel.text = [mediaItem title];
    cell.trackLengthLabel.text = [mediaItem trackLengthString];

    //make odd rows gray    
    cell.contentView.backgroundColor = indexPath.row % 2 != 0 ? kGrayBackgroundColor : [UIColor whiteColor];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPMediaItem *selectedItem = [self.albumCollection.items objectAtIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(jgAlbumViewController:didPickMediaItems:selectedItem:)]) {
        [self.delegate jgAlbumViewController:self didPickMediaItems:self.albumCollection selectedItem:selectedItem];
    }
}

- (void)dealloc {
    [albumArtImageView release];
    [albumArtistLabel release];
    [albumTitleLabel release];
    [albumReleaseDateLabel release];
    [albumTrackCountTimeLabel release];
    [super dealloc];
}
@end
