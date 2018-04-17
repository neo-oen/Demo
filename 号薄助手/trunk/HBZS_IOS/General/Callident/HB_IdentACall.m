//
//  HB_IdentACall.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/12/7.
//
//

#import "HB_IdentACall.h"
#import "SVProgressHUD.h"
#import "HB_PackageVersionModel.h"
#import "HB_packageDownloadModel.h"


@implementation HB_IdentACall

+(void)registerDhb
{
    [DHBSDKApiManager registerApp:APIKEY
                        signature:APISIG
                             host:kDHBHost
                           cityId:nil shareGroupIdentifier:groupid
                  completionBlock:^(NSError *error) {
                      NSLog(@"%@", error);
                      
                  }];
    
  
}



/**
 验证数据正确性
 */
- (void)validateData {
    NSString *filePath = [DHBSDKApiManager shareManager].pathForBridgeOfflineFilePath;
    NSUInteger count = 0;
    
    NSString *filePathI=[[NSString alloc] initWithFormat:@"%@/BridgeFile",filePath];
    
    for (int i=0;i<1000;i++) {
        @autoreleasepool {
            NSString * filePathIZip=[[NSString alloc] initWithFormat:@"%@Cache%d",filePath,i];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePathIZip])
            {
                break;
            }
            NSLog(@"<<< %d >文件:%@",i,filePathIZip);
            
            DHBSDKYuloreZipArchive * zip=[[DHBSDKYuloreZipArchive alloc] init];
            [zip UnzipOpenFile:filePathIZip Password:APISIG];
            [zip UnzipFileTo:filePath overWrite:YES];
            [zip UnzipCloseFile];
            
            NSMutableDictionary *contentDict = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathI];
            
            count += [[contentDict allKeys] count];
            
            [[NSFileManager defaultManager] removeItemAtPath:filePathI error:nil];
            filePathIZip=nil;
        }
    }
    
    NSLog(@"记录总数:%zd",count);
}


/**
 在线标记
 */
- (void)onlineMark {
    [DHBSDKApiManager markTeleNumberOnlineWithNumber:@"4000618800" flagInfomation:@"电话邦" completionHandler:^(BOOL successed, NSError *error) {
        NSLog(@"标记号码:%zd  error:%@",successed,error);
    }];
}


/**
 在线识别
 */
- (void)onlineRecognize {
    [DHBSDKApiManager searchTeleNumber:@"4000618800" completionHandler:^(DHBSDKResolveItemNew *resolveItem, NSError *error) {
        NSLog(@"%@",resolveItem);
        NSLog(@"error:%@",error);
    }];
}

-(void)isneedUpdataPackage:(void(^)(BOOL isNeed))isNeed
{
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:extensionIdentf completionHandler:^(CXCallDirectoryEnabledStatus status,NSError *error)
     {
         if(status==CXCallDirectoryEnabledStatusEnabled){
             NSLog(@"已授权");
             
             [[DHBSDKApiManager shareManager] setDownloadNetworkType:DHBSDKDownloadNetworkTypeAllAllow];
             [DHBSDKApiManager dataInfoFetcherMultiCompletionHandler:^(NSMutableArray<DHBSDKUpdateItem *> *updateItems, NSError *error) {
                 
                 NSInteger Downloadtotalsize = [self getAllPackageSizeWiht:updateItems];
                 
                 BOOL needUpdata;
                 if (Downloadtotalsize>0)
                 {
                     needUpdata = YES;
                 }
                 else
                 {
                     needUpdata = NO;
                 }
                 if (isNeed) {
                     if ([NSThread isMainThread]) {
                         isNeed(needUpdata);
                     }
                     else
                     {
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             isNeed(needUpdata);
                         });
                     }
                     
                     
                 }
                 
             }];
         }
         else {
             NSLog(@"未开启来电识别");
             if (isNeed) {
                 if ([NSThread mainThread]) {
                     isNeed(YES);
                 }
                 else
                 {
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         isNeed(YES);
                     });
                 }
                 
                 
             }
         }
     }];
}
-(NSInteger)getAllPackageSizeWiht:(NSMutableArray<DHBSDKUpdateItem *> *)updateItems
{
    NSInteger packagesize = 0;
    
    NSDictionary * localVersionInfo = [self getVersionInfo];
    
    for (DHBSDKUpdateItem * item in updateItems) {
        
        HB_PackageVersionModel * model = [localVersionInfo objectForKey:[self packageTypeToString:item.packageType]];
        if (!model) {
            packagesize += item.fullSize;
        }
        else if (item.deltaVersion == model.deltaVersion &&item.deltaVersion>0)
        {
            //必要
        }
        else if (item.fullVersion == model.fullVersion &&item.fullVersion>0)
        {
            //必要
        }
        else if (item.deltaSize)
        {
            packagesize += item.deltaSize;
        }
        else if (item.fullSize)
        {
            packagesize +=item.fullSize;
        }
        
    }
    
    return packagesize;
}

-(NSString *)packageTypeToString:(DHBSDKPackageType)type
{
    NSString * str = nil;
    switch (type) {
        case DHBSDKPackageTypeUndefined:
        {
            str = [NSString stringWithFormat:@"DHBSDKPackageTypeUndefined"];
        }
            break;
            
        case DHBSDKPackageTypeFlag:
        {
            str = [NSString stringWithFormat:@"DHBSDKPackageTypeFlag"];
        }
            break;
        case DHBSDKPackageTypeBkwd:
        {
            str = [NSString stringWithFormat:@"DHBSDKPackageTypeBkwd"];
        }
            break;
        default:
            break;
    }
    return str;
}
-(NSMutableDictionary *)getVersionInfo
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPackageInfo"];
    
    NSMutableDictionary * localversion = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return localversion;
}
-(void)saveVersionInfo:(NSDictionary *)newVersion
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:newVersion];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"localPackageInfo"];
}
@end
