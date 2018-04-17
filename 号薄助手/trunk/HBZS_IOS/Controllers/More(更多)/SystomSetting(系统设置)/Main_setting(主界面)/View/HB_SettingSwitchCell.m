//
//  HB_SettingSwitchCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingSwitchCell.h"

@interface HB_SettingSwitchCell ()
/**
 *  右侧开关
 */
@property(nonatomic,retain)UISwitch * rightSwitch;

@end
@implementation HB_SettingSwitchCell
-(void)dealloc{
    [_rightSwitch release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_SettingSwitchCell";
    HB_SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[HB_SettingSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
        [cell setupSubViews];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
/**
 *  设置子控件
 */

-(void)setupSubViews{
    [super setupSubViews];
    //右侧开关
    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;
    UISwitch * rightSwitch=[[UISwitch alloc]init];
    rightSwitch.onTintColor=COLOR_C;
    [rightSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:rightSwitch];
    self.rightSwitch=rightSwitch;
    [rightSwitch release];
}
-(void)setModel:(HB_SettingSwitchCellModel *)model{
    _model=model;
    //名字
    self.nameLabel.text=model.name;
    //开关
    [self.rightSwitch setOn:model.switchIsOn animated:YES];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //右侧开关
    CGFloat switch_W=51;
    CGFloat switch_H=31;
    CGFloat switch_X=self.contentView.bounds.size.width-Padding-switch_W;
    CGFloat switch_Y=self.contentView.bounds.size.height*0.5 - switch_H*0.5;
    self.rightSwitch.frame=CGRectMake(switch_X, switch_Y, switch_W, switch_H);
}
#pragma mark - 开关事件 
-(void)switchValueChanged:(UISwitch *)switcher{
    if ([self.delegate respondsToSelector:@selector(settingSwitchCell:switchValueChanged:)]) {
        [self.delegate settingSwitchCell:self switchValueChanged:switcher];
    }
}

@end
