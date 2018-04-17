//
//  FetchDynamicLaunchImg.m
//  HBZS_IOS
//
//  Created by zimbean on 14-7-17.
//
//

#import "FetchDynamicLaunchImgRequest.h"
#import "GetSplashProto.pb.h"
#import "UIDevice+Extension.h"
#import "GetContactAdProto.pb.h"
#import "SettingInfo.h"
@implementation FetchDynamicLaunchImgRequest

+ (void)fetchLaunchImg{
    
    ConfigMgr *userDefaults = [ConfigMgr getInstance];
    
    GetSplashRequest_Builder *builder = [GetSplashRequest builder];
    [builder setTimestamp:0];//[[NSDate date]timeIntervalSince1970]];
    
    if (Device_Height <= 480.0) {//iPhone 5 4inch
        [builder setScreenWidth:640];
        [builder setScreenHeight:960];
    }
    else{
        [builder setScreenWidth:640];
        [builder setScreenHeight:1136];
    }
    [builder setNeedResize:false];
   
    NSString *account = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];    // 从配置文件读取帐号
    NSString *phone = account;
    
    [builder setMobileNum:phone];
    [builder setJobServerId:[[userDefaults getValueForKey:@"LaunchImageId" forDomain:nil] intValue]];
    [builder setTimestamp:[[userDefaults getValueForKey:@"timestamp" forDomain:nil] longLongValue]];
    
    NSString *imsi = [UIDevice getUUID];
    [builder setMobileManufacturer:@"11"];
    [builder setMobileType:[UIDevice currentDevice].model];
    [builder setImsi:imsi];
    [builder setPlatform:PlatformIos];
    
    
    NSString *urlString = [[ConfigMgr getInstance] getValueForKey:@"splashUrl" forDomain:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    GetSplashRequest *getSplashRequest = [builder build];
    NSData *data = [getSplashRequest data];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPBody:data];
    [req setHTTPMethod:@"POST"];
    [req addValue:VersionClient forHTTPHeaderField:@"User-Agent"];
    [req addValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    [req setTimeoutInterval:15.0];
    
    __block NSOperationQueue *fetchLaunchImgQueue = [[NSOperationQueue alloc]init];
    __block GetSplashResponse *splashResponse;
    [NSURLConnection sendAsynchronousRequest:req queue:fetchLaunchImgQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
        if (!error) {
            @try {
                splashResponse = [GetSplashResponse parseFromData:responseData];
            }
            @catch (NSException *exception) {
                return ;
            }
            @finally {
            }
            
            if (splashResponse.jobServerId != 0) {
                
                [userDefaults setValue:[NSNumber numberWithInt:splashResponse.displayTime] forKey:@"displayTime" forDomain:nil];
                [userDefaults setValue:[NSNumber numberWithInt:splashResponse.jobServerId] forKey:@"LaunchImageId" forDomain:nil];
                [userDefaults setValue:[NSNumber numberWithLongLong:splashResponse.timestamp] forKey:@"timestamp" forDomain:nil];
                [userDefaults setValue:[FetchDynamicLaunchImgRequest dateStringToTimeInterval:splashResponse.endDate] forKey:@"launchImageEndTime" forDomain:nil];
                
            }
            ZBLog(@"displayTime:[%d]", splashResponse.displayTime);
            
            //  splashResponse.displayTime
            for (Splash *splash in splashResponse.splashList) {
                
                NSString * imgPath = [FetchDynamicLaunchImgRequest LaunchImgPath];
                BOOL isSuccess = [splash.data writeToFile:imgPath atomically:YES];
                
                if (!isSuccess) {
                    NSLog(@"Launch Img write To File Failed...");
                }
                else
                {
                    [SettingInfo addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:imgPath]];
                }
            }
            
            [fetchLaunchImgQueue release];
            
            }
        else
        {
            NSLog(@"%@",error);
        }
        }];
        
        
}

+(void)contactBgImage
{
    ConfigMgr * defaults = [ConfigMgr getInstance];
    NSData * adresponseData =[defaults getValueForKey:@"ContactAdResponsedata" forDomain:nil];
    GetContactAdResponse * LocalContactAdData = [GetContactAdResponse parseFromData:adresponseData];
    GetContactAdRequest_Builder * builder= [GetContactAdRequest builder];
    [builder setMobileNum:[defaults getValueForKey:@"mobileNum" forDomain:nil]];
    [builder setJobServerId:LocalContactAdData.jobServerId];
    [builder setTimestamp:LocalContactAdData.timestamp];
    [builder setPlatform:PlatformIos];
    [builder setContactNum:[defaults getValueForKey:@"mobileNum" forDomain:nil]];
    [builder setMobileManufacturer:@"11"];
    [builder setMobileType:[UIDevice currentDevice].model];
    
    GetContactAdRequest * getContactAdReq = [builder build];
    NSData * data = [getContactAdReq data];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[ConfigMgr getInstance] getValueForKey:@"getContactAdUrl" forDomain:nil]]];
    [req setHTTPBody:data];
    [req setHTTPMethod:@"POST"];
    [req addValue:VersionClient forHTTPHeaderField:@"User-Agent"];
    [req addValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    [req setTimeoutInterval:15.0];
    
    __block NSOperationQueue *ContactAdImgQueue = [[NSOperationQueue alloc] init];

    __block GetContactAdResponse * ContactAdresponse;
    [NSURLConnection sendAsynchronousRequest:req queue:ContactAdImgQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
        NSLog(@"error:%@",error);
        if (!error) {
            @try {
                ContactAdresponse = [GetContactAdResponse parseFromData:responseData];
            }
            @catch (NSException *exception) {
                NSLog(@"联系人背景失败");
                return ;
            }
            @finally {
            }
            
            if (ContactAdresponse.jobServerId !=0||[ContactAdresponse newContactAdList].count >0) {
                
                [defaults setValue:responseData forKey:@"ContactAdResponsedata" forDomain:nil];
                
                
            }
            ZBLog(@"displayTime:[%d]", ContactAdresponse.timestamp);
            
            
            [ContactAdImgQueue release];
            
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
    
}
+(NSNumber *)dateStringToTimeInterval:(NSString *)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    
    NSDate * EndDate = [formatter dateFromString:dateString];
    NSTimeInterval enddateinterval = [EndDate timeIntervalSince1970];
    
    [formatter release];
    
    return [NSNumber numberWithDouble:enddateinterval];
}


+(NSString *)LaunchImgPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSString *imgPath = [documentPath stringByAppendingPathComponent:@"LaunchImg.data"];
    return imgPath;
}
@end
