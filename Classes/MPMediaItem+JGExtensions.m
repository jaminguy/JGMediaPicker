//
//  MPMediaItem+JGExtensions.m
//  iTrip
//
//  Created by Jamin Guy on 11/1/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import "MPMediaItem+JGExtensions.h"

@implementation MPMediaItem (JGExtensions)

- (NSString *)artist {
    return [self valueForProperty:MPMediaItemPropertyArtist];
}

- (NSString *)albumArtist {
    return [self valueForProperty:MPMediaItemPropertyAlbumArtist];
}

- (NSString *)title {
    return [self valueForProperty:MPMediaItemPropertyTitle];
}

- (NSString *)albumTitle {
    return [self valueForProperty:MPMediaItemPropertyAlbumTitle];
}

- (NSURL *)assetURL {
	return [self valueForProperty:MPMediaItemPropertyAssetURL];
}

- (NSString *)persistentID {
	return [self valueForProperty:MPMediaItemPropertyPersistentID];
}

- (UIImage *)artworkWithSize:(CGSize)size {
    UIImage *image = nil;
    MPMediaItemArtwork *artwork = [self valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        image = [artwork imageWithSize:size];
    }
    return image;
}

- (UIImage *)artwork {
    UIImage *image = nil;
    MPMediaItemArtwork *artwork = [self valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        image = [artwork imageWithSize:artwork.bounds.size];
    }
    return image;
}

- (NSTimeInterval)trackLength {
    return [[self valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
}

- (NSDate *)releaseDate {
    return [self valueForProperty:MPMediaItemPropertyReleaseDate];
}

- (NSString *)releaseYearString {
    return [NSString stringWithFormat:@"%@", [self valueForProperty:@"year"]];
}

- (NSNumber *)trackNumber {
    return [self valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
}

- (NSString *)trackLengthString {
    NSString *timeString = nil;
    const int secsPerMin = 60;
	const int minsPerHour = 60;
	const char *timeSep = ":"; //@TODO localise...
	NSTimeInterval seconds = [self trackLength];
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

- (BOOL)assetNeedsToDownload {
	return ([self assetURL] == nil);
}

- (BOOL)assetHasBeenDeleted {
	if ([self assetURL] == nil) {
		return NO;
	} else {
		NSString *urlString = [[self assetURL] absoluteString];
		BOOL assetURLPointsNowhere = ([urlString rangeOfString:@"ipod-library://item/item.(null)"].location != NSNotFound);
		return assetURLPointsNowhere;
	}
}

- (BOOL)existsInLibrary {
	MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[self persistentID]
																		   forProperty: MPMediaItemPropertyPersistentID];
	MPMediaQuery *query = [[MPMediaQuery alloc] init];
	[query addFilterPredicate:predicate];
	BOOL exists = ([[query items] count] != 0);
	return exists;
}

@end
