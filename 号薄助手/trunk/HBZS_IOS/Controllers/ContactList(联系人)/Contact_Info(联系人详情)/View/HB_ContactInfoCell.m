//
//  HB_ContactInfoCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//
#define Padding 15  //控件之间的间距

#import "HB_ContactInfoCell.h"

@interface HB_ContactInfoCell ()
/**
 *  内容显示框
 */
@property(nonatomic,retain)UILabel * textlabel;
/**
 *  图标显示
 */
@property(nonatomic,retain)UIImageView *iconImageView;
/**
 *  底部细线
 */
@property(nonatomic,retain)UILabel *lineLabel;


@end

@implementation HB_ContactInfoCell
-(void)dealloc{
    [_model release];
    [_textlabel release];
    [_iconImageView release];
    [_lineLabel release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_ContactInfoCell";
    HB_ContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[HB_ContactInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setupSubViews];
    }
    return cell;
}
-(void)setupSubViews{
    //1.显示框
    _textlabel=[[UILabel alloc]init];
    _textlabel.userInteractionEnabled=NO;
    _textlabel.font=[UIFont systemFontOfSize:15];
    _textlabel.textColor=COLOR_D;
    _textlabel.numberOfLines = 0;
    _textlabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_textlabel];
    //2.图标
    _iconImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_iconImageView];
    //3.底部细线
    _lineLabel=[[UILabel alloc]init];
    _lineLabel.textColor=[UIColor clearColor];
    _lineLabel.backgroundColor=COLOR_H;
    [self.contentView addSubview:_lineLabel];

}
-(void)setModel:(HB_ContactInfoCellModel *)model{
    _model=[model retain];
    //1.图标
    self.iconImageView.image=model.icon;
    //2.属性名称
    self.textlabel.text=model.placeHolder;
    //3.属性值
    self.textlabel.text=model.text;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //图标
    CGFloat iconImageView_W=20;
    CGFloat iconImageView_H=iconImageView_W;
    CGFloat iconImageView_X=Padding;
    CGFloat iconImageView_Y=self.contentView.bounds.size.height * 0.5 - iconImageView_H*0.5;
    _iconImageView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
    //显示框
    CGFloat textlabel_X=CGRectGetMaxX(_iconImageView.frame) + Padding;
    CGFloat textlabel_Y=0;
    CGFloat textlabel_W=self.contentView.bounds.size.width - textlabel_X - Padding;
    CGFloat textlabel_H=self.contentView.bounds.size.height;

    _textlabel.frame=CGRectMake(textlabel_X, textlabel_Y, textlabel_W, textlabel_H);
    //底部细线

    CGFloat lineLabel_X=iconImageView_X ;
    CGFloat lineLabel_W=self.contentView.bounds.size.width - lineLabel_X * 2;
    CGFloat lineLabel_H=0.5;
    CGFloat lineLabel_Y=self.contentView.bounds.size.height - lineLabel_H;
    _lineLabel.frame=CGRectMake(lineLabel_X, lineLabel_Y, lineLabel_W, lineLabel_H);
}


@end
