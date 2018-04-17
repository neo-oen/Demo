//
//  HB_MergerCellSubView.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/17.
//
//

#import "HB_MergerCellSubView.h"

@implementation HB_MergerCellSubView

-(void)dealloc{
    [_nameLabel release];
    [_phoneLabel release];
    [super dealloc];
}
-(instancetype)init{
    if (self=[super init]) {
        [self setupSubViews];
    }
    return self;
}
/**
 *  添加子控件
 */
-(void)setupSubViews{
    //名字
    _nameLabel=[[UILabel alloc]init];
    _nameLabel.font=[UIFont systemFontOfSize:16.5];
    _nameLabel.textColor=COLOR_D;
    [self addSubview:_nameLabel];
    //电话号码
    _phoneLabel=[[UILabel alloc]init];
    _phoneLabel.font=[UIFont systemFontOfSize:14];
    _phoneLabel.textColor=COLOR_D;
    [self addSubview:_phoneLabel];
}
/**
 *  布局子控件
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    //名字
    CGFloat name_W=200;
    CGFloat name_H=20;
    CGFloat name_X=15;
    CGFloat name_Y=10;
    self.nameLabel.frame=CGRectMake(name_X, name_Y, name_W, name_H);
    //电话
    CGFloat phone_W=name_W;
    CGFloat phone_H=15;
    CGFloat phone_X=name_X;
    CGFloat phone_Y=CGRectGetMaxY(self.nameLabel.frame)+5;
    self.phoneLabel.frame=CGRectMake(phone_X, phone_Y, phone_W, phone_H);
}


@end
