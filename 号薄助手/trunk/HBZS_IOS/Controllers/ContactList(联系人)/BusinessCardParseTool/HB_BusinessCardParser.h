//
//  HB_BusinessCardParse.h
//  HBZS_IOS
//
//  Created by zimbean on 15/12/10.
//
//  名片解析类

#import <Foundation/Foundation.h>
#import "HB_ContactModel.h"

@interface HB_BusinessCardParser : NSObject

/**
 *  检测是否符合名片格式
 */
+(BOOL)isCardParser:(NSString *)propertyString;

/**
 *  根据属性字符串，解析出联系人模型
 */
+(HB_ContactModel *)parseWithPropertyString:(NSString *)propertyString;
+(UIImage *)getQRcodeImageWithContact:(HB_ContactModel *)model ShowPhoneNum:(NSMutableString *)willShowPhoneNum;

-(UIImage *)getQRImageBy:(NSString * )QRString;
@property(nonatomic,retain)NSArray * phoneTypes;
@property(nonatomic,retain)NSArray * emailTypes;

@end
