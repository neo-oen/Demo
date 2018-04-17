//
//  HB_ContactSendTopTool.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/29.
//
//该类用来实现联系人置顶的相关操作

#define KEY_SendTopTool @"sendTopContact"

#import "HB_ContactSendTopTool.h"

@implementation HB_ContactSendTopTool

+(void)contactSendTopWithRecordID:(NSInteger)recordID{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //1.从userDefaults中获取recordID数组
    NSArray * tempArr=[userDefaults objectForKey:KEY_SendTopTool];
    NSMutableArray * contactArr=[tempArr mutableCopy];
    //2.如果没有该数组，则创建
    if (contactArr==nil) {
        contactArr=[NSMutableArray array];
    }
    //3.向数组中存入数据
    [contactArr addObject:[NSNumber numberWithInteger:recordID]];
    //4.存入数组
    [userDefaults setObject:contactArr forKey:KEY_SendTopTool];
    [userDefaults synchronize];
    [contactArr release];
}
+(void)contactCancelBackWithRecordID:(NSInteger)recordID{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //1.从userDefaults中获取recordID数组
    NSArray * tempArr=[userDefaults objectForKey:KEY_SendTopTool];
    NSMutableArray * contactArr=[tempArr mutableCopy];
    //2.如果没有该数组
    if (contactArr==nil) {
        ZBLog(@"取消置顶，出错了");
    }
    //3.从数组中删除数据
    for (int i=0; i<contactArr.count; i++) {
        //遍历，找到该recordID,删除
        NSNumber * number=contactArr[i];
        if (number.integerValue==recordID) {
            [contactArr removeObject:number];
        }
    }
    //4.存入数组
    [userDefaults setObject:contactArr forKey:KEY_SendTopTool];
    [userDefaults synchronize];
}
+(BOOL)contactIsSendTopWithRecordID:(NSInteger)recordID{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //1.从userDefaults中获取recordID数组
    NSMutableArray * contactArr=[userDefaults objectForKey:KEY_SendTopTool];
    //2.如果没有该数组
    if (contactArr==nil) {
        return NO;
    }
    //3.从数组中查找该数据
    for (int i=0; i<contactArr.count; i++) {
        //遍历，查找该recordID，如果找到，返回yes
        NSNumber * number=contactArr[i];
        if (number.integerValue==recordID) {
            return YES;
        }
    }
    return NO;
}
+(NSArray *)contactGetAllPeopleWhoSendTop{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //1.从userDefaults中获取recordID数组
    NSMutableArray * contactArr=[userDefaults objectForKey:KEY_SendTopTool];
    //2.如果没有该数组
    if (contactArr==nil) {
        contactArr=[[[NSMutableArray alloc]init] autorelease];
        //3.存入数组
        [userDefaults setObject:contactArr forKey:KEY_SendTopTool];
    }
    return contactArr;
}

+(void)clearAllTopid
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:KEY_SendTopTool];
    [userDefaults synchronize];
}

+(void)clearTopidsWithArr:(NSArray *)topids
{
    for (NSNumber * topid in topids) {
        [HB_ContactSendTopTool contactCancelBackWithRecordID:topid.intValue];
    }
}

@end
