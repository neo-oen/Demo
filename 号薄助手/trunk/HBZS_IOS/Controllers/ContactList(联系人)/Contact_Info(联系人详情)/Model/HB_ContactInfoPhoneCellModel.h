//
//  HB_ContactInfoPhoneCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import <Foundation/Foundation.h>
#import "HB_PhoneNumModel.h"//电话号码模型

@interface HB_ContactInfoPhoneCellModel : NSObject
/** 电话号码模型 */
@property(nonatomic,retain)HB_PhoneNumModel *phoneModel;
/** 图标 */
@property(nonatomic,retain)UIImage *icon;
/** 是否是最近的呼出号码 */
@property(nonatomic,assign,getter=isLastCall)BOOL lastCall;

/**
 *  快速创建一个电话cell模型
 */
+(instancetype)modelWithPhoneModel:(HB_PhoneNumModel *)phoneModel andIcon:(UIImage *)icon andIsLastCall:(BOOL)isLastCall;


@end
