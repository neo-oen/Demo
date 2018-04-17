//
//  UIButton+WebCache.h
//  Infinitus
//
//  Created by HenryLee on 13-12-16.
//  Copyright (c) 2013年 zhangli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManagerDelegate.h"

@interface UIButton (WebCache) <SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;

@end
