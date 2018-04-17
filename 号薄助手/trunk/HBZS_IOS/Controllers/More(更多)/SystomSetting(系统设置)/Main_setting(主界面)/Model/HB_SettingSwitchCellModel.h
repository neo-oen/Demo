//
//  HB_SettingSwitchCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingCellModel.h"

@interface HB_SettingSwitchCellModel : HB_SettingCellModel
/**
 *  开关的状态
 */
@property(nonatomic,assign)BOOL switchIsOn;
/**
 *  快速返回一个Model
 */
+(instancetype)modelWithName:(NSString *)name andSwitchIsOn:(BOOL)switchIsOn;

@end
