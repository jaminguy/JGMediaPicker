//
//  JGAlbumTrackTableViewCell.h
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGAlbumTrackTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *trackNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *trackLengthLabel;
@end
