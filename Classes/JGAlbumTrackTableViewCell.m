//
//  JGAlbumTrackTableViewCell.m
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JGAlbumTrackTableViewCell.h"

@implementation JGAlbumTrackTableViewCell
@synthesize trackNumberLabel;
@synthesize trackNameLabel;
@synthesize trackLengthLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end
