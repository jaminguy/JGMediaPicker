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
#import "JGAlbumViewController.h"

@interface JGMediaQueryViewController () 

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSArray *itemSections;

- (void)updateItems;

- (void)notifyDelegateOfSelection:(MPMediaItemCollection *)mediaItems selectedItem:(MPMediaItem *)selectedItem;
- (void)notifyDelegateOfCancellation;

@end

@implementation JGMediaQueryViewController

#define kPlaylistCellHeight 44.0
#define kAlbumCellHeight 55.0
#define kArtistCellHeight 44.0
#define kSongCellHeight 44.0
#define kAlbumArtSize CGSizeMake(110.0, 110.0)

#define kItemCountThresholdForTableViewSections 25

@synthesize itemTableView;
@synthesize items;
@synthesize itemSections;
@synthesize delegate;
@synthesize queryType;
@synthesize mediaQuery;
@synthesize showsCancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
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
        [mediaQuery release];
        mediaQuery = [newMediaQuery retain];
        [self updateItems];
    }
}

- (void)updateItems {
    MPMediaQuery *query  = self.mediaQuery;
    if(query) {
        switch (self.queryType) {
            case JGMediaQueryTypePlaylists: 
            case JGMediaQueryTypeAlbumArtist: {
                self.items = [query collections];
                self.itemSections = nil;
            }break;
                
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

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.showsCancelButton) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTap:)] autorelease];
    }
    
    [[self itemTableView] reloadData];
}

- (void)viewDidUnload {
    [self setItemTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self itemTableView] deselectRowAtIndexPath:[[self itemTableView] indexPathForSelectedRow] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [itemTableView release];
    [super dealloc];
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
    static NSString *PlaylistCellIdentifier = @"PlaylistCell";
    static NSString *ArtistCellIdentifier = @"ArtistCell";
    static NSString *AlbumCellIdentifier = @"AlbumCell";
    static NSString *SongCellIdentifier = @"SongCell";
    
    UITableViewCell *cell = nil;
    switch (self.queryType) {

        case JGMediaQueryTypePlaylists: {            
            cell = [tableView dequeueReusableCellWithIdentifier:PlaylistCellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlaylistCellIdentifier] autorelease];        
            }
        }break;
            
        case JGMediaQueryTypeArtists: {
            cell = [tableView dequeueReusableCellWithIdentifier:ArtistCellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ArtistCellIdentifier] autorelease];        
            }
        }break;
            
        case JGMediaQueryTypeAlbums:
        case JGMediaQueryTypeAlbumArtist: {
            cell = [tableView dequeueReusableCellWithIdentifier:AlbumCellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AlbumCellIdentifier] autorelease];        
            }
        }break;
            
        case JGMediaQueryTypeSongs: {
            cell = [tableView dequeueReusableCellWithIdentifier:SongCellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SongCellIdentifier] autorelease];        
            }
        }break;
            
        default:
            break;
    }

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
            [[cell textLabel] setText:[playlist name]];
        }break;
            
        case JGMediaQueryTypeArtists: {
            [[cell textLabel] setText:[mediaItem artist]];
        }break;
            
        case JGMediaQueryTypeAlbums:
        case JGMediaQueryTypeAlbumArtist: {
            [[cell textLabel] setText:[mediaItem albumTitle]];
            [[cell detailTextLabel] setText:[mediaItem albumArtist]];
            UIImage *albumImage = [mediaItem artworkWithSize:kAlbumArtSize] ?: [UIImage imageNamed:@"AlbumArtPlaceholder.png"];
            [[cell imageView] setImage:albumImage];
        }break;
            
        case JGMediaQueryTypeSongs: {
            [[cell textLabel] setText:[mediaItem title]];
            NSString *subTitle = [NSString stringWithFormat:@"%@ - %@", [mediaItem albumTitle], [mediaItem albumArtist]];
            [[cell detailTextLabel] setText:subTitle];
        }break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (self.queryType) {
        case JGMediaQueryTypePlaylists: {
            height = 44.0;
        }break;
            
        case JGMediaQueryTypeArtists: {
            height = 44.0;
        }break;
            
        case JGMediaQueryTypeAlbums:
        case JGMediaQueryTypeAlbumArtist: {
            height = 55.0;
        }break;
            
        case JGMediaQueryTypeSongs: {
            height = 44.0;
        }break;
            
        default:
            height = 44.0;
            break;
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
            NSNumber *playlistPersistentID = [playlist persistentID];
            NSString *playlistName = [playlist name];
            
            MPMediaQuery *playlistQuery = [[MPMediaQuery alloc] init];
            MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:playlistPersistentID forProperty:MPMediaPlaylistPropertyPersistentID comparisonType:MPMediaPredicateComparisonEqualTo];
            [playlistQuery addFilterPredicate:predicate];
            
            JGMediaQueryViewController *playlistViewController = [[[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil] autorelease];
            playlistViewController.title = playlistName;
            playlistViewController.queryType = JGMediaQueryTypeSongs;
            playlistViewController.mediaQuery = playlistQuery;
            playlistViewController.delegate = self;
            [playlistQuery release];
            viewController = playlistViewController;
        }break;
            
        case JGMediaQueryTypeArtists: {
            MPMediaItemCollection *mediaItemCollection = [[self items] objectAtIndex:itemIndex];
            NSString *artist = [[mediaItemCollection representativeItem] artist];
            MPMediaQuery *albumsQuery = [[MPMediaQuery alloc] init];
            MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyAlbumArtist comparisonType:MPMediaPredicateComparisonEqualTo];
            [albumsQuery addFilterPredicate:predicate];
            albumsQuery.groupingType = MPMediaGroupingAlbum;
            
            JGMediaQueryViewController *albumsViewController = [[[JGMediaQueryViewController alloc] initWithNibName:@"JGMediaQueryViewController" bundle:nil] autorelease];
            albumsViewController.title = artist;
            albumsViewController.queryType = JGMediaQueryTypeAlbums;
            albumsViewController.mediaQuery = albumsQuery;
            albumsViewController.delegate = self;
            [albumsQuery release];
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
            JGAlbumViewController *albumViewController = [[[JGAlbumViewController alloc] initWithNibName:@"JGAlbumViewController" bundle:nil] autorelease];
            MPMediaItemCollection *albumCollection = [[self items] objectAtIndex:itemIndex];
            albumViewController.albumCollection = albumCollection;
            albumViewController.delegate = self;
            viewController = albumViewController;
        }break;
            
        default:
            break;
    }
    
    if(viewController) {
        [[self navigationController] pushViewController:viewController animated:YES];
    }
     
}

#pragma jgMediaQueryViewControllerDelegate callbacks
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

#pragma JGAlbumViewControllerDelegate callback
- (void)jgAlbumViewController:(JGAlbumViewController *)albumViewController didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem {
    [self notifyDelegateOfSelection:mediaItemCollection selectedItem:selectedItem];
}

@end
