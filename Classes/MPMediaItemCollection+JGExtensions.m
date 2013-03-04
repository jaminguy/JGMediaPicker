//
//  MPMediaItemCollection+JGExtensions.m
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MPMediaItemCollection+JGExtensions.h"
#import "MPMediaItem+JGExtensions.h"

@implementation MPMediaItemCollection (JGExtensions)

- (NSNumber *)jg_playbackLength {
    double totalTime = 0;
    for (MPMediaItem *mediaItem in self.items) {
        totalTime += [mediaItem jg_trackLength];
    }
    return [NSNumber numberWithDouble:totalTime];
}

- (BOOL)jg_hasNoLocalItems {
	for (MPMediaItem *mediaItem in self.items) {
		if ([mediaItem jg_existsInLibrary] && ![mediaItem jg_assetNeedsToDownload])
			return NO;
	}
	return YES;
}

- (BOOL)jg_hasNoPlayableItems {
	for (MPMediaItem *mediaItem in self.items) {
		if ([mediaItem jg_existsInLibrary] && ![mediaItem jg_assetHasBeenDeleted])
			return NO;
	}
	return YES;
}

@end
