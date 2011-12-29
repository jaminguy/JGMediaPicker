//
//  JGMediaPickerController.h
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMediaItemCollection, MPMediaItem;

@interface JGMediaPickerController : UIViewController

@property (nonatomic, retain) id delegate;

@end

@protocol JGPMediaPickerControllerDelegate <NSObject>
@optional

// It is the delegate's responsibility to dismiss the modal view controller on the parent view controller.

- (void)jgMediaPicker:(JGMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem;
- (void)jgMediaPickerDidCancel:(JGMediaPickerController *)mediaPicker;

@end
