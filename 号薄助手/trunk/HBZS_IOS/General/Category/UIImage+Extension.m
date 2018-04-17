//
//  UIImage+Extension.m
//  XBZ
//
//  Created by zimbean on 14-7-18.
//  Copyright (c) 2014年 shtianxin. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
