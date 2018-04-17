//
//  HB_SettingPushCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingPushCell.h"

@interface HB_SettingPushCell ()
/**
 *  右侧箭头
 */
@property(nonatomic,retain)UIImageView * arrowImageView;

@end
@implementation HB_SettingPushCell
-(void)dealloc{
    [_arrowImageView release];
    [_alertBluePointIV release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_SettingPushCell";
    HB_SettingPushCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[HB_SettingPushCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
        [cell setupSubViews];
    }
    return cell;
}
/**
 *  设置子控件
 */
-(void)setupSubViews{
    [super setupSubViews];
    //左侧提示小蓝点
    UIImageView * alertPoint=[[UIImageView alloc]init];
    alertPoint.layer.masksToBounds=YES;
    alertPoint.backgroundColor=COLOR_C;
    alertPoint.image=[UIImage imageNamed:@"小红点"];
    alertPoint.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:alertPoint];
    alertPoint.hidden=YES;
    self.alertBluePointIV=alertPoint;
    [alertPoint release];
    //右侧箭头
    UIImageView * arrow=[[UIImageView alloc]init];
    arrow.image=[UIImage imageNamed:@"普通箭头-List"];
    arrow.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:arrow];
    self.arrowImageView=arrow;
    [arrow release];
    
    //右边显示界面
    self.RightLabel=[[UILabel alloc]init];
    [self.contentView addSubview:self.RightLabel];
    self.RightLabel.textColor=COLOR_D;
    self.RightLabel.font=[UIFont systemFontOfSize:15];
    self.RightLabel.textAlignment = NSTextAlignmentRight;
    
    
}
-(void)setModel:(HB_SettingPushCellModel *)model{
    _model=model;
    //名字
    self.nameLabel.text=model.name;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //左侧提示小蓝点
    CGFloat alert_W=6;
    CGFloat alert_H=alert_W;
    CGFloat alert_X=6;
    CGFloat alert_Y=self.contentView.bounds.size.height*0.5 - alert_H*0.5;
    self.alertBluePointIV.frame=CGRectMake(alert_X, alert_Y, alert_W, alert_H);
    self.alertBluePointIV.layer.cornerRadius=3;
    //右侧箭头
    CGFloat arrow_W=20;
    CGFloat arrow_H=self.contentView.bounds.size.height;
    CGFloat arrow_X=self.contentView.bounds.size.width-Padding-arrow_W;
    CGFloat arrow_Y=0;
    self.arrowImageView.frame=CGRectMake(arrow_X, arrow_Y, arrow_W, arrow_H);
    
    
    self.RightLabel.frame = CGRectMake(95, 0, self.contentView.bounds.size.width-Padding-arrow_W-95, self.contentView.bounds.size.height);
}


@end
