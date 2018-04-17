//
//  SettingInfo.m
//  HBZS_IOS
//
//  Created by yingxin on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingInfo.h"
#import "ContactItems.h"
#import "SyncLogItem.h"

#define P_MyCard @"p_myCardModel"//‘我的名片’
#define P_OneKeyCall @"p_OneKeyCall"//一键拨号

#define P_ISDIALSOUND @"p_bdsnd"//按键声音

#define P_ISDIALSHAKE @"p_bdshk"//按键振动

#define P_IS_CALL_SUCCESS_SHAKE @"p_isCallSuccessShake"//去电接通振动

#define P_IPDIALNUM   @"p_ipads"//IP前缀

#define P_DIALITEMS   @"p_dialitems"

#define P_COLLECTITEMS   @"p_collectitems"

#define P_ISRELOADCT  @"p_breload"

#define P_ISLISTEN    @"p_blisten"

#define P_ISSHOWAREA  @"p_bshowarea"//归属地显示

#define P_ISSYNCHEAD  @"p_bsynchead"//头像同步

#define P_ISAUTOSYN @"p_isautosyn" //自动同步

#define P_BSYNCBEGAN  @"p_syncbegan"

#define P_SYNCBEGANTIME  @"p_syncbegantime"

#define P_ISLOGGED  @"p_bislogged"

#define P_SYNCLOGITEMS   @"p_synclogitems"

#define P_CUSTOMAREAINFO   @"p_customareainfo"

@implementation SettingInfo

//#pragma mark - 设置‘我的名片’
//+(void)provingAccoutInfo
//{
//    
//}

+(void)SetIsInitedInfiniteMachine:(BOOL)IsInited
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:IsInited forKey:@"IsInitedInfiniteMachine"];
    [userDefaults synchronize];
}
+(BOOL)getIsInitedInfiniteMachine
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"IsInitedInfiniteMachine"];
}


#pragma mark - 缓存版本号
+(NSInteger)getLastVersion;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:@"LastVersion"];
}
+(void)saveLastVersion:(NSInteger)version
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:version forKey:@"LastVersion"];
    [userDefaults synchronize];
}

#pragma mark - 云名片Url
+(void)saveCardShareUrl:(NSString *)Urlstring withSid:(int32_t)sid
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:Urlstring forKey:@"MyCardUrl"];
    [userDefaults synchronize];
}
+(NSString *)getCardShareUrl;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"MyCardUrl"];
}
+(void)removeCardShareUrl
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"MyCardUrl"];
    [userDefaults synchronize];
}


#pragma mark - 设置‘我的名片’选项的信息
+(void)setMyCardContactModel:(HB_ContactModel *)model{
    NSData * data=[NSKeyedArchiver archivedDataWithRootObject:model];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:P_MyCard];
    [userDefaults synchronize];
}
+(HB_ContactModel *)getMyCardContactModel{
    NSData * data=[[NSUserDefaults standardUserDefaults]objectForKey:P_MyCard];
    HB_ContactModel * model=nil;
    if (data) {
        model=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return model;
}
#pragma mark - 设置一键拨号的模型数组
+(void)setOneKeyCall:(NSDictionary *)dict{
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:P_OneKeyCall];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDictionary *)getOneKeyCall{
    NSDictionary * dict=[[NSUserDefaults standardUserDefaults]objectForKey:P_OneKeyCall];
    return dict;
}

#pragma mark urlconfig
+(void)saveConfigUrl:(GetConfigResponse *)UrlResponse
{
    NSData * data = [UrlResponse data];
    [[ConfigMgr getInstance] setValue:data forKey:@"UrlsConfig" forDomain:nil];
    
}
+(GetConfigResponse *)getConfigUrl
{
    NSData * data =[[ConfigMgr getInstance] getValueForKey:@"UrlsConfig" forDomain:nil];
    GetConfigResponse * urls = [GetConfigResponse parseFromData:data];
    return urls;
}


+(BOOL)getIsShowPicInWifiContactSetting              //联系人背景仅wifi下显示图片
{
     return [[NSUserDefaults standardUserDefaults] boolForKey:@"PicInWifiContactSetting"];
}
+(void)setIsShowPicInWifiContactSetting:(BOOL)isShow
{
    [[NSUserDefaults standardUserDefaults] setBool:isShow forKey:@"PicInWifiContactSetting"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL)getIsShowNoNumberContact;          //显示无号码联系人
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"NoNumberContact"];

}
+(void)setIsShowNoNumberContact:(BOOL)isShow;
{
    [[NSUserDefaults standardUserDefaults] setBool:isShow forKey:@"NoNumberContact"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL)getIsShowContactBg;                //联系人背景
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ContactBg"];

}
+(void)setIsShowContactBg:(BOOL)isShow;
{
    [[NSUserDefaults standardUserDefaults] setBool:isShow forKey:@"ContactBg"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 登录状态
+(BOOL)getAccountState
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AccountRowIsRefresh"];
}

+(void)setAccountState:(BOOL)isAccount
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:isAccount forKey:@"AccountRowIsRefresh"];
    [userDefault synchronize];
}

//会员信息
+(void)saveMemberInfo:(NSData *)data
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:data forKey:@"MemberInfo"];
    [userDefault synchronize];

}
+(NSData *)getMemberInfo
{
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"MemberInfo"];
}

+(void)deleteMemberInfo
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"MemberInfo"];
    [userDefault synchronize];
}



#pragma mark 设置拨号按键音
+ (void)setIsDialSound:(BOOL)bsound{
    [[NSUserDefaults standardUserDefaults] setBool:bsound forKey:P_ISDIALSOUND];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getIsDialSound{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:P_ISDIALSOUND];
}

#pragma mark 设置拨号按键震动
+ (void)setIsDialShake:(BOOL)bsound{
    [[NSUserDefaults standardUserDefaults] setBool:bsound
                                            forKey:P_ISDIALSHAKE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getIsDialShake{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:P_ISDIALSHAKE];
}
#pragma mark 归属地显示设置
+ (void)setIsShowArea:(BOOL)bshow{
    [[NSUserDefaults standardUserDefaults] setBool:bshow
                                            forKey:P_ISSHOWAREA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getIsShowArea{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:P_ISSHOWAREA];
}

#pragma mark 自动同步设置
+(void)setIsAutosyn:(BOOL)Autosyn
{
    [[NSUserDefaults standardUserDefaults] setBool:Autosyn forKey:P_ISAUTOSYN];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getIsAutosyn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:P_ISAUTOSYN];
}

#pragma mark 上次备份时间
+(void)setlastSyncdate:(NSDate *)date
{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"lastSyncTime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDate *)getlastSyncdate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncTime"];
}

#pragma mark 自动同步触发方式
+(void)setAutoSyncType:(NSInteger)Type
{
    [[NSUserDefaults standardUserDefaults] setInteger:Type forKey:@"AutoSyncType"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSInteger)getAutoSyncType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"AutoSyncType"];
}
#pragma mark 联系人头像同步设置
+ (void)setIsSyncHeadimg:(BOOL)bsHead{
    [[NSUserDefaults standardUserDefaults] setBool:bsHead forKey:P_ISSYNCHEAD];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getIsSyncHeadimg{
    return [[NSUserDefaults standardUserDefaults] boolForKey:P_ISSYNCHEAD];
}

#pragma mark 默认界面设置
+(NSInteger)getFirstPageNum
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"FirstPageNum"];
}

+(void)setFirstPageNum:(NSInteger)page
{
    [[NSUserDefaults standardUserDefaults] setInteger:page forKey:@"FirstPageNum"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 上次页面
+(NSInteger)getLastPageNum
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"LastPageNum"];
}

+(void)setLastPageNum:(NSInteger)page
{
    [[NSUserDefaults standardUserDefaults] setInteger:page forKey:@"LastPageNum"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 仅WiFi下显示图片 设置
+(BOOL)getIsShowPicInWifi
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"IsShowPicInWifi"];
}

+(void)setIsShowPicInWifi:(BOOL)isShow
{
    [[NSUserDefaults standardUserDefaults] setBool:isShow forKey:@"IsShowPicInWifi"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 备份提醒
+(BOOL)getIsBackUpRemind
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"IsBackUpRemind"];
}

+(void)setIsBackUpRemind:(BOOL)isRemind
{
    [[NSUserDefaults standardUserDefaults] setBool:isRemind forKey:@"IsBackUpRemind"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 保存系统日志 设置
+ (void)setIsLogged:(BOOL)bsHead{
    [[NSUserDefaults standardUserDefaults] setBool:bsHead forKey:P_ISLOGGED];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getIsLogged{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:P_ISLOGGED];
}

#pragma mark IP前缀设置
+ (void)setIPDialNumber:(NSString *)ipNumber{
    if (ipNumber == nil) {
        return ;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:ipNumber forKey:P_IPDIALNUM];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getIPDialNumber{
    return [[NSUserDefaults standardUserDefaults] valueForKey:P_IPDIALNUM];
}

+ (void)setDialItems:(NSMutableArray*)items
{
    if (items == nil) {
        return ;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:items];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:P_DIALITEMS];
     [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)getDialItems{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [defaults objectForKey:P_DIALITEMS];
    
    if (data == nil) {
        return nil ;
    }
    
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return arr;
}

+ (DialItem *)getDialItemBy:(NSString *)Phone andId:(NSInteger)recodeID
{
    NSMutableArray * arr = [SettingInfo getDialItems];
    DialItem * item = nil ;
    for (DialItem * tempItem in arr) {
        if ([tempItem.phone isEqualToString:Phone] && tempItem.contactID == recodeID) {
            item = tempItem;
            break;
        }
    }
    return item;
}

#pragma mark 增加拨打电话记录
+ (void)addDialItems:(DialItem *)dialItem
{
    if (dialItem == nil || ![dialItem isKindOfClass:[DialItem class]]){
        return;
    }
    
    NSMutableArray *dialArray = [self getDialItems];
    
    if (dialArray == nil){
        [dialItem.times addObject:[NSDate date]];
        
        dialArray = [[NSMutableArray alloc]initWithObjects:dialItem,nil];
        
        [self setDialItems:dialArray];
        
        [dialArray release];
        
        return;
    }
    
    int indexExists = -1;
    
    for (int i = 0 ; i < [dialArray count] ; i ++){
        DialItem* dlObj = [dialArray objectAtIndex:i];
        
        if ([dlObj.phone isEqualToString:dialItem.phone]){
            indexExists = i;
            
            [dlObj.times insertObject:[NSDate date] atIndex:0];
            
            [dialArray insertObject:dlObj atIndex:0];
            
            [dialArray removeObjectAtIndex:i+1];
            
            break;
        }
    }
    
    if (indexExists < 0)
    {
        DialItem* dlNewObj = [[DialItem alloc]init];
        
        dlNewObj.name = dialItem.name;
        
        dlNewObj.phone = dialItem.phone;
        
        dlNewObj.contactID = dialItem.contactID;
        
        [dlNewObj.times addObject:[NSDate date]];
        
        [dialArray insertObject:dlNewObj atIndex:0];
        
        [dlNewObj release];
    }
    
    [self setDialItems:dialArray];
}

+ (void)dialItemBecomeContractItem:(NSString*)number name:(NSString*)name cid:(NSInteger)contactId{
    if (number == nil || contactId<0) {
        return ;
    }
    
    NSMutableArray *dialArray = [NSMutableArray array];
    
    [dialArray addObjectsFromArray:[self getDialItems]];
    
    if (dialArray == nil) {
        return;
    }
    
    int indexExists = -1;
    
    for (int i = 0 ; i < [dialArray count] ; i ++) {
        DialItem* dlObj = [dialArray objectAtIndex:i];
        
        if ([dlObj.phone isEqualToString:number]) {
            indexExists = i;
            
            dlObj.contactID = contactId;
            
            dlObj.name = name;
            break;
        }
    }
    
    if (indexExists >= 0) {
        [self setDialItems:dialArray];
    }
}

#pragma mark 保存 收藏联系人
+ (void)setCollectItems:(NSMutableArray*)items{
    if (items == nil) {
        return ;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:items];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:P_COLLECTITEMS];
}

+ (NSMutableArray*)getCollectItems {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [defaults objectForKey:P_COLLECTITEMS];
    
    if (data == nil) {
        return nil ;
    }
    
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return arr;
}

+ (BOOL)isCidInCollectItems:(NSString*)cid{
    NSMutableArray* collectArray = [SettingInfo getCollectItems];
    
    if (collectArray==nil) {
        return NO;
    }
    
    BOOL result = NO;
    
    for (NSString*collCid in collectArray) {
        if ([cid isEqualToString:collCid]) {
            result = YES;
            
            break ;
        }
    }
    
    return result;
}

+ (void)appendCollectItems:(NSString*)cid{
    if ([SettingInfo isCidInCollectItems:cid]){
        return;
    }
    
    NSMutableArray* collectArray = [SettingInfo getCollectItems];
    
    if (collectArray) {
        [collectArray addObject:cid];
    }else {
        collectArray = [NSMutableArray arrayWithObject:cid];
    }
    
    [SettingInfo setCollectItems:collectArray];
}

#pragma mark 删除收藏的联系人
+ (void)removeCollectItemByCid:(NSString*)cid{
    NSMutableArray* collectArray = [SettingInfo getCollectItems];
    
    if(collectArray==nil)
        return;
    
    [collectArray removeObject:cid];
    
    [SettingInfo setCollectItems:collectArray];
}

+ (void)setContractViewShouldReloadData:(BOOL)reload{
    [[NSUserDefaults standardUserDefaults] setBool:reload forKey:P_ISRELOADCT];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getIsContractViewShouldReloadData{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:P_ISRELOADCT];
}

+ (void)setListenAppChangedAddressbook:(BOOL)reload{
    [[NSUserDefaults standardUserDefaults] setBool:reload forKey:P_ISLISTEN];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getIsListenAppChangedAddressbook{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:P_ISLISTEN];
}

+ (void)syncBegan{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:P_BSYNCBEGAN];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]  forKey:P_SYNCBEGANTIME];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate*)getSyncLastBeganTime{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:P_SYNCBEGANTIME];
}

+ (void)syncEnd{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:P_BSYNCBEGAN];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 判断上次同步是否中断
+ (BOOL)getSyncIsBreak{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:P_BSYNCBEGAN];
}

+ (void)setSyncLogs:(NSMutableArray*)items {
    if (items==nil) {
        return ;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:items];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:P_SYNCLOGITEMS];
}

+ (NSMutableArray*)getSyncLogs{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [defaults objectForKey:P_SYNCLOGITEMS];
    
    if (data==nil) {
        return nil;
    }
    
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return arr;
}

#pragma mark 增加同步日志
+ (void)addSyncLog:(SyncLogItem*)logItem{
    
    if (logItem==nil||![logItem isKindOfClass:[SyncLogItem class]]) {
        return ;
    }
    
    NSMutableArray*syncLogArray = [self getSyncLogs];
    
    if (syncLogArray==nil) {
        syncLogArray = [NSMutableArray arrayWithObject:logItem];
        
        [self setSyncLogs:syncLogArray];
        return ;
    }
    
    [syncLogArray insertObject:logItem atIndex:0];
    
    [self setSyncLogs:syncLogArray];
}

+ (BOOL)verifyCityIsExist:(NSString *)city area:(NSDictionary *)areaDic{
    BOOL isExist = YES;
    
    NSArray *allValues = [areaDic allValues];
    
    isExist = ([allValues containsObject:city]) ? YES : NO;
    
    return isExist;
}

+ (BOOL)verifyPhoneNumberPrefixIsExist:(NSString *)prefix area:(NSDictionary *)areaDic{
    BOOL isExist = YES;
    
    NSArray *allKeys = [areaDic allKeys];
    
    isExist = ([allKeys containsObject:prefix]) ? YES : NO;
    
    return isExist;
}

#pragma mark 添加自定义归属地
+ (BOOL)addCustomAreaInfo:(NSString*)number city:(NSString*)city{
    BOOL result = NO;
    
    if (number == nil || city == nil || [number length] < 1 || [city length] < 1) {
        return  result;
    }
    
    NSDictionary* customAreaDic = [[NSUserDefaults standardUserDefaults] objectForKey:P_CUSTOMAREAINFO];
    
    if (customAreaDic == nil) //如果未设置过
    {
        customAreaDic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObject:city]
                                                             forKeys:[NSArray arrayWithObject:number]];
        
        [[NSUserDefaults standardUserDefaults] setObject:customAreaDic forKey:P_CUSTOMAREAINFO];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [customAreaDic autorelease];
        
        result = YES;
    }
    else
    {
        if ([customAreaDic objectForKey:number]){
            result = NO;
        }
        else if([self verifyCityIsExist:city area:customAreaDic]){
            result = NO;
        }
        else
        {
            NSMutableDictionary* saveAreaDic = [[[NSMutableDictionary alloc]
                                                 initWithDictionary:customAreaDic] autorelease];
            
            [saveAreaDic setObject:city forKey:number];
            
            [[NSUserDefaults standardUserDefaults] setObject:saveAreaDic forKey:P_CUSTOMAREAINFO];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            result = YES;
        }
    }
    
    return result;
}

#pragma mark 查询号码归属地
+ (NSString*)queryCustomAreaByNumber:(NSString*)number{
    NSString* result = nil;
    
    NSMutableDictionary* customAreaDic = [[NSUserDefaults standardUserDefaults] objectForKey:P_CUSTOMAREAINFO];
    
    if (customAreaDic!=nil) {
        NSArray* keys = [customAreaDic allKeys];
        
        NSString* thekey = nil ;
        
        for (NSString* key in keys) {
            NSRange range = [number rangeOfString:key];
            
            if(range.length>0 && range.location == 0){
                thekey = key;
                break;
            }
        }
        
        result = [customAreaDic objectForKey:thekey];
    }
    
    return  result;
}

+ (NSMutableDictionary*)getAllCustomInfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:P_CUSTOMAREAINFO];
}

#pragma mark 删除自定义归属地
+ (void)removeCustomAreaByNumber:(NSString*)number{
    if (number == nil || [number length]<1) {
        return;
    }
    
    NSDictionary* customAreaDic = [[NSUserDefaults standardUserDefaults] objectForKey:P_CUSTOMAREAINFO];
    
    if (customAreaDic == nil)
    {
    }
    else
    {
        if ([customAreaDic objectForKey:number]) {
            NSMutableDictionary* saveAreaDic = [[NSMutableDictionary alloc] initWithDictionary:customAreaDic];
            [saveAreaDic removeObjectForKey:number];
            
            [[NSUserDefaults standardUserDefaults] setObject:saveAreaDic forKey:P_CUSTOMAREAINFO];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [saveAreaDic release];
        }
    }
}

#pragma mark 编辑自定义归属地信息
+ (BOOL)editCustomAreaInfoOld:(NSString*)number newNumber:(NSString*)newnumber newCity:(NSString*)city{
    BOOL result = NO;
    
    if (number == nil || city == nil || [number length] < 1 || [city length] < 1) {
        return  result;
    }
    
    NSDictionary* customAreaDic = [[NSUserDefaults standardUserDefaults] objectForKey:P_CUSTOMAREAINFO];
  
    if ([self verifyPhoneNumberPrefixIsExist:newnumber area:customAreaDic]) {
        return result;
    }
    
    if (customAreaDic != nil) {
        if ([customAreaDic objectForKey:number]) {
            NSMutableDictionary* saveAreaDic = [[NSMutableDictionary alloc] initWithDictionary:customAreaDic];
            
            [saveAreaDic removeObjectForKey:number];
            
            [saveAreaDic setObject:city forKey:newnumber];
            
            [[NSUserDefaults standardUserDefaults] setObject:saveAreaDic forKey:P_CUSTOMAREAINFO];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [saveAreaDic release];
            
            result = YES;
        }
    }
    
    return result;
}



#pragma mark 设置iCloud不备份
+ (void)fileList:(NSString*)directory{
    
    NSError *error = nil;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:directory error:&error];
    
    for (NSString* each in fileList) {
        
        NSMutableString* path = [[NSMutableString alloc]initWithString:directory];
        
        [path appendFormat:@"/%@",each];
        
        NSURL *filePath = [NSURL fileURLWithPath:path];
        
        [SettingInfo addSkipBackupAttributeToItemAtURL:filePath];
        
//        [self fileList:path];
        
        [path release];
        
    }
    
}
//给文件添加不备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    NSLog(@"%@",URL.absoluteString);
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    
    return success;
    
    
}

@end
