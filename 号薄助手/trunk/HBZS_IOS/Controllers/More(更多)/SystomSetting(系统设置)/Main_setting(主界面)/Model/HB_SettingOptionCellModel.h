//
//  HB_SettingOptionCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingCellModel.h"

@interface HB_SettingOptionCellModel : HB_SettingCellModel
/**
 *  需要执行的代码
 */
@property(nonatomic,assign)void(^option)(void);
/**
 *  右侧信息tf的内容
 */
@property(nonatomic,copy)NSString * rightString;

/**
 *  快速返回一个Model
 */
+(instancetype)modelWithName:(NSString *)name andOption:(void(^)(void))option;

@end
