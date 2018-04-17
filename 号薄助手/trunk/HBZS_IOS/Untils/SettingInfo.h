//
//  SettingInfo.h
//  HBZS_IOS
//
//  Created by yingxin on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "HB_ContactModel.h"//联系人模型
#import "GetConfigProto.pb.h"

@class DialItem;
@class SyncLogItem;

@interface SettingInfo : NSObject{


}
/*
 *是否初始化过无限时光机
 */
+(void)SetIsInitedInfiniteMachine:(BOOL)IsInited;
+(BOOL)getIsInitedInfiniteMachine;
/*
 *获取上一个版本号，用于对面版本是否更新过
 */
+(NSInteger)getLastVersion;
+(void)saveLastVersion:(NSInteger)version;


///**
// *  验证登录信息
// */
//+(void)provingAccoutInfo;

/**
 *  云名片Url读取，保存，删除
 */
+(void)saveCardShareUrl:(NSString *)Urlstring;
+(NSString *)getCardShareUrl;
+(void)removeCardShareUrl;

/**
 *  URL读取和保存
 */
+(void)saveConfigUrl:(GetConfigResponse *)UrlResponse;
+(GetConfigResponse *)getConfigUrl;

/**
 *  存储一键拨号的模型字典(字典里面的对象是序列化的二进制)
 */
+(void)setOneKeyCall:(NSDictionary*)dict;
/**
 *  获取一键拨号的模型字典(字典里面的对象是序列化的二进制)
 */
+(NSDictionary*)getOneKeyCall;
/**
 *  存储‘我的名片’对应的联系人模型
 */
+(void)setMyCardContactModel:(HB_ContactModel*)model;
/**
 *  获取‘我的名片’对应的联系人模型
 */

+(BOOL)getAccountState;  //登录状态

+(void)setAccountState:(BOOL)isAccount;

+(HB_ContactModel *)getMyCardContactModel;

+(NSInteger)getFirstPageNum;              //默认首页

+(void)setFirstPageNum:(NSInteger)page;

+(void)saveMemberInfo:(NSData *)data;    //memberInfo
+(NSData *)getMemberInfo;

+(NSInteger)getLastPageNum;              //上次页面

+(void)setLastPageNum:(NSInteger)page;

+(BOOL)getIsShowPicInWifi;              //消息中心仅wifi下显示图片

+(void)setIsShowPicInWifi:(BOOL)isShow;

#pragma mark 联系人设置
+(BOOL)getIsShowPicInWifiContactSetting;              //联系人背景仅wifi下显示图片

+(void)setIsShowPicInWifiContactSetting:(BOOL)isShow;

+(BOOL)getIsShowNoNumberContact;          //显示无号码联系人

+(void)setIsShowNoNumberContact:(BOOL)isShow;

+(BOOL)getIsShowContactBg;                //联系人背景

+(void)setIsShowContactBg:(BOOL)isShow;



+(BOOL)getIsBackUpRemind;                 //备份提醒

+(void)setIsBackUpRemind:(BOOL)isRemind;

+ (void)setIsDialSound:(BOOL)bsound;      //拨号音设置

+ (BOOL)getIsDialSound;

+ (void)setIsDialShake:(BOOL)bsound;     //拨号震动设置

+ (BOOL)getIsDialShake;

+ (void)setIsShowArea:(BOOL)bshow;       //归属地显示设置

+ (BOOL)getIsShowArea;

+ (void)setIsAutosyn:(BOOL)Autosyn;    //自动同步设置

+ (BOOL)getIsAutosyn;

+(void)setAutoSyncType:(NSInteger)Type;//自动同步方式

+(NSInteger)getAutoSyncType;

+(void)setlastSyncdate:(NSDate *)date;//上次同步时间

+(NSDate *)getlastSyncdate;

+ (void)setIsSyncHeadimg:(BOOL)bsHead;   //同步头像设置

+ (BOOL)getIsSyncHeadimg;

+ (void)setIPDialNumber:(NSString*)ipNumber;  //IP拨号设置

+ (NSString*)getIPDialNumber;

+ (void)setDialItems:(NSMutableArray*)items;

+ (NSMutableArray*)getDialItems;

+ (DialItem *)getDialItemBy:(NSString *)Phone andId:(NSInteger)recodeID;

+ (void)addDialItems:(DialItem*)dialItem;

+ (void)dialItemBecomeContractItem:(NSString*)number name:(NSString*)name cid:(NSInteger)contactId;

+ (void)setCollectItems:(NSMutableArray*)items;

+ (NSMutableArray*)getCollectItems;

+ (BOOL)isCidInCollectItems:(NSString*)cid;

+ (void)appendCollectItems:(NSString*)cid;

+ (void)removeCollectItemByCid:(NSString*)cid;

+ (void)setContractViewShouldReloadData:(BOOL)reload;

+ (BOOL)getIsContractViewShouldReloadData;

+ (void)setListenAppChangedAddressbook:(BOOL)reload;

+ (BOOL)getIsListenAppChangedAddressbook;

+ (void)syncBegan;

+ (void)syncEnd;

+ (NSDate*)getSyncLastBeganTime;

+ (BOOL)getSyncIsBreak;

+ (void)setSyncLogs:(NSMutableArray*)items;

+ (NSMutableArray*)getSyncLogs;

+ (void)addSyncLog:(SyncLogItem*)logItem;

+ (BOOL)addCustomAreaInfo:(NSString*)number city:(NSString*)city;

+ (NSString*)queryCustomAreaByNumber:(NSString*)number;

+ (NSMutableDictionary*)getAllCustomInfo;

+ (void)removeCustomAreaByNumber:(NSString*)number;

+ (BOOL)editCustomAreaInfoOld:(NSString*)number newNumber:(NSString*)newnumber newCity:(NSString*)city;

+ (void)setIsLogged:(BOOL)bsHead;

+ (BOOL)getIsLogged;


#pragma mark 设置文件不iCloud备份
//批量文件加路径
+ (void)fileList:(NSString*)directory;
//具体标识某个文件
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
