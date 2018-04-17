//
//  HB_contactCloudReq.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/8/26.
//
//

#import "HB_contactCloudReq.h"
#import "SyncEngine.h"
#import "ContactShareProto.pb.h"
#import "HBZSAppDelegate.h"
#import "MemAddressBook.h"
#import "HB_httpRequestNew.h"
static HB_contactCloudReq * reqManager;
@implementation HB_contactCloudReq

+(HB_contactCloudReq*)shareManage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reqManager  = [[HB_contactCloudReq alloc] init];
        
    });
    return reqManager;
}
-(void)CloudShareByContactIds:(NSArray *)contactIdArr andResult:(void (^)(ContactShareResponse *, NSString *, NSInteger))resultBlock
{
    if (![SettingInfo getAccountState]) {
        resultBlock(nil,nil,reqResCode_NoAccount);
    }
    [[HBZSAppDelegate getAppdelegate] setSetViewInstance:self];
    StartSync(TASK_AUTHEN);
    self.contactIds = contactIdArr;
    self.ResBlock = resultBlock;
}

-(void)starUploadContacts
{
    //待验证信息
    
    ContactShareRequest_Builder * builder = [ContactShareRequest builder];
    
    [builder setUsername:[self getCloudShareName]];
    
    [builder addAllContact:[[MemAddressBook getInstance] getContactsByContactIds:self.contactIds]];
    
    ContactShareRequest * infoReq = [builder build];
    
    NSData * data1 = [infoReq data];
    
    NSString * urlstring = [[ConfigMgr getInstance] getValueForKey:@"conatctShareUrl" forDomain:nil];
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:urlstring];
    
    [request setHTTPBody:data1];
    
    __block ContactShareResponse * CSResponse;
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse * resp = (NSHTTPURLResponse*)response;

            if (resp.statusCode == 200) {
                @try
                {
                    CSResponse = [ContactShareResponse parseFromData:data];
                }
                @catch (NSException *exception) {
                    NSLog(@"解析失败");
                    self.ResBlock(nil,nil,reqResCode_faild);
                    self.ResBlock = nil;
                    return ;
                }
                if (self.ResBlock) {
                    self.ResBlock(CSResponse,[self getCloudShareName],reqResCode_suc);
                    self.ResBlock = nil;
                }
                
            }
            else
            {
                if (self.ResBlock) {
                    self.ResBlock(nil,nil,reqResCode_faild);
                    self.ResBlock = nil;
                }
            }
        });
    }];
    [dataTask resume];
}
-(NSString *)getCloudShareName
{
    Contact * MeContact = [[MemAddressBook getInstance] myCard];
    
    NSString * lastname = MeContact.name.familyName?MeContact.name.familyName:@"";
    NSString * firstname = MeContact.name.nickName?MeContact.name.nickName:@"";
    NSString * name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    if (!name.length) {
        name = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"];
    }
    
    return name;
    
}
+(NSString *)getCloudShareName
{
    Contact * MeContact = [[MemAddressBook getInstance] myCard];
    
    NSString * lastname = MeContact.name.familyName?MeContact.name.familyName:@"";
    NSString * firstname = MeContact.name.nickName?MeContact.name.nickName:@"";
    NSString * name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    if (!name.length) {
        name = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"];
    }
    
    return name;
    
}
- (void)loginStatus:(SyncState_t)state{
    
    switch (state) {
        case Sync_State_Success:
        {
            [self starUploadContacts];
            break;
        }
        case Sync_State_Faild:
        {
            if (self.ResBlock) {
                self.ResBlock(nil,nil,reqResCode_faild);
                self.ResBlock = nil;
            }
            break;
        }
        default:
            break;
    }
}



@end
