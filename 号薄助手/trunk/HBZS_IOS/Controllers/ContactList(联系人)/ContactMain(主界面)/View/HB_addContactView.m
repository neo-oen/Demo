//
//  HB_addContactView.m
//  HBZS_iOS
//
//  Created by zimbean on 15/7/13.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//

#define  Padding 12
#import "HB_addContactView.h"

@interface HB_addContactView()
/**
 *  背景图
 */
@property(nonatomic,retain)UIImageView * bgImageView;

@end
@implementation HB_addContactView

-(void)dealloc{
    [super dealloc];

    [_bgImageView release];
    
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self setupSubViews];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
/**
 *  添加子控件
 */
-(void)setupSubViews{
    //1.背景图
    _bgImageView=[[UIImageView alloc]init];
    _bgImageView.userInteractionEnabled=YES;
    _bgImageView.image=[UIImage imageNamed:@"下拉框3"];
    [self addSubview:_bgImageView];
    //2.添加按钮
    [self addBtnWithTitle:@"创建联系人" andTag:CREATE_NEW_CONTACT];
    [self addBtnWithTitle:@"扫码添加" andTag:SWEEP_CODE_ADD_CONTACT];
    [self addBtnWithTitle:@"通讯录分享" andTag:CONTACT_SHARE_BY_CLOUD];
    [self addBtnWithTitle:@"批量删除" andTag:BATCH_DELETE];
    
}
-(void)addBtnWithTitle:(NSString *)title andTag:(NSInteger)tag{
    UIButton * btn =[[UIButton alloc]init];
    btn.tag=tag;
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn setTitleColor:COLOR_D forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [self.bgImageView addSubview:btn];
    [btn release];
}
-(void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addContactViewDidClick:withButtonTag:)]) {
        [self.delegate addContactViewDidClick:self withButtonTag:btn.tag];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //1、背景
    self.bgImageView.frame=self.bounds;
    //2.添加按钮
    for (int i=0; i<self.bgImageView.subviews.count; i++) {
        UIButton * btn=self.bgImageView.subviews[i];
        CGFloat btn_W=self.bgImageView.bounds.size.width;
        CGFloat btn_H=44;
        CGFloat btn_X=0;
        CGFloat btn_Y=btn_H * i +Padding;
        btn.frame=CGRectMake(btn_X, btn_Y, btn_W, btn_H);
        //按钮底部加一条细线
        if (i<3) {
            UILabel * lineLabel =[[UILabel alloc]init];
            lineLabel.textColor=[UIColor clearColor];
            lineLabel.backgroundColor=COLOR_H;
            lineLabel.frame=CGRectMake(0, CGRectGetMaxY(btn.bounds)-0.5, btn.frame.size.width, 0.5);
            [btn addSubview:lineLabel];
            [lineLabel release];

        }
    }
}
@end
