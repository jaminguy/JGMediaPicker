//
//  UIImage+JGExtensions.m
//  JGMediaPickerDemo
//
//  Created by Katsuma Ito on 2014/06/23.
//
//

#import "UIImage+JGExtensions.h"

@implementation UIImage (JGExtensions)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
