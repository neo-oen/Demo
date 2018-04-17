//
//  HB_ContactDetailCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//普通的cell
/*
 传入HB_ContactDetailListModel作为参数，便于直接改变listModel中每个属性的值。
 也就是说每个cell的值的改变，控制器中的listModel的值就直接改变了，不需要其他的代理传值的方式了。
 */

#import <Foundation/Foundation.h>
#import "HB_ContactDetailListModel.h"

@interface HB_ContactDetailCellModel : NSObject

/** textfield的占位符 */
@property(nonatomic,copy)NSString *placeHolder;
/** HB_ContactDetailListModel */
@property(nonatomic,retain)HB_ContactDetailListModel *listModel;
/** 图标 */
@property(nonatomic,retain)UIImage *icon;

/**
 *  快速创建一个普通cellModel模型
 */
+(instancetype)modelWithPlaceHolder:(NSString *)placeHolder andListModel:(HB_ContactDetailListModel *)listModel andIcon:(UIImage *)icon;

@end
