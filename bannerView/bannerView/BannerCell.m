//
//  BannerCell.m
//  bannerView
//
//  Created by neo on 2018/1/8.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "BannerCell.h"



@implementation BannerCell



#pragma mark - ============== 懒加载 ==============
-(UIImageView *)imageView
{
    if(!_imageView) {
        _imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_imageView addTarget:self action:@selector(ImageClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_imageView];
        //
    }
    return _imageView;
}

#pragma mark - ============== 初始化 ==============
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


#pragma mark - ============== 接口 ==============
-(void)setModel:(BannerModel *)model{
    _model = model;
    [self.imageView setBackgroundImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    self.imageUrl = model.imageUrl;
}

#pragma mark - ============== 方法 ==============
-(void)ImageClick{
    if (_imageCA) {
        self.imageCA(_imageUrl);
    }
    
}


#pragma mark - ============== 设置 ==============
-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    
    
}



@end

