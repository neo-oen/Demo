//
//  shopCell.m
//  collectionView
//
//  Created by neo on 2018/1/9.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "shopCell.h"

@interface shopCell ()
@property(nonatomic,strong)UILabel * priceLabel;

@end

@implementation shopCell


#pragma mark - ============== 懒加载 ==============
-(UILabel *)priceLabel
{
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}


#pragma mark - ============== 初始化 ==============
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - ============== 接口 ==============
-(void)setGood:(shopCellModel *)good{
    _good = good;
    [self.priceLabel setText:good.price];
}

#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.priceLabel setFrame:CGRectMake(10, self.contentView.frame.size.height-50, 50, 40)];
}

@end
