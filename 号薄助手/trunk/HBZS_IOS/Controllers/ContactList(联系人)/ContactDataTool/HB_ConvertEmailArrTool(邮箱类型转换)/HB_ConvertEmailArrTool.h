//
//  HB_ConvertEmailArrTool.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/13.
//
//
/*
 主要功能：把系统的邮箱类型和号簿助手的4种类型做一一对应
         _$!<Home>!$_   ‘常用邮箱’
         _$!<Work>!$_   ‘商务邮箱’
         iCloud         ‘个人邮箱’
         _$!<Other>!$_  ‘其他邮箱’
 
 */

#import <Foundation/Foundation.h>

@interface HB_ConvertEmailArrTool : NSObject
/**
 *  把系统的邮箱类型标签转换成号簿助手的标签
 */
+(NSMutableArray *)convertEmailTypeWithArraySystemToHBZS:(NSArray *)emailArr;
/**
 *  把号簿助手的邮箱类型标签转换成系统的标签（用于存储的时候）
 */
+(NSMutableArray *)convertEmailTypeWithArrayHBZSToSystem:(NSArray *)emailArr;


/**
 *  把系统的邮箱类型标签转换成号簿助手的标签
 */
+(NSString * )convertEmailTypeSystemToHBZS:(NSString *)typeString;
/**
 *  把号簿助手的邮箱类型标签转换成系统的标签（用于存储的时候）
 */
+(NSString *)convertEmailTypeHBZSToSystem:(NSString *)HBZSstring;

@end
