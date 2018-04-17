//
//  HB_SettingCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//
#define Padding 15 //间距

#import <UIKit/UIKit.h>
#import "HB_SettingCellModel.h"

@interface HB_SettingCell : UITableViewCell
/**
 *  名字
 */
@property(nonatomic,retain)UILabel * nameLabel;

/**
 *  添加子控件（父类方法）
 */
-(void)setupSubViews;

@end
