//
//  SwipLockView.m
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/28.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "SwipLockView.h"

@implementation SwipLockView

#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============

-(void)addButtons{
    
    for (int i= 0; i<9; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [button setUserInteractionEnabled:NO];
        [self addSubview:button];
    }
    
}

#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

-(void)layoutSubviews{
    [super layoutSubviews];

    CGFloat width = 80;
    CGFloat height = 80;
    CGFloat margin = (self.frame.size.width - 3 * width)/4;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *button = self.subviews[i];
        
       CGFloat col = i % 3;
       CGFloat row = i / 3;
       CGFloat btnX = margin + (margin + width) * col;
       CGFloat  btnY = (margin + height) * row;
        
        button.frame = CGRectMake(btnX, btnY, width, height);
        
    }
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addButtons];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];

    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
