//
//  MPMediaItem+JGExtensions.m
//  iTrip
//
//  Created by Jamin Guy on 11/1/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import "MPMediaItem+JGExtensions.h"

@implementation MPMediaItem (JGExtensions)

- (NSString *)jg_artist {
    return [self valueForProperty:MPMediaItemPropertyArtist];
}

- (NSString *)jg_albumArtist {
    return [self valueForProperty:MPMediaItemPropertyAlbumArtist];
}

- (NSString *)jg_title {
    return [self valueForProperty:MPMediaItemPropertyTitle];
}

- (NSString *)jg_albumTitle {
    return [self valueForProperty:MPMediaItemPropertyAlbumTitle];
}

- (NSURL *)jg_assetURL {
	return [self valueForProperty:MPMediaItemPropertyAssetURL];
}

- (NSString *)jg_persistentID {
	return [self valueForProperty:MPMediaItemPropertyPersistentID];
}

- (UIImage *)jg_artworkWithSize:(CGSize)size {
    UIImage *image = nil;
    MPMediaItemArtwork *artwork = [self valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        image = [artwork imageWithSize:size];
    }
    return image;
}

- (UIImage *)jg_artwork {
    UIImage *image = nil;
    MPMediaItemArtwork *artwork = [self valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        image = [artwork imageWithSize:artwork.bounds.size];
    }
    return image;
}

- (NSTimeInterval)jg_trackLength {
    return [[self valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
}

- (NSDate *)jg_releaseDate {
    return [self valueForProperty:MPMediaItemPropertyReleaseDate];
}

- (NSString *)jg_releaseYearString {
    return [NSString stringWithFormat:@"%@", [self valueForProperty:@"year"]];
}

- (NSNumber *)jg_trackNumber {
    return [self valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
}

- (NSString *)jg_trackLengthString {
    NSString *timeString = nil;
    const int secsPerMin = 60;
	const int minsPerHour = 60;
	const char *timeSep = ":"; //@TODO localise...
	NSTimeInterval seconds = [self jg_trackLength];
	seconds = floor(seconds);
	
	if(seconds < 60.0) {	
		timeString = [NSString stringWithFormat:@"0:%02.0f", seconds];
	}
    else {        
        int mins = seconds/secsPerMin;	
        int secs = seconds - mins*secsPerMin;
        
        if(mins < 60.0) {	
            timeString = [NSString stringWithFormat:@"%d%s%02d", mins, timeSep, secs];
        }
        else {
            int hours = mins/minsPerHour;
            mins -= hours * minsPerHour;
            timeString = [NSString stringWithFormat:@"%d%s%02d%s%02d", hours, timeSep, mins, timeSep, secs];
        }
    }
    return timeString;
}

- (BOOL)jg_assetNeedsToDownload {
	return ([self jg_assetURL] == nil);
}

- (BOOL)jg_assetHasBeenDeleted {
	if ([self jg_assetURL] == nil) {
		return NO;
	} else {
		NSString *urlString = [[self jg_assetURL] absoluteString];
		BOOL assetURLPointsNowhere = ([urlString rangeOfString:@"ipod-library://item/item.(null)"].location != NSNotFound);
		return assetURLPointsNowhere;
	}
}

- (BOOL)jg_isPlayable {
    return ![self jg_assetNeedsToDownload] && ![self jg_assetHasBeenDeleted];
}

- (BOOL)jg_existsInLibrary {
	MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[self jg_persistentID]
																		   forProperty: MPMediaItemPropertyPersistentID];
	MPMediaQuery *query = [[MPMediaQuery alloc] init];
	[query addFilterPredicate:predicate];
	BOOL exists = ([[query items] count] != 0);
	return exists;
}

@end
