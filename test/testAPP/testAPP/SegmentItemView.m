//
//  SegmentItemView.m
//  testAPP
//
//  Created by neo on 2018/5/9.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "SegmentItemView.h"

@implementation SegmentItemView

#pragma mark - ============== 懒加载 ==============
-(UIImageView *)imageView
{
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setUserInteractionEnabled:YES];
        [self addSubview:_imageView];
        
    }
    return _imageView;
}
-(UILabel *)label
{
    if(!_label) {
        _label = [[UILabel alloc] init];
        [_label setFont:[UIFont systemFontOfSize:16]];
        [_label setTextColor:[UIColor orangeColor]];
        [self addSubview:_label];
    }
    return _label;
}

#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============

-(void)setItemWithImage:(UIImage *)image andTitle:(NSString *)title;{
    [ self.imageView setImage:image];
    [self.label setText:title];
    
}

-(void)setItemWithImage:(UIImage *)image andTitleColor:(UIColor *)color;{
    [self.imageView setImage:image];
    [self.label setTextColor:color];
}

#pragma mark - ============== 方法 ==============
#pragma mark - ============== UI界面 ==============
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

-(void)layoutSubviews{
    [self.imageView setFrame:self.bounds];
    CGRect rectLab ;
    rectLab.size = [_label.text sizeWithAttributes:[_label.attributedText attributesAtIndex:0 effectiveRange:nil]];
    [_label setBounds:rectLab];
    CGPoint point = self.center;
    point.x = point.x - self.frame.origin.x;
    [_label setCenter:point];
    
}

@end
