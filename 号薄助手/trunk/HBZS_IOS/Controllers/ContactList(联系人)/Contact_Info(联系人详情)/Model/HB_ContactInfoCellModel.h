//
//  HB_ContactInfoCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import <Foundation/Foundation.h>
#import "HB_ContactDetailListModel.h"//列表需要显示的数据的模型

@interface HB_ContactInfoCellModel : NSObject
/**  列表模型 */
@property(nonatomic,retain)HB_ContactDetailListModel *listModel;
/** placeHolder */
@property(nonatomic,copy)NSString *placeHolder;
/** 对应属性的值 */
@property(nonatomic,copy)NSString *text;
/** 图标 */
@property(nonatomic,retain)UIImage *icon;

/**
 *  快速返回一个普通模型
 */
+(instancetype)modelWithPlaceHolder:(NSString *)placeHolder andListModel:(HB_ContactDetailListModel *)listModel;

@end
