//
//  UIView+ZBDraw.h
//  testAPP
//
//  Created by neo on 2019/4/19.
//  Copyright © 2019 王雅强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZBDraw)
- (void)setClipPartRadiusWithradius:(CGFloat)cornerRadius filletsStr:(NSString *)filletsStr;
-(void)setGradientColorWithStarColor:(UIColor *)color1 andEndColor:(UIColor *)color2;

@end

NS_ASSUME_NONNULL_END
