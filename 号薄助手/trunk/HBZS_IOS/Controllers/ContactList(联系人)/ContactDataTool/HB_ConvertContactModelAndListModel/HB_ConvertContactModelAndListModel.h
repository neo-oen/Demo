//
//  HB_ConvertContactModelAndListModel.h
//  HBZS_IOS
//
//  Created by zimbean on 16/1/25.
//
//

#import <Foundation/Foundation.h>
#import "HB_ContactModel.h"
#import "HB_ContactDetailListModel.h"

@interface HB_ConvertContactModelAndListModel : NSObject

/**
 *  把原始的联系人模型HB_ContactModel转换为‘编辑联系人’和‘联系人详情’页面需要的HB_ContactDetailListModel模型
 */
+(void)convertContactModel:(HB_ContactModel *)contactModel toListModel:(HB_ContactDetailListModel *)listModel;
/**
 *  把‘编辑联系人’和‘联系人详情’页面的HB_ContactDetailListModel模型转换为原始的联系人模型HB_ContactModel
 */
+(void)convertListModel:(HB_ContactDetailListModel *)listModel toContactModel:(HB_ContactModel *)contactModel;

@end
