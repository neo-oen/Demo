//
//  UIImage+YX.m
//  weiboTest2
//
//  Created by zimbean on 15/7/1.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//

#import "UIImage+YX.h"

@implementation UIImage (YX)

+(UIImage *)resizedImageWithName:(NSString *)imageName{
    UIImage *image=[UIImage imageNamed:imageName];
    UIImage *image1=[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height * 0.5];
    return image1;
}
@end
