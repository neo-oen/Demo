//
//  HB_ContactDetailPhoneCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

#import <Foundation/Foundation.h>
#import "HB_PhoneNumModel.h"//电话号码的模型
#import "HB_EmailModel.h"//邮箱模型

@interface HB_ContactDetailPhoneCellModel : NSObject

/** textfield的占位符 */
@property(nonatomic,copy)NSString *placeHolder;
/** 图标 */
@property(nonatomic,retain)UIImage *icon;
/** 电话号码的模型 */
@property(nonatomic,retain)HB_PhoneNumModel *phoneModel;
/** 邮箱模型 */
@property(nonatomic,retain)HB_EmailModel *emailModel;

/**
 *  快速创建一个PhoneCellModel模型
 */
+(instancetype)modelWithPlaceHolder:(NSString *)placeHolder andModel:(id)phoneOrEmailModel;

@end
