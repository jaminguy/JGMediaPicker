//
//  MPMediaItemCollection+JGExtensions.h
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaItemCollection (JGExtensions)

- (NSNumber *)playbackLength;

// Returns YES if none of the assets represented in 
// this collection have been downloaded from the cloud.
- (BOOL)hasNoLocalItems;

// Returns YES if all items in the collection have been deleted.
- (BOOL)hasNoPlayableItems;

@end
