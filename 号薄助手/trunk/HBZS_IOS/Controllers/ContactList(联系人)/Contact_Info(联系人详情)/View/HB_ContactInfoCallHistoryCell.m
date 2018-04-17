//
//  HB_ContactInfoCallHistoryCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#define Padding 15  //间距
#define Font 13  //字体大小

#import "HB_ContactInfoCallHistoryCell.h"

@interface HB_ContactInfoCallHistoryCell ()
/**
 *  某一天
 */
@property(nonatomic,retain)UILabel * date_day_label;
/**
 *  具体时间time
 */
@property(nonatomic,retain)UILabel * date_time_label;
/**
 *  手机号码
 */
@property(nonatomic,retain)UILabel * phoneNumberLabel;
/**
 *  呼叫类型
 */
@property(nonatomic,retain)UILabel * callTypeLabel;
/**
 *  通话时间
 */
@property(nonatomic,retain)UILabel * callTimeLabel;
/**
 *  图标
 */
@property(nonatomic,retain)UIImageView * iconImageView;

@end

@implementation HB_ContactInfoCallHistoryCell

-(void)dealloc{
    [_date_day_label release];
    [_date_time_label release];
    [_phoneNumberLabel release];
    [_callTypeLabel release];
    [_callTimeLabel release];
    [_iconImageView release];
    [_model release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_ContactInfoCallHistoryCell";
    HB_ContactInfoCallHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[HB_ContactInfoCallHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setupSubViews];
    }
    return cell;
}
-(void)setupSubViews{
    //1.图标
    _iconImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_iconImageView];
    //2.日期——day
    _date_day_label=[[UILabel alloc]init];
    _date_day_label.textColor=COLOR_F;
    _date_day_label.font=[UIFont systemFontOfSize:Font];
    [self.contentView addSubview:_date_day_label];
    //3.电话号码
    _phoneNumberLabel=[[UILabel alloc]init];
    _phoneNumberLabel.font=[UIFont systemFontOfSize:Font];
    _phoneNumberLabel.textColor=COLOR_F;
    [self.contentView addSubview:_phoneNumberLabel];
    //4.日期——time
    _date_time_label=[[UILabel alloc]init];
    _date_time_label.textColor=COLOR_H;
    _date_time_label.font=[UIFont systemFontOfSize:Font];
    [self.contentView addSubview:_date_time_label];
    //5.呼叫类型
    _callTypeLabel=[[UILabel alloc]init];
    _callTypeLabel.textColor=COLOR_H;
    _callTypeLabel.font=[UIFont systemFontOfSize:Font];
    [self.contentView addSubview:_callTypeLabel];
    //6.通话时间（如果通话时间为nil，则不显示）
    _callTimeLabel=[[UILabel alloc]init];
    _callTimeLabel.textColor=COLOR_H;
    _callTimeLabel.font=[UIFont systemFontOfSize:Font];
    [self.contentView addSubview:_callTimeLabel];
}
-(void)setModel:(HB_ContactInfoCallHistoryCellModel *)model{
    _model=[model retain];
    //1.图标
    self.iconImageView.image=model.icon;
    //2.日期——day
    self.date_day_label.text=model.dialItemModel.callDate_Day;
    //3.电话号码
    self.phoneNumberLabel.text=model.dialItemModel.phoneNum;
    //4.日期——time
    self.date_time_label.text=model.dialItemModel.callDate_time;
    //5.呼叫类型(暂不显示)
    self.callTypeLabel.text=@"";
    //6.通话时间（暂不显示）
    self.callTimeLabel.text=@"";
}
-(void)layoutSubviews{
    //1.图标
    CGFloat iconImageView_W=20;
    CGFloat iconImageView_H=iconImageView_W;
    CGFloat iconImageView_X=Padding;
    CGFloat iconImageView_Y=self.bounds.size.height * 0.5 - iconImageView_H*0.5;
    _iconImageView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
    //2.日期——day
    CGFloat date_day_label_W;
    CGFloat date_day_label_H=14;
    CGFloat date_day_label_X=CGRectGetMaxX(_iconImageView.frame)+Padding;
    CGFloat date_day_label_Y=self.bounds.size.height * 0.5 - date_day_label_H -2;
    //动态计算宽度
    NSString * title=_date_day_label.text;
    NSMutableDictionary * attributeDict=[[NSMutableDictionary alloc]init];
    attributeDict[NSFontAttributeName]=[UIFont systemFontOfSize:Font];
    CGSize size = [title boundingRectWithSize:CGSizeMake(100, date_day_label_H) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
    date_day_label_W=size.width;
    _date_day_label.frame=CGRectMake(date_day_label_X, date_day_label_Y, date_day_label_W, date_day_label_H);
    //3.电话号码
    CGFloat phoneNumberLabel_X=CGRectGetMaxX(_date_day_label.frame)+10;
    CGFloat phoneNumberLabel_Y=date_day_label_Y;
    CGFloat phoneNumberLabel_W=self.bounds.size.width-phoneNumberLabel_X-Padding;
    CGFloat phoneNumberLabel_H=date_day_label_H;
    _phoneNumberLabel.frame=CGRectMake(phoneNumberLabel_X, phoneNumberLabel_Y, phoneNumberLabel_W, phoneNumberLabel_H);
    //4.日期——time
    CGFloat date_time_label_W= 35;// 23:33
    CGFloat date_time_label_H=date_day_label_H;
    CGFloat date_time_label_X=date_day_label_X;
    CGFloat date_time_label_Y=CGRectGetMaxY(_date_day_label.frame)+5;
    _date_time_label.frame=CGRectMake(date_time_label_X, date_time_label_Y, date_time_label_W, date_time_label_H);
    //5.呼叫类型
    CGFloat callTypeLabel_W= Font * 4;//最多4个字(“未接通”“呼出电话”)
    CGFloat callTypeLabel_H=date_time_label_H;
    CGFloat callTypeLabel_X=CGRectGetMaxX(_date_time_label.frame)+10;
    CGFloat callTypeLabel_Y=date_time_label_Y;
    _callTypeLabel.frame=CGRectMake(callTypeLabel_X, callTypeLabel_Y, callTypeLabel_W, callTypeLabel_H);
    //6.通话时间（如果通话时间为nil，则不显示）
    if (self.callTimeLabel.text) {
        CGFloat callTimeLabel_W=80;
        CGFloat callTimeLabel_H=callTypeLabel_H;
        CGFloat callTimeLabel_X=CGRectGetMaxX(_callTypeLabel.frame)+10;
        CGFloat callTimeLabel_Y=callTypeLabel_Y;
        _callTimeLabel.frame=CGRectMake(callTimeLabel_X, callTimeLabel_Y, callTimeLabel_W, callTimeLabel_H);
    }
}

@end
