//
//  HB_ContactSendTopTool.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/29.
//
//
//该类用来实现联系人置顶的相关操作

#import <Foundation/Foundation.h>

@interface HB_ContactSendTopTool : NSObject
/**
 *  根据recordID置顶联系人
 */
+(void)contactSendTopWithRecordID:(NSInteger)recordID;
/**
 *  根据recordID取消置顶
 */
+(void)contactCancelBackWithRecordID:(NSInteger)recordID;
/**
 *  根据recordID查询联系人是否被置顶
 */
+(BOOL)contactIsSendTopWithRecordID:(NSInteger)recordID;
/**
 *  查询所有被置顶联系人 (返回一个装有recordID的字典)
 */
+(NSArray *)contactGetAllPeopleWhoSendTop;
/*
 *清除全部
 */
+(void)clearAllTopid;
/*
 *清除部分
 */
+(void)clearTopidsWithArr:(NSArray *)topids;



@end
