//
//  UIImage+YX.h
//  weiboTest2
//
//  Created by zimbean on 15/7/1.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YX)

/**
 *  返回一个可以自由拉伸的图片
 *
 *  @param imageName 图片名字
 *
 *  @return 可拉伸图片
 */
+(UIImage *)resizedImageWithName:(NSString *)imageName;

@end
