//
//  TestView4.m
//  主流框架SB
//
//  Created by neo on 2018/2/6.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "TestView4.h"

@implementation TestView4

#pragma mark - ============== 懒加载 ==============
-(UIImage *)image
{
    if(!_image) {
        _image = [UIImage imageNamed:@"me"];
        //
    }
    return _image;
}

#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

  
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(80 , 80) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [path addClip];
    
    [self.image drawInRect:CGRectMake(30, 30, 150, 150)];
    NSData * asd ;


}

- (void)text1:(CGRect)rect {
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50 , 50) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    CGContextAddPath(ctr, path.CGPath);
    
    CGContextClip(ctr);
    
    [self.image drawAtPoint:CGPointZero];
    
    
}

- (void)text2:(CGRect)rect {
    
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(80 , 80) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [[UIColor redColor]set];
    CGContextAddPath(ctr, path.CGPath);
    
    CGContextFillPath(ctr);
    
    
}


- (void)text3:(CGRect)rect {
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(80 , 80) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [path addClip];
    
    [self.image drawInRect:CGRectMake(30, 30, 150, 150)];
    NSData * asd ;
    
    
}

@end
