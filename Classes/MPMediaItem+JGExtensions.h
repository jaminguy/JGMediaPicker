//
//  MPMediaItem+JGExtensions.h
//  iTrip
//
//  Created by Jamin Guy on 11/1/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaItem (JGExtensions)

- (NSString *)artist;
- (NSString *)albumArtist;
- (NSString *)title;
- (NSString *)albumTitle;
- (UIImage *)artworkWithSize:(CGSize)size;
- (UIImage *)artwork;
- (NSTimeInterval)trackLength;
- (NSDate *)releaseDate;
- (NSString *)releaseYearString;
- (NSNumber *)trackNumber;
- (NSString *)trackLengthString;
@end
