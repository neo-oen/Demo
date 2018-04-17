//
//  HB_MoreCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/11.
//
//

#import <Foundation/Foundation.h>

@interface HB_MoreCellModel : NSObject
/**
 *  图标
 */
@property(nonatomic,retain)UIImage *icon;
/**
 *  选项名字
 */
@property(nonatomic,copy)NSString *nameStr;
/**
 *  需要跳转的控制器
 */
@property(nonatomic,assign)Class viewController;
/**
 *  需要执行的option
 */
@property(nonatomic,copy) void(^block)(void) ;

/**
 *  快速返回模型
 *
 */
+(instancetype)modelWithIcon:(UIImage *)image andNameStr:(NSString *)name andViewController:(Class)viewController andOption:(void(^)(void))block;

@end
