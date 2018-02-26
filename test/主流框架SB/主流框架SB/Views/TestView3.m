//
//  TestView3.m
//  主流框架SB
//
//  Created by neo on 2018/2/2.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "TestView3.h"

@implementation TestView3


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctr =  UIGraphicsGetCurrentContext();
//    CGContextSaveGState(ctr);
    UIBezierPath * path1 = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor yellowColor] set];
     CGContextSetLineWidth(ctr, 30);
    CGContextAddPath(ctr, path1.CGPath);
    
    CGContextStrokePath(ctr);

    
//    CGContextRestoreGState(ctr);
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width];
//    [[UIColor redColor] set];
//     CGContextSetLineWidth(ctr, 15);
    CGContextAddPath(ctr, path.CGPath);
    
    CGContextStrokePath(ctr);
    
}



-(void)test1:(CGRect)rect{
    
    UIBezierPath * path1 = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor yellowColor] set];
    path1.lineWidth = 5;
    [path1 stroke];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width];
    [[UIColor redColor] set];
    path.lineWidth = 15;
    [path stroke];
    
}

@end
