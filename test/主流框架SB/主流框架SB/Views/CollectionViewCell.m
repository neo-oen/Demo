//
//  CollectionViewCell.m
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/28.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============

-(void)setProduct:(ProjuctModel *)product{
    [self.name setText:product.name];
    if (!product.image.length) {
        [self.iamgeView setImage:[UIImage imageNamed:@"me"]];
    }else{
        
        [self.iamgeView setImage:[UIImage imageNamed:product.image]];
    }
    
}
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    
    CGPoint locPoint = [touch locationInView:self];

    if (CGRectContainsPoint(self.iamgeView.frame, locPoint)) {
        if (self.imageCA) {
           BOOL sd = self.imageCA(nil);
            NSLog(@"%i",sd);
        }
    }
}

@end
