//
//  ItemsViewController.m
//  MusicBrowser
//
//  Created by Jamin Guy on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JGMediaQueryViewController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MPMediaItem+JGExtensions.h"
#import "MPMediaPlaylist+JGExtensions.h"
#import "UIImage+JGExtensions.h"
#import "JGAlbumViewController.h"
#import "JGMediaQueryTableViewCell.h"

@interface JGMediaQueryViewController () 

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *itemSections;

@property (nonatomic, strong) UIImage *albumPlaceholderImage;
@property (nonatomic, strong) UIImage *songPlaceholderImage;


- (void)updateItems;

- (void)notifyDelegateOfSelection:(MPMediaItemCollection *)mediaItems selectedItem:(MPMediaItem *)selectedItem;
- (void)notifyDelegateOfCancellation;

@end

@implementation JGMediaQueryViewController

#define kPlaylistCellHeight 96.0
#define kAlbumCellHeight 96.0
#define kArtistCellHeight 96.0
#define kSongCellHeight 58.0

#define kSongArtSize CGSizeMake(50.0, 50.0)
#define kAlbumArtSize CGSizeMake(88.0, 88.0)

#define kItemCountThresholdForTableViewSections 25

static NSString *PlaylistCellIdentifier = @"PlaylistCell";
static NSString *ArtistCellIdentifier = @"ArtistCell";
static NSString *AlbumCellIdentifier = @"AlbumCell";
static NSString *SongCellIdentifier = @"SongCell";

@synthesize itemTableView;
@synthesize items;
@synthesize itemSections;
@synthesize delegate;
@synthesize queryType;
@synthesize mediaQuery;
@synthesize showsCancelButton;
@synthesize allowsSelectionOfNonPlayableItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.albumPlaceholderImage = [UIImage imageWithColor:[UIColor colorWithWhite:0.98 alpha:1.0] size:kAlbumArtSize];
        self.songPlaceholderImage = [UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:1.0] size:kSongArtSize];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)setQueryType:(JGMediaQueryType)newQueryType {
    queryType = newQueryType;
    [self updateItems];
}

- (void)setMediaQuery:(MPMediaQuery *)newMediaQuery {
    if(mediaQuery != newMediaQuery) {
        mediaQuery = newMediaQuery;
        [self updateItems];
    }
}

- (void)updateItems {
    MPMediaQuery *query = self.mediaQuery;
    if(query) {
        switch (self.queryType) {
            //don't ever want sections for these types
            case JGMediaQueryTypePlaylists: 
            case JGMediaQueryTypeAlbumArtist: {
                self.items = [query collections];
                self.itemSections = nil;
            }break;
                
            //do wan't sections for these types if item count passes threshold
            case JGMediaQueryTypeArtists: 
            case JGMediaQueryTypeAlbums: 
            case JGMediaQueryTypeSongs: {
                self.items = [query collections];
                if(self.items.count > kItemCountThresholdForTableViewSections) {
                    self.itemSections = [query collectionSections];
                    if(self.itemSections.count <= 1) {
                        self.itemSections = nil;
                    }
                }
            }break;
                
            default:
                break;
        }
        
        [[self itemTableView] reloadData];
    }
}

- (NSString *)cellIdentifierForQueryType:(JGMediaQueryType)type {
    switch (type) {
        case JGMediaQueryTypePlaylists:
            return PlaylistCellIdentifier;
        case JGMediaQueryTypeArtists:
            return ArtistCellIdentifier;
        case JGMediaQueryTypeAlbums:
        case JGMediaQueryTypeAlbumArtist:
            return AlbumCellIdentifier;
        case JGMediaQueryTypeSongs:
            return SongCellIdentifier;
    }
}

- (void)notifyDelegateOfSelection:(MPMediaItemCollection *)mediaItems selectedItem:(MPMediaItem *)selectedItem {
    if([self.delegate respondsToSelector:@selector(jgMediaQueryViewController:didPickMediaItems:selectedItem:)]) {
        [self.delegate jgMediaQueryViewController:self didPickMediaItems:mediaItems selectedItem:selectedItem];
    }
}

- (void)notifyDelegateOfCancellation {
    if([self.delegate respondsToSelector:@selector(jgMediaQueryViewControllerDidCancel:)]) {
        [self.delegate jgMediaQueryViewControllerDidCancel:self];
    }
}

- (void)cancelButtonTap:(id)sender {
    [self notifyDelegateOfCancellation];
}

- (void)mediaLibraryDidChange:(NSNotification *)notification {
    [self updateItems];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.itemTableView registerClass:[JGMediaQueryTableViewCell class] forCellReuseIdentifier:PlaylistCellIdentifier];
    [self.itemTableView registerClass:[JGMediaQueryTableViewCell class] forCellReuseIdentifier:ArtistCellIdentifier];
    [self.itemTableView registerClass:[JGMediaQueryTableViewCell class] forCellReuseIdentifier:AlbumCellIdentifier];
    [self.itemTableView registerClass:[JGMediaQueryTableViewCell class] forCellReuseIdentifier:SongCellIdentifier];
    
    if(self.showsCancelButton) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTap:)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaLibraryDidChange:) name:MPMediaLibraryDidChangeNotification object:nil];
    [[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
}

- (void)viewDidUnload {
    [self setItemTableView:nil];
    [[MPMediaLibrary defaultMediaLibrary] endGeneratingLibraryChangeNotifications];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self itemTableView] deselectRowAtIndexPath:[[self itemTableView] indexPathForSelectedRow] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = self.itemSections.count;    
    return numberOfSections > 0 ? numberOfSections : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = nil;    
    if(self.itemSections.count) {
        MPMediaQuerySection *querySection = [[self itemSections] objectAtIndex:section];
        sectionTitle = querySection.title;
    }    
    return sectionTitle;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *sectionIndexTitles = nil;
    if(self.itemSections.count) {
        sectionIndexTitles = [NSMutableArray arrayWithCapacity:self.itemSections.count];
        [[self itemSections] enumerateObjectsUsingBlock:^(MPMediaQuerySection *querySection, NSUInteger idx, BOOL *stop) {
            [sectionIndexTitles addObject:[querySection title]];
        }];
    }
    return  sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    __block NSInteger sectionIndex = 0;
    [[self itemSections] enumerateObjectsUsingBlock:^(MPMediaQuerySection *querySection, NSUInteger idx, BOOL *stop) {
        if([[querySection title] isEqualToString:title]) {
            sectionIndex = idx;
            *stop = YES;
        }
    }];
    
    return sectionIndex;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = self.items.count;
    if(self.itemSections.count) {
        MPMediaQuerySection *querySection = [[self itemSections] objectAtIndex:section];
        numberOfRows = querySection.range.length;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForQueryType:self.queryType] forIndexPath:indexPath];
    
    NSInteger itemIndex = indexPath.row;
    if(self.itemSections.count) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        MPMediaQuerySection *querySection = [[self itemSections] objectAtIndex:indexPath.section];
        itemIndex = querySection.range.location + indexPath.row;        
    }
    else if(self.queryType == JGMediaQueryTypeSongs) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    
    MPMediaItemCollection *mediaItemCollection = [[self items] objectAtIndex:itemIndex];
    MPMediaItem *mediaItem = [mediaItemCollection representativeItem];
    
    switch (self.queryType) {
            
        case JGMediaQueryTypePlaylists: {
            MPMediaPlaylist *playlist = (MPMediaPlaylist *)mediaItemCollection;            
            [[cell textLabel] setText:[playlist jg_name]];
            [[cell imageView] setImage:self.albumPlaceholderImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *representativeImage = [mediaItem jg_artworkWithSize:kAlbumArtSize];
                if (representativeImage) {
                    [[cell imageView] setImage:representativeImage];
                    [cell setNeedsLayout];
                }
            });
        }break;
            
        case JGMediaQueryTypeArtists: {
            [[cell textLabel] setText:[mediaItem jg_artist]];
            [[cell imageView] setImage:self.albumPlaceholderImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *representativeImage = [mediaItem jg_artworkWithSize:kAlbumArtSize];
                if (representativeImage) {
                    [[cell imageView] setImage:representativeImage];
                    [cell setNeedsLayout];
                }
            });
        }break;
            
        case JGMediaQueryTypeAlbums:
        case JGMediaQueryTypeAlbumArtist: {
            [[cell textLabel] setText:[mediaItem jg_albumTitle]];
            [[cell detailTextLabel] setText:[mediaItem jg_albumArtist]];
            [[cell imageView] setImage:self.albumPlaceholderImage];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *representativeImage = [mediaItem jg_artworkWithSize:kAlbumArtSize];
                if (representativeImage) {
                    [[cell imageView] setImage:representativeImage];
                    [cell setNeedsLayout];
                }
            });
        }break;
            
        case JGMediaQueryTypeSongs: {
            [[cell textLabel] setText:[mediaItem jg_title]];
            NSString *subTitle = [NSString stringWithFormat:@"%@ - %@", [mediaItem jg_albumTitle], [mediaItem jg_albumArtist]];
            [[cell detailTextLabel] setText:subTitle];
            [[cell imageView] setImage:self.songPlaceholderImage];

            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *representativeImage = [mediaItem jg_artworkWithSize:kSongArtSize];
                if (representativeImage) {
                    [[cell imageView] setImage:representativeImage];
                    [cell setNeedsLayout];
                }
            });
            
            if (!self.allowsSelectionOfNonPlayableItem && ![mediaItem jg_isPlayable]) {
                cell.userInteractionEnabled = NO;
                for (UILabel *label in [NSArray arrayWithObjects:[cell textLabel], [cell detailTextLabel], nil]) {
                    label.textColor = [UIColor lightGrayColor];
                }
            }
            
        }break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0;
    switch (self.queryType) {
        case JGMediaQueryTypePlaylists: {
            height = kPlaylistCellHeight;
        }break;
            
        case JGMediaQueryTypeArtists: {
            height = kArtistCellHeight;
        }break;
            
        case JGMediaQueryTypeAlbums:
        case JGMediaQueryTypeAlbumArtist: {
            height = kAlbumCellHeight;
        }break;
            
        case JGMediaQueryTypeSongs: {
            height = kSongCellHeight;
        }break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = nil;
    NSInteger itemIndex = indexPath.row;
    if(self.itemSections.count) {
        MPMediaQuerySection *querySection = [[self itemSections] objectAtIndex:indexPath.section];
        itemIndex = querySection.range.location + indexPath.row;        
    }
    
    switch (self.queryType) {
        case JGMediaQueryTypePlaylists: {
            MPMediaPlaylist *playlist = (MPMediaPlaylist *)[[self items] objectAtIndex:itemIndex];
            NSNumber *playlistPersistentID = [playlist jg_persistentID];
            NSString *playlistName = [playlist jg_name];
            
            MPMediaQuery *playlistQuery = [[MPMediaQuery alloc] init];
            MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:playlistPersistentID forProperty:MPMediaPlaylistPropertyPersistentID comparisonType:MPMediaPredicateComparisonEqualTo];
            [playlistQuery addFilterPredicate:predicate];
            
            JGMediaQueryViewController *playlistViewController = [[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil];
            playlistViewController.showsCancelButton = YES;
            playlistViewController.allowsSelectionOfNonPlayableItem = self.allowsSelectionOfNonPlayableItem;
            playlistViewController.title = playlistName;
            playlistViewController.queryType = JGMediaQueryTypeSongs;
            playlistViewController.mediaQuery = playlistQuery;
            playlistViewController.delegate = self;
            viewController = playlistViewController;
        }break;
            
        case JGMediaQueryTypeArtists: {
            MPMediaItemCollection *mediaItemCollection = [[self items] objectAtIndex:itemIndex];
            NSString *artist = [[mediaItemCollection representativeItem] jg_artist];
            MPMediaQuery *albumsQuery = [[MPMediaQuery alloc] init];
            MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyArtist comparisonType:MPMediaPredicateComparisonEqualTo];
            [albumsQuery addFilterPredicate:predicate];
            albumsQuery.groupingType = MPMediaGroupingAlbum;
            
            JGMediaQueryViewController *albumsViewController = [[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil];
            albumsViewController.showsCancelButton = YES;
            albumsViewController.allowsSelectionOfNonPlayableItem = self.allowsSelectionOfNonPlayableItem;
            albumsViewController.title = artist;
            albumsViewController.queryType = JGMediaQueryTypeAlbums;
            albumsViewController.mediaQuery = albumsQuery;
            albumsViewController.delegate = self;
            viewController = albumsViewController;
        }break;
            
        case JGMediaQueryTypeSongs: {
            if([self.delegate respondsToSelector:@selector(jgMediaQueryViewController:didPickMediaItems:selectedItem:)]) {
                MPMediaItemCollection *selectedMediaItemCollection = [[self items] objectAtIndex:itemIndex];
                MPMediaItem *selectedMediaItem = [selectedMediaItemCollection representativeItem];

                NSMutableArray *songsArray = [NSMutableArray arrayWithCapacity:selectedMediaItemCollection.count];
                for (MPMediaItemCollection *mediaItemCollection in [self items]) {
                    [songsArray addObject:[mediaItemCollection representativeItem]];
                }
                MPMediaItemCollection *mediaItemCollection = [MPMediaItemCollection collectionWithItems:songsArray];
                [self.delegate jgMediaQueryViewController:self didPickMediaItems:mediaItemCollection selectedItem:selectedMediaItem];
            }
        }break;
            
        case JGMediaQueryTypeAlbums:    
        case JGMediaQueryTypeAlbumArtist: {            
            JGAlbumViewController *albumViewController = [[JGAlbumViewController alloc] initWithNibName:@"JGAlbumViewController" bundle:nil];
            albumViewController.showsCancelButton = YES;
            albumViewController.allowsSelectionOfNonPlayableItem = self.allowsSelectionOfNonPlayableItem;
            MPMediaItemCollection *albumCollection = [[self items] objectAtIndex:itemIndex];
            albumViewController.delegate = self;
            albumViewController.albumCollection = albumCollection;
            viewController = albumViewController;
        }break;
            
        default:
            break;
    }
    
    if(viewController) {
        [[self navigationController] pushViewController:viewController animated:YES];
    }
     
}

#pragma mark - jgMediaQueryViewControllerDelegate callbacks
- (void)jgMediaQueryViewController:(JGMediaQueryViewController *)mediaQueryViewController didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem {
    if([self.delegate respondsToSelector:@selector(jgMediaQueryViewController:didPickMediaItems:selectedItem:)]) {
        [self.delegate jgMediaQueryViewController:self didPickMediaItems:mediaItemCollection selectedItem:selectedItem];
    }
}

- (void)jgMediaQueryViewControllerDidCancel:(JGMediaQueryViewController *)mediaPicker {
    if([self.delegate respondsToSelector:@selector(jgMediaQueryViewControllerDidCancel:)]) {
        [self.delegate jgMediaQueryViewControllerDidCancel:self];
    }
}

#pragma mark - JGAlbumViewControllerDelegate callback
- (void)jgAlbumViewController:(JGAlbumViewController *)albumViewController didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem {
    [self notifyDelegateOfSelection:mediaItemCollection selectedItem:selectedItem];
}

@end
