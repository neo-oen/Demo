//
//  HB_SettingPushCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingCellModel.h"

@interface HB_SettingPushCellModel : HB_SettingCellModel

/**
 *  需要跳转的控制器类
 */
@property(nonatomic,assign)Class viewController;

/**
 *  快速返回一个Model
 */
+(instancetype)modelWithName:(NSString *)name andViewController:(Class)viewController;

@end
