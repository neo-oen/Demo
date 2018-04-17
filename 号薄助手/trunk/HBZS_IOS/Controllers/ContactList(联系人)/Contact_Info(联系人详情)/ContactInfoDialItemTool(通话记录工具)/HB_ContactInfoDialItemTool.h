//
//  HB_ContactInfoDialItemTool.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/16.
//
//把系统的通话记录模型转变成详情页需要的模型

#import <Foundation/Foundation.h>


@interface HB_ContactInfoDialItemTool : NSObject
/**
 *  返回一个联系人详情页可以用到的 通话记录模型 数组
 */
+(NSArray *)contactInfoDialItemArrWithRecordID:(NSInteger)recordID;

@end
