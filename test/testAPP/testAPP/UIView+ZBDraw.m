//
//  UIView+ZBDraw.m
//  testAPP
//
//  Created by neo on 2019/4/19.
//  Copyright © 2019 王雅强. All rights reserved.
//

#import "UIView+ZBDraw.h"

@interface UIView (Property)
@property (nonatomic, strong) NSString *filletsStr;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *gradientSColor;
@property (nonatomic, strong) UIColor *gradientEColor;
@end

@implementation UIView (ZBDraw)

- (void)setFilletsStr:(NSString *)filletsStr{
    objc_setAssociatedObject(self, "filletsStr", filletsStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)filletsStr{
     return objc_getAssociatedObject(self, "filletsStr") ;
}
static CGFloat _cornerRadius = 0;

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius{
    return _cornerRadius;
}

- (void)setGradientSColor:(UIColor *)gradientSColor{
    objc_setAssociatedObject(self, "gradientSColor", gradientSColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)gradientSColor{
     UIColor * color = objc_getAssociatedObject(self, "gradientSColor") ;
    return color;
}
- (void)setGradientEColor:(UIColor *)gradientEColor{
    objc_setAssociatedObject(self, "gradientEColor", gradientEColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)gradientEColor{
    UIColor * color = objc_getAssociatedObject(self, "gradientEColor") ;
    return color;
}


- (void)setClipPartRadiusWithradius:(CGFloat)cornerRadius filletsStr:(NSString *)filletsStr{
     if (!(filletsStr.length>0))return;
    self.cornerRadius = cornerRadius;
    self.filletsStr = filletsStr;
}

- (void)clipsPartRadiusWithradius:(CGFloat)cornerRadius filletsStr:(NSString *)filletsStr{
    UIRectCorner corners = 0;
    if([filletsStr rangeOfString:@"0"].location != NSNotFound) {
        corners = UIRectCornerTopLeft;
    }
    if([filletsStr rangeOfString:@"1"].location != NSNotFound) {
        corners = corners|UIRectCornerTopRight;
    }
    if([filletsStr rangeOfString:@"2"].location != NSNotFound) {
        corners = corners|UIRectCornerBottomLeft;
    }
    if([filletsStr rangeOfString:@"3"].location != NSNotFound) {
        corners = corners|UIRectCornerBottomRight;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius,cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)setGradientColorWithStarColor:(UIColor *)color1 andEndColor:(UIColor *)color2{
    self.gradientSColor = color1;
    self.gradientEColor = color2;
}
- (void)gradientColorWithStarColor:(UIColor *)color1 andEndColor:(UIColor *)color2{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)color2.CGColor, (__bridge id)color1.CGColor];
    gradientLayer.locations = @[@0.1, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)layoutSubviews{

    if (self.filletsStr.length >0) {
        [self clipsPartRadiusWithradius:self.cornerRadius filletsStr:self.filletsStr];
    }
    if (self.gradientSColor && self.gradientEColor) {
        [self gradientColorWithStarColor:self.gradientSColor andEndColor:self.gradientEColor];
    }
    
}


@end
