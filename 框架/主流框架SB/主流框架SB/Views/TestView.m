//
//  TestView.m
//  主流框架SB
//
//  Created by neo on 2018/1/25.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "TestView.h"

@interface TestView ()

@end

@implementation TestView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 10, 80, 80)];

    [path setLineWidth:20];
    [[UIColor greenColor] set];
    [path stroke];
}



@end
