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

- (NSNumber *)playbackLength {
    double totalTime = 0;
    for (MPMediaItem *mediaItem in self.items) {
        totalTime += [mediaItem trackLength];
    }
    return [NSNumber numberWithDouble:totalTime];
}

- (BOOL)hasNoLocalItems {
	for (MPMediaItem *mediaItem in self.items) {
		if ([mediaItem existsInLibrary] && ![mediaItem assetNeedsToDownload])
			return NO;
	}
	return YES;
}

- (BOOL)hasNoPlayableItems {
	for (MPMediaItem *mediaItem in self.items) {
		if ([mediaItem existsInLibrary] && ![mediaItem assetHasBeenDeleted])
			return NO;
	}
	return YES;
}

@end
