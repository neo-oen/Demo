//
//  PushManager.m
//  HBZS_iOS
//
//  Created by 冯强迎 on 15/3/27.
//
//


#import "PushManager.h"
#import "GetSysMsgProto.pb.h"
#import "UIDevice+Extension.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "MessageDetailVC.h"
#import "MainViewCtrl.h"
#import "GetMemberInfoProto.pb.h"

@implementation PushManager
@class PushManager;
static PushManager * manager;
+(PushManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager  = [[PushManager alloc] init];
    });
    return manager;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.Version_client = [NSString stringWithFormat:VersionClient];
    }
    return self;
}

#pragma mark 上传token
-(BOOL)pushInfoToServerWithToken:(NSString *)deviceToken andUserID:(NSString *)UserID
{
    ASIHTTPRequest * request = [self DeviceTokenReportrequest];
    DeviceTokenReportRequest * tokeninfo = [[[[[DeviceTokenReportRequest builder] setDeviceToken:deviceToken] setMdn:UserID] setMobileType:[self doDevicePlatform]] build];
    
    NSData * data = [tokeninfo data];

    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[data length]]];
    
    [request setPostBody:[NSMutableData dataWithData:data]];
    
    request.delegate = self;
    [request startAsynchronous];
    
    NSError * error = [request error];
    
    if (!error) {
        return  YES;
    }
    
    return NO;
}

-(ASIHTTPRequest *)DeviceTokenReportrequest
{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.deviceTokenReportUrl]];
    [request setRequestMethod:@"POST"];
    
    [request addRequestHeader:@"User-Agent" value:self.Version_client];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    [request setShouldContinueWhenAppEntersBackground:YES];
    
    return request;
}
/*上传Token*/



-(BOOL)getMessgerforServer
{
    GetSysMsgRequest_Builder *builder = [GetSysMsgRequest builder];
    
    NSString *phone = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];    // 从配置文件读取帐号名密码
    NSString *imsi = [UIDevice getUUID];

    [builder setMobileNum:phone];
    [builder setImsi:imsi];
    [builder setMobileManufacturer:@"Apple"];
    [builder setPlatform:PlatformIos];
    [builder setMobileType:[self doDevicePlatform]];
    [builder addAllMessages:[self SetMutableMessagesList]];
    
    NSData *requestData = [[builder build] data];
    
    NSString *urlString = [[ConfigMgr getInstance] getValueForKey:@"getSysMsgUrl" forDomain:nil];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];//@"http://118.85.200.200:8440/sync_rpc/getsysmsg.uab"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:requestData];
    [urlRequest addValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *httpURLResponse;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&httpURLResponse error:&error];
    
    if (httpURLResponse.statusCode == 200) {
        GetSysMsgResponse * getSysMsgResponse = [GetSysMsgResponse parseFromData:responseData];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentDirectory = [paths objectAtIndex:0];
        
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MessageCenter.db"];
        
        FMDatabase * db = [[FMDatabase alloc]initWithPath:dbPath] ;
        
        if (![db open]) {
            
            NSLog(@"Could not open db.");
            [db release];
            return NO;
            
        }
        for (SysMsg *newMessage in getSysMsgResponse.messagesList) {
        
            if (newMessage.memberType == MemberLevelVip) {
                continue;
            }
            
            BOOL isDelSuccess = [db executeUpdate:@"Delete from NewMessage where jobServerId = ?",[NSString stringWithFormat:@"%d",newMessage.jobServerId]];
            
            if (!isDelSuccess) {
                return NO;
            }
            //当某条消息更新时 先删除原来的 在进行插入
            
            BOOL isSuccess = [db executeUpdate:@"insert into NewMessage (jobServerId,timestamp,isRead,iconUrl,title,content,imgTitleUrl,imgContentUrl1,imgContentUrl2,imgContentUrl3, urlDetail) values(?,?,?,?,?,?,?,?,?,?,?)", [NSNumber numberWithInt:newMessage.jobServerId],[NSNumber numberWithLongLong:newMessage.timestamp], [NSNumber numberWithInt:0], newMessage.imgLogo, newMessage.title, newMessage.content, newMessage.imgTitleUrl ,newMessage.imgContentUrl1, newMessage.imgContentUrl2, newMessage.imgContentUrl3, newMessage.urlDetail];
            
            if (!isSuccess) {
                NSLog(@"Insert Failed...");
            }
            
            [self saveMessageJobID:newMessage.jobServerId andtimestamp:newMessage.timestamp];
        }
        
        [db close];
        
    }
    else
    {
        NSLog(@"请求消息失败");
        return NO;
    }
    return YES;
}


-(NSArray *)getmemberHotActivityFormServer
{
    GetSysMsgRequest_Builder *builder = [GetSysMsgRequest builder];
    
    NSString *phone = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];    // 从配置文件读取帐号名密码
    NSString *imsi = [UIDevice getUUID];
    
    [builder setMobileNum:phone];
    [builder setImsi:imsi];
    [builder setMobileManufacturer:@"Apple"];
    [builder setPlatform:PlatformIos];
    [builder setMobileType:[self doDevicePlatform]];
    [builder addAllMessages:[self SetMutableMessagesList]];
    
    NSData *requestData = [[builder build] data];
    
    NSString *urlString = [[ConfigMgr getInstance] getValueForKey:@"getSysMsgUrl" forDomain:nil];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];//@"http://118.85.200.200:8440/sync_rpc/getsysmsg.uab"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:requestData];
    [urlRequest addValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    NSHTTPURLResponse *httpURLResponse;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&httpURLResponse error:&error];
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    if (httpURLResponse.statusCode == 200)
    {
        GetSysMsgResponse * getSysMsgResponse = [GetSysMsgResponse parseFromData:responseData];
         for (SysMsg * newMessage in getSysMsgResponse.messagesList)
         {
//             if (newMessage.memberType == MemberLevelVip) {
//             }
             [arr addObject:newMessage];

         }
    }
    
    return arr;
}

#pragma mark --本地记录消息id和获取时间
/*地记录消息id和获取时间*/
-(void)saveMessageJobID:(NSInteger)MessagerID andtimestamp:(int64_t)timestamp
{
    NSMutableArray * mesagerIDList = [NSMutableArray arrayWithCapacity:0];
    NSArray * dataArray = [self loadMessageJobIDAndtimestampList];
    [mesagerIDList addObjectsFromArray:dataArray];
    if (mesagerIDList.count>=20) {
        [mesagerIDList removeObjectAtIndex:0];
        
    }
    
    NSDictionary * dic = @{@"jobServerId": [NSNumber numberWithInt:MessagerID],@"timestamp": [NSNumber numberWithLongLong:timestamp]};
    [mesagerIDList addObject:dic];
    [[NSUserDefaults standardUserDefaults] setObject:mesagerIDList forKey:@"MessageJobIDList"];

}
-(NSArray *)loadMessageJobIDAndtimestampList
{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"MessageJobIDList"];
    return array;
}

-(NSArray *)SetMutableMessagesList
{
    NSArray * array = [self loadMessageJobIDAndtimestampList];
    NSMutableArray * MutableMessagesList = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in array) {
        RequestSysMsg * reSysMsg = [[[[RequestSysMsg builder] setJobServerId:[dic[@"jobServerId"] intValue]] setTimestamp:[dic[@"timestamp"] longLongValue]] build];
        [MutableMessagesList addObject:reSysMsg];

    }
    
//    for (int i = 0; i<1; i++) {
//        RequestSysMsg * reSysMsg = [[[[RequestSysMsg builder] setJobServerId:1] setTimestamp:2]build];
//        [MutableMessagesList addObject:reSysMsg];
//    }
//    for (int i = 0; i<1; i++) {
//        RequestSysMsg * reSysMsg = [[[[RequestSysMsg builder] setJobServerId:129] setTimestamp:2]build];
//        [MutableMessagesList addObject:reSysMsg];
//    }
    //[dic[@"jobServerId"] intValue] [dic[@"timestamp"] longLongValue]
    
    return MutableMessagesList;
    
}
/*地记录消息id和获取时间*/



- (NSString*) doDevicePlatform
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
//    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
//    else if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
//    else if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
//    else if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
//    else if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
//    else if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
//    else if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
//    else if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
//    else if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
//    else if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
//    else if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
//    else if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
//    else if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
//    else if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
//    else if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
//    
//    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
//    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
//    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
//    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
//    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
//    
//    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
//    
//    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
//    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
//    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
//    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
//    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
//    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
//    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
//    
//    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
//    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
//    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
//    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
//    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
//    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
//    
//    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
//    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
//    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
//    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
//    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
//    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
//    
//    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
//    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString*) doDevicePlatform
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

#pragma mark - 获取当前显示的Controller 推送消息跳转时可能会调用 暂时没用
/*
 * 获取current UIViewController
 */
-(UIViewController *)getCurrentVC
{
    UIViewController * result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray * windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView * frontView = [[window subviews] objectAtIndex:0];
    
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    
    return result;
}

#pragma mark 消息跳转
-(void)pushToViewControllver:(int)MessageID andMainVc:(MainViewCtrl *)mainVc
{
    
    FMDatabase * db = [[FMDatabase alloc]initWithPath:[PathManager dbPath]];
    
    if (![db open]) {
        
        NSLog(@"Could not open db.");
        [db release];
        return;
        
    }

    FMResultSet *newMessageResultSet = [db executeQuery:@"Select * from NewMessage where jobServerId = ?",[NSString stringWithFormat:@"%d",MessageID]];
    if ([newMessageResultSet next]) {
        
        NewMessage * msg = [[NewMessage alloc] init];
        msg.jobServerId = [newMessageResultSet intForColumn:@"jobServerId"];
        msg.isRead = [newMessageResultSet intForColumn:@"isRead"];
        msg.iconUrl = [newMessageResultSet stringForColumn:@"iconUrl"];
        msg.title = [newMessageResultSet stringForColumn:@"title"];
        msg.content = [newMessageResultSet stringForColumn:@"content"];
        msg.imgContentUrl1 = [newMessageResultSet stringForColumn:@"imgContentUrl1"];
        msg.imgContentUrl2 = [newMessageResultSet stringForColumn:@"imgContentUrl2"];
        msg.imgContentUrl3 = [newMessageResultSet stringForColumn:@"imgContentUrl3"];
        msg.urlDetail = [newMessageResultSet stringForColumn:@"urlDetail"];

        
        MessageDetailVC *detailVC = [[MessageDetailVC alloc]initWithMessage:msg];
        detailVC.leftBtnIsBack = YES;
        [mainVc.navigationController pushViewController:detailVC animated:YES];
        
        
        [detailVC release];
        [msg release];
    }
    [db close];
}



#pragma mark 获取未读消息数量
-(NSInteger)getNoReadMessagesCount
{
    FMDatabase * db = [[FMDatabase alloc] initWithPath:[PathManager dbPath]];
    if (![db open]) {
        
        NSLog(@"Could not open db.");
        [db release];
        return NO;
    }
    
    FMResultSet * result = [db executeQuery:@"SELECT COUNT(isRead) FROM NewMessage  WHERE isRead=0"];
    
    if ([result next])
    {
        NSInteger count = [result intForColumnIndex:0];
        [db close];
        return count;
    }
    [db close];
    return 0;
}




@end
