//
//  JGMediaQueryTableViewCell.m
//  JGMediaPickerDemo
//
//  Created by Katsuma Ito on 2014/06/25.
//
//

#import "JGMediaQueryTableViewCell.h"

@implementation JGMediaQueryTableViewCell


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = (self.bounds.size.height - imageViewFrame.size.height) / 2.f;
    imageViewFrame.origin.y = imageViewFrame.origin.x;
    [self.imageView setFrame:imageViewFrame];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

@end
