//
//  JGMediaPickerController.h
//  JGMediaBrowser
//
//  Created by Jamin Guy on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMediaItemCollection, MPMediaItem;

typedef enum {
    JGMediaPickerTabIndex_Playslists,
    JGMediaPickerTabIndex_Artists,
    JGMediaPickerTabIndex_Albums,
    JGMediaPickerTabIndex_Songs
} JGMediaPickerTabIndex;

@interface JGMediaPickerController : NSObject

@property (nonatomic, retain) id delegate;

//defaults to JGMediaPickerTabIndex_Artists
@property (nonatomic, assign) JGMediaPickerTabIndex selectedTabIndex;

//This represents the underlying UIViewController used for presenting by the delegate
@property (nonatomic, retain, readonly) UIViewController *viewController;

@end

@protocol JGPMediaPickerControllerDelegate <NSObject>
@optional

// It is the delegate's responsibility to dismiss the modal view controller on the parent view controller.

- (void)jgMediaPicker:(JGMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem;
- (void)jgMediaPickerDidCancel:(JGMediaPickerController *)mediaPicker;

@end
