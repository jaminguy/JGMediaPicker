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

//Loading the media library the first time can take a while so this method processes on a background queue
// and then calls the completion block on the main queue with the instantiated JGMediaPickerController object
+ (void)jgMediaPickerControllerAsync:(void (^)(JGMediaPickerController *jgMediaPickerController))completion;

@property (nonatomic, strong) id delegate;

//defaults to JGMediaPickerTabIndex_Artists
@property (nonatomic, assign) JGMediaPickerTabIndex selectedTabIndex;

//This represents the underlying UIViewController used for presenting by the delegate
@property (nonatomic, strong, readonly) UIViewController *viewController;

@end

@protocol JGPMediaPickerControllerDelegate <NSObject>
@optional

// It is the delegate's responsibility to dismiss the modal view controller on the parent view controller.

- (void)jgMediaPicker:(JGMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem;
- (void)jgMediaPickerDidCancel:(JGMediaPickerController *)mediaPicker;

@end
