//
//  MPMediaItem+JGExtensions.h
//  iTrip
//
//  Created by Jamin Guy on 11/1/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaItem (JGExtensions)

- (NSString *)jg_artist;
- (NSString *)jg_albumArtist;
- (NSString *)jg_title;
- (NSString *)jg_albumTitle;
- (NSURL *)jg_assetURL;
- (NSString *)jg_persistentID;
- (UIImage *)jg_artworkWithSize:(CGSize)size;
- (UIImage *)jg_artwork;
- (NSTimeInterval)jg_trackLength;
- (NSDate *)jg_releaseDate;
- (NSString *)jg_releaseYearString;
- (NSNumber *)jg_trackNumber;
- (NSString *)jg_trackLengthString;

// Returns YES if the asset for this mediaItem has not 
// been downloaded to this device's library from the cloud.
// Otherwise NO. This method will always return YES if 
// iTunes Match is turned off.
- (BOOL)jg_assetNeedsToDownload;

// Returns YES if the asset has been deleted via iTunes, or
// the built-in Music app. Otherwise NO. This method will 
// always return NO if iTunes Match is turned on.
- (BOOL)jg_assetHasBeenDeleted;

// Returns YES if this mediaItem still exists in the device's
// library. Otherwise NO. Will return NO if this mediaItem 
// once represented an asset in the cloud, but since then iTunes 
// Match has been turned off.
- (BOOL)jg_existsInLibrary;

// Returns YES if this mediaItem does not need downloading and 
// has not been deleted.  Returns NO otherwise.
- (BOOL)jg_isPlayable;

@end
