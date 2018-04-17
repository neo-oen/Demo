//
//  HB_SettingSwitchCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingCell.h"
#import "HB_SettingSwitchCellModel.h"
@class HB_SettingSwitchCell;

@protocol HB_SettingSwitchCellDelegate <NSObject>
/**
 *  开关状态变化的时候调用
 */
-(void)settingSwitchCell:(HB_SettingSwitchCell *)cell switchValueChanged:(UISwitch *)switcher;

@end

@interface HB_SettingSwitchCell : HB_SettingCell
/**
 *  settingSwitchCell的代理
 */
@property(nonatomic,assign)id<HB_SettingSwitchCellDelegate> delegate;
/**
 *  数据模型
 */
@property(nonatomic,retain)HB_SettingSwitchCellModel *model;

/**
 *  快速返回cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
