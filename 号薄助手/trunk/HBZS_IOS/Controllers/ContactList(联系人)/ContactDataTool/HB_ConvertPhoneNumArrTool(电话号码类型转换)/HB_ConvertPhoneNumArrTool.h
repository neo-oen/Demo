//
//  HB_ConvertPhoneNumArrTool.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/12.
//
/*
 主要功能：把系统的电话号码类型和号簿助手的9中类型做一一对应，对应关系如下：
         _$!<Home>!$_     ‘家庭手机’
         _$!<Work>!$_     ‘商务手机’
         iPhone           ‘常用手机’
         _$!<Mobile>!$_   ‘常用电话’
         _$!<Main>!$_     ‘商务电话’
         _$!<HomeFAX>!$_  ‘家庭传真’
         _$!<WorkFAX>!$_  ‘商务传真’
         _$!<Pager>!$_    ‘传呼’
         _$!<Other>!$_    ‘家庭电话’
 */

#import <Foundation/Foundation.h>

@interface HB_ConvertPhoneNumArrTool : NSObject

/**
 *  把系统的电话号码类型标签转换成HBZS的标签
 */
+(NSMutableArray *)convertPhoneTypeWithPhoneArrSystemToHBZS:(NSArray *)phoneArr andContactRecordID:(NSInteger)recordID;

/**
 *  把HBZS的电话号码类型标签转换成系统的标签
 */
+(NSMutableArray *)convertPhoneTypeWithPhoneArrHBZSToSystem:(NSArray *)phoneArr;

/**
 *  把系统的电话号码类型标签转换成HBZS的标签
 */
+(NSString *)convertPhoneTypePhoneSystemToHBZS:(NSString *)typeString;

/**
 *  把HBZS的电话号码类型标签转换成系统的标签
 */
+(NSString *)convertPhoneTypeHBZSToPhoneSystem:(NSString *)HBZStype;
@end
