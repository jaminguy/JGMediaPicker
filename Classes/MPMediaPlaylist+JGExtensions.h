//
//  MPMediaPlaylist+JGExtensions.h
//  JGMediaPickerDemo
//
//  Created by Jamin Guy on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaPlaylist (JGExtensions)

- (NSNumber *)jg_persistentID;
- (NSString *)jg_name;
@end
