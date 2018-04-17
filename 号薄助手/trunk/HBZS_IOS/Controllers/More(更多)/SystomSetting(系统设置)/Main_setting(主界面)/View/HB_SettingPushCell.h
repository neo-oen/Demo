//
//  HB_SettingPushCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingCell.h"
#import "HB_SettingPushCellModel.h"

@interface HB_SettingPushCell : HB_SettingCell
/**
 *  左侧提示小蓝点
 */
@property(nonatomic,retain)UIImageView *alertBluePointIV;
/**
 *  数据模型
 */
@property(nonatomic,retain)HB_SettingPushCellModel *model;

/**
 *  快速返回cell
 *
 */

@property (nonatomic,retain)UILabel * RightLabel;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
