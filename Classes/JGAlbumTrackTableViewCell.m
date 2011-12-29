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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [trackNumberLabel release];
    [trackNameLabel release];
    [trackLengthLabel release];
    [super dealloc];
}
@end
