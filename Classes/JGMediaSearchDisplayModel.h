//
//  RecordingsSearchDisplayModel.h
//  iTalk
//
//  Created by Jamin Guy on 7/14/10.
//  Copyright 2010 Griffin Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecordingFileInfo;

@interface JGMediaSearchDisplayModel : NSObject <UISearchDisplayDelegate> {

}

@property (nonatomic, assign) IBOutlet id delegate;

@end

@protocol JGMediaSearchDisplayModelDelegate

//- (void)didSelectSearchRecording:(RecordingFileInfo *)recordingFileInfo;

@end