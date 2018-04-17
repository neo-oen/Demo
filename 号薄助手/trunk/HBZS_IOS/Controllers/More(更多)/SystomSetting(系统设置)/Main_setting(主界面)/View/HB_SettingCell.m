//
//  HB_SettingCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//
#import "HB_SettingCell.h"

@interface HB_SettingCell ()
/**
 *  细线
 */
@property(nonatomic,retain)UILabel * lineLabel;

@end

@implementation HB_SettingCell

-(void)dealloc{
    [_nameLabel release];
    [_lineLabel release];
    [super dealloc];
}
/**
 *  添加子控件（父类方法）
 */
-(void)setupSubViews{
    //名字
    UILabel * nameLabel=[[UILabel alloc]init];
    [self.contentView addSubview:nameLabel];
    nameLabel.textColor=COLOR_D;
    nameLabel.font=[UIFont systemFontOfSize:15];
    self.nameLabel=nameLabel;
    [nameLabel release];
    //细线
    UILabel * lineLabel=[[UILabel alloc]init];
    [self.contentView addSubview:lineLabel];
    lineLabel.backgroundColor=COLOR_H;
    self.lineLabel=lineLabel;
    [lineLabel release];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //名字
    CGFloat name_W=self.contentView.bounds.size.width-80-Padding * 2;
    CGFloat name_H=self.contentView.bounds.size.height;
    CGFloat name_X=Padding;
    CGFloat name_Y=0;
    self.nameLabel.frame=CGRectMake(name_X, name_Y, name_W, name_H);
    //细线
    CGFloat line_W=self.contentView.bounds.size.width-Padding * 2;
    CGFloat line_H=0.5;
    CGFloat line_X=Padding;
    CGFloat line_Y=self.contentView.bounds.size.height-line_H;
    self.lineLabel.frame=CGRectMake(line_X, line_Y, line_W, line_H);
}
@end
