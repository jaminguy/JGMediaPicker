//
//  JGAlbumTrackTableViewCell.h
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGAlbumTrackTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *trackNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *trackLengthLabel;
@end
