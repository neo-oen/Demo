//
//  HB_SettingOptionCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingCell.h"
#import "HB_SettingOptionCellModel.h"
@class HB_SettingOptionCell;

@protocol HB_SettingOptionCellDelegate <NSObject>
/**
 *  HB_SettingOptionCell右侧的textfield开始编辑
 */
-(void)settingOptionCell:(HB_SettingOptionCell *)cell textFieldBeginEdit:(UITextField *)textField;

@end
@interface HB_SettingOptionCell : HB_SettingCell
/**
 *  HB_SettingOptionCell的代理
 */
@property(nonatomic,assign)id<HB_SettingOptionCellDelegate> delegate;
/**
 *  右侧tf
 */
@property(nonatomic,retain)UITextField * textfield;
/**
 *  数据模型
 */
@property(nonatomic,retain)HB_SettingOptionCellModel *model;

/**
 *  快速返回cell
 *
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
