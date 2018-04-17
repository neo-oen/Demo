//
//  HB_ContactDetailArrowCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

typedef void(^OptionBlock)(void);

#import <Foundation/Foundation.h>
#import "HB_ContactDetailListModel.h"//列表模型

@interface HB_ContactDetailArrowCellModel : NSObject

/** 选项默认名字 */
@property(nonatomic,copy)NSString *placeHolder;
/** 列表模型 */
@property(nonatomic,retain)HB_ContactDetailListModel *listModel;

/** 图标 */
@property(nonatomic,retain)UIImage *icon;
/** 将要跳转的控制器 */
@property(nonatomic,assign)Class viewController;

/**
 *  快速创建一个带有箭头的cellModel模型
 */
+(instancetype)modelWithPlaceHolder:(NSString *)placeHolder andListModel:(HB_ContactDetailListModel *)listModel andIcon:(UIImage *)icon andViewController:(Class)viewController;
@end
