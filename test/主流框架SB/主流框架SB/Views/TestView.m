//
//  TestView.m
//  主流框架SB
//
//  Created by neo on 2018/1/25.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "TestView.h"

@interface TestView ()
@property(nonatomic,strong)UIImage * image;

@end

@implementation TestView

#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
-(void)setRadian:(CGFloat)radian{
    _radian = radian;
    [self setNeedsDisplay];
}

#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
   CGFloat x = rect.size.width/2;
   CGFloat y = rect.size.height/2;
    
    [_image drawAtPoint:CGPointMake(1, 1)];
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(x, y) radius:80 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(x, y)];
    [path addArcWithCenter:CGPointMake(x, y) radius:80 startAngle:_radian endAngle:_radian clockwise:YES];

    [path stroke];

}

-(void)layoutSubviews{
    
}


@end
