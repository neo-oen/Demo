//
//  TestView2.m
//  主流框架SB
//
//  Created by neo on 2018/1/31.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "TestView2.h"

@implementation TestView2

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

    CGFloat centerX = rect.size.width/2;
    CGFloat centerY = rect.size.height/2;
    
    
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:20 startAngle: M_PI + _radian endAngle: M_PI + _radian clockwise:YES];
    
    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:80 startAngle:3 * M_PI_2 + _radian endAngle:3 * M_PI_2 + _radian clockwise:YES];
    
    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:20 startAngle: _radian endAngle: _radian clockwise:YES];
//
    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:20 startAngle:M_PI_2 + _radian endAngle:M_PI_2 + _radian clockwise:YES];

    
    [path fill];
    
    
    
}


@end
