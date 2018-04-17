//
//  HB_httpRequestNew.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/8.
//
//

#import "HB_httpRequestNew.h"
#import "MemAddressBook.h"
#import "IsopenMycardShareProto.pb.h"
#import "CuMycardShareProto.pb.h"
#import "Public.h"
#import "AuthProto.pb.h"
#import "SettingInfo.h"
#import "HB_SystemSettingVC.h"
#import "UploadPortraitProto.pb.h"
#import "OrderMemberProto.pb.h"
#import "HB_OrderMemberModel.h"
#import "ContactMycardProto.pb.h"
#import "SyncPortraitProto.pb.h"
#import "PayInAppManager.h"
#import "SVProgressHUD.h"
#import "HB_cardsDealtool.h"
#import "ContactProtoToContactModel.h"
#import "ASIHTTPRequest.h"
#import "CuMycardCountProto.pb.h"
@implementation HB_httpRequestNew
-(void)dealloc
{
//    [_currentask release];
    [super dealloc];
    
}

+(NSMutableURLRequest*)getRequestString:(NSString *)urlString
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request addValue:VersionClient forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld",[user objectForKey:@"Authtoken"] ,[[user objectForKey:@"userID"] longLongValue]];
    
    [request addValue:cookie forHTTPHeaderField:@"Cookie" ];
    return request;
}



-(void)isOpenMyCardShareWithId:(int32_t)cardid Result:(void (^)(BOOL, NSInteger))resultBlock
{
    [self Auth:^(BOOL isAuthSuccess) {
      
        if (!isAuthSuccess) {
            resultBlock(NO,9);
            return ;
        }
        IsOpenMycardShareRequest_Builder * build = [IsOpenMycardShareRequest builder];
        NSString * userid =[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] stringValue];
        [build setUserid: userid];
        [build setCardSid:cardid];
        NSData * Reqdata = [[build build] data];
        
        NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[[ConfigMgr getInstance] getValueForKey:@"isopenMycardUrl" forDomain:nil]];
        [request setHTTPBody:Reqdata];
        
        
        __block BOOL isSuccess = NO;
        NSURLSession * session = [NSURLSession sharedSession];
       self.currentask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
           IsOpenMycardShareResponse * isOpenResponse;
            if (httpResponse.statusCode == 200&&!error) {
                @try
                {
                    isOpenResponse = [IsOpenMycardShareResponse parseFromData:data];
                }
                @catch (NSException *exception) {
                    NSLog(@"解析失败");
                    return ;
                }
                @finally
                {
                    
                    
                }
                isSuccess = YES;
                
                //保存url地址
                if (isOpenResponse.cardSidShareUrl.length) {
                    [HB_cardsDealtool saveCloudCardUrl:isOpenResponse.cardSidShareUrl andSid:cardid];
                }
            }
            
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(isSuccess,isOpenResponse.isopenMycard);
                    
                });
                
                
            }
            
           
        }];
        
        [self.currentask resume];
    }];
    
}

-(NSDictionary *)SyncisOpenMyCardwithid:(int32_t)CardId
{
    NSURL * url = [NSURL URLWithString:[SettingInfo getConfigUrl].isopenMycardUrl];
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    
    IsOpenMycardShareRequest_Builder * builder = [IsOpenMycardShareRequest builder];
    NSString * userid =[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] stringValue];
//    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"];
    [builder setUserid:userid];
    [builder setCardSid:CardId];
    IsOpenMycardShareRequest * build = [builder build];
    NSData * Reqdata = [build data];
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld",[user objectForKey:@"Authtoken"] ,[[user objectForKey:@"userID"] longLongValue]];
    
    [request setRequestMethod:@"POST"];
    [request setUseCookiePersistence:NO];//关闭共享，这里不关闭这个属性服务器会返回401；
    [request addRequestHeader:@"User-Agent" value:VersionClient];
    [request addRequestHeader:@"Content-Type" value:@"application/x-protobuf"];
    [request addRequestHeader:@"Cookie" value:cookie];
    
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu",(unsigned long)Reqdata.length]];
    [request setPostBody:[NSMutableData dataWithData:Reqdata]];
    
    [request startSynchronous];
    
    
    NSMutableDictionary * resultdic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (![request error]) {
        IsOpenMycardShareResponse * isOpenResponse;
        if (request.responseStatusCode == 200) {
            @try
            {
                isOpenResponse = [IsOpenMycardShareResponse parseFromData:request.responseData];
            }
            @catch (NSException *exception) {
                NSLog(@"解析失败");
                [resultdic setObject:@"解析失败" forKey:@"error"];
                return resultdic;
            }
            @finally
            {
                
                
            }
            [resultdic setObject:[NSNumber numberWithInt:isOpenResponse.isopenMycard] forKey:@"isOpeng"];
            if (isOpenResponse.isopenMycard && isOpenResponse.cardSidShareUrl.length) {
                [resultdic setObject:isOpenResponse.cardSidShareUrl forKey:@"cardUrl"];
            }
            
        }
        else
        {
            NSLog(@"请求失败：code:%d",request.responseStatusCode);
            [resultdic setObject:[NSString stringWithFormat:@"请求失败：code:%d",request.responseStatusCode] forKey:@"error"];
        }
    }
    else
    {
        NSLog(@"请求出错");
        [resultdic setObject:@"请求出错" forKey:@"error"];
    }
    
    return resultdic;
    
}

-(void)UpdateMyCardWithType:(NSInteger)type andContact:(Contact *)cardcontact Result:(void (^)(BOOL, int32_t, NSInteger, NSInteger, NSString *))resultBlock
{
    
    // type (0,create ;1,update ; 2,cancel)
    CuMycardShareRequest_Builder * builder = [CuMycardShareRequest builder];
    
    [builder setBusinessCard:cardcontact];
    
    NSString * typeString = [NSString stringWithFormat:@"%lu",(long)type];
    
    [builder setOptype:typeString];
    
    NSData * reqdata = [[builder build] data];
    
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[[ConfigMgr getInstance] getValueForKey:@"addupdateMycardUrl" forDomain:nil]];
    
    [request setHTTPBody:reqdata];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
//    __block CuMycardShareResponse * shareResponse;
    __block BOOL isSuccess = NO;
    self.currentask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        CuMycardShareResponse * shareResponse;
        if (!error &&httpResponse.statusCode == 200) {
            @try
            {
                shareResponse  = [CuMycardShareResponse parseFromData:data];
            }
            @catch (NSException *exception) {
                NSLog(@"解析失败");
                return ;
            }
            @finally
            {
                
                
            }
            
            [[MemAddressBook getInstance] updMyCardVersion:shareResponse.businessCardVersion];
            
//            [[MemAddressBook getInstance] commit];
            
            isSuccess =YES;
            
            
            if (type ==2) {
                if (resultBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        resultBlock(isSuccess,shareResponse.cardSid,shareResponse.resultcode,shareResponse.recCode,nil);
                    });
                    
                }
            }
            else
            {
                if (shareResponse.shareUrl.length) {
                    //保存云名片地址
//                    [SettingInfo saveCardShareUrl:shareResponse.shareUrl];
                    
                }
                
                
                if (resultBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        resultBlock(isSuccess,shareResponse.cardSid,shareResponse.resultcode,shareResponse.recCode,shareResponse.shareUrl);
                    });
                    
                }
                
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                resultBlock(isSuccess,0,0,-1,nil);
            });
        }
    
    }];
    [self.currentask resume];
}

-(int)SyncUplodaCardMycardWithType:(NSInteger)type andContact:(Contact *)cardcontact
{
    // type (0,create ;1,update ; 2,cancel)
    CuMycardShareRequest_Builder * builder = [CuMycardShareRequest builder];
    
    [builder setBusinessCard:cardcontact];
    
    NSString * typeString = [NSString stringWithFormat:@"%lu",(long)type];
    
    [builder setOptype:typeString];
    
    NSData * reqdata = [[builder build] data];
    
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[[ConfigMgr getInstance] getValueForKey:@"addupdateMycardUrl" forDomain:nil]];
    
    [request setHTTPBody:reqdata];
    NSURLResponse * response = nil;
    NSError * error;
    NSData * resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
    if (httpResponse.statusCode == 200 && !error) {
        CuMycardShareResponse * shareResponse = [CuMycardShareResponse parseFromData:resData];
        return shareResponse.cardSid;
        
    }
    return 0;
}

-(BOOL)upCardPortrait:(HB_ContactModel*)model
{
    
    UploadPortraitRequest_Builder * _uploadPortraitRequest_builder = [UploadPortraitRequest builder];
    
    /*上传数据序列化-----转成数组*/
    UploadMyPortraitData_Builder * updata_builder = [UploadMyPortraitData builder];
    [updata_builder setPortraitSid:model.cardid];
    [updata_builder setTimestamp:model.timestamp+2];
    
    PortraitData * pordata = [[[PortraitData builder] setImageData:model.iconData_original]build];
    
    [updata_builder setPortraitData:pordata];
    
    UploadMyPortraitData *  UpMyPordata = [updata_builder build];
    
    NSArray * arr = [NSArray arrayWithObject:UpMyPordata];
    /*------------------*/
    
    [_uploadPortraitRequest_builder addAllBusinessCardPortraits:arr];
    
    UploadPortraitRequest *_uploadPortraitRequest = [_uploadPortraitRequest_builder build];
    
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[SettingInfo getConfigUrl].uploadPortraitUrl];
    
    
    [request setHTTPBody:[_uploadPortraitRequest data]];
    
    UploadPortraitResponse * UploadPorResponse;
    NSURLResponse * urlResponse = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSHTTPURLResponse * httpResponse= (NSHTTPURLResponse *)urlResponse;
    
    if (httpResponse.statusCode == 200) {
        @try {
            UploadPorResponse  =  [UploadPortraitResponse parseFromData:data];
            
        } @catch (NSException *exception) {
            NSLog(@"解析失败");
            return NO;
            
        } @finally {
            
        }
        
        return YES;
    }
    
    return NO;

}


#pragma mark 头像同步
-(BOOL)syncMyCardPortrait
{
    SyncPortraitRequest_Builder *_syncPortraitRequest_builder = [SyncPortraitRequest builder];
    int32_t myPorVersion = [[MemAddressBook getInstance] myPortraitVersion];
    if (myPorVersion > 0){
        _syncPortraitRequest_builder = [_syncPortraitRequest_builder setBusinessCardPortraitVersion:myPorVersion];
    }
    SyncPortraitRequest *_syncPortraitRequest = [_syncPortraitRequest_builder build];
    
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[SettingInfo getConfigUrl].syncPortraitUrl];
    
    [request setHTTPBody:[_syncPortraitRequest data]];
    
    SyncPortraitResponse * syncPorResponse;
    NSURLResponse * urlResponse = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSHTTPURLResponse * httpResponse= (NSHTTPURLResponse *)urlResponse;
    
    if (httpResponse.statusCode == 200) {
        @try {
            syncPorResponse  =  [SyncPortraitResponse parseFromData:data];
            
        } @catch (NSException *exception) {
            NSLog(@"解析失败");
            return NO;
            
        } @finally {
            
        }
        
        BOOL downLoadPorSuccess = NO;
        if (syncPorResponse.isNeedToDownloadBusinessCardPortrait) {
            downLoadPorSuccess = [self downProdata:syncPorResponse.isNeedToDownloadBusinessCardPortrait];
        }
        else
        {
            downLoadPorSuccess = YES;
        }
        
        
        return downLoadPorSuccess;
    }
    
    return NO;
}

-(BOOL)downProdata:(BOOL)isneed
{
    DownloadPortraitRequest_Builder *_downloadPortraitRequest_builder = [DownloadPortraitRequest builder];
    
//    [_downloadPortraitRequest_builder setIsRequestBusinessCardPortrait:isneed];
    [_downloadPortraitRequest_builder setIsRequestMoreBussinessPortrait:YES];
    DownloadPortraitRequest * downLoadPorReq = [_downloadPortraitRequest_builder build];
    
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[SettingInfo getConfigUrl].downloadPortraitUrl];
    
    [request setHTTPBody:[downLoadPorReq data]];
    
    
    NSURLResponse * urlResponse = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSHTTPURLResponse * httpResponse= (NSHTTPURLResponse *)urlResponse;
    
    
    DownloadPortraitResponse * downloadPorResponse;
    if (httpResponse.statusCode == 200) {
        @try {
            downloadPorResponse  =  [DownloadPortraitResponse parseFromData:data];
            
        } @catch (NSException *exception) {
            NSLog(@"解析失败");
            return NO;
            
        } @finally {
            
        }
        
        
        NSArray * cardPorArr = downloadPorResponse.businessCardPortraitsList;
        
        [HB_cardsDealtool saveCardPortraitsWith:cardPorArr];
        
        return YES;
    }
    return NO;
    
}




-(void)Auth:(void(^)(BOOL isAuthSuccess))next
{
    NSString *account_key;
    
    NSString *password_key;
    
    account_key = [NSString stringWithFormat:@"user_name"];
        
    password_key = [NSString stringWithFormat:@"user_psw"];
    
    NSString *account = [[ConfigMgr getInstance] getValueForKey:account_key forDomain:nil];    // 从配置文件读取帐号名密码
    
    NSString *password = [[ConfigMgr getInstance] getValueForKey:password_key forDomain:nil];
    
    if (account.length==0 ||password.length == 0) {
        
        return;
    }
    
    
    NSString *seAccount = [[account SimpleEncryptByOffset:3 bySalt:11] base64];        //加密账号
    
    NSString *snAccount = [[seAccount SimpleEncryptByOffset:4 bySalt:9] md5];           // 对加密后的账号进行签名
    
    NSString *sePassword = [[password SimpleEncryptByOffset:3 bySalt:11] base64];     //加密密码
    // 目前只采用天翼账号认证：AuthMethodCtpassport
    AuthRequest *_authReuest =[[[[[[AuthRequest builder]
                                   setMethod:AuthMethodCtpassport]
                                  setAccount:seAccount]
                                 setPassword:sePassword]
                                setVerifySign:snAccount]
                               build];
    
    NSData *requestData = [_authReuest data];
    
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]];
    
    NSURL * url = [NSURL URLWithString:[[ConfigMgr getInstance] getValueForKey:@"authUrl" forDomain:nil]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:VersionClient forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:requestData];
    [request addValue:length forHTTPHeaderField:@"Content-Length"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    __block AuthResponse * auResponse;
    __block BOOL isSuccess = NO;
    self.currentask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode == 200) {
            @try
            {
                auResponse = [AuthResponse parseFromData:data];
            }
            @catch (NSException *exception) {
                NSLog(@"解析失败");
                return ;
            }
            @finally
            {
                
            }
            isSuccess = YES;
            NSUserDefaults * userManger = [NSUserDefaults standardUserDefaults];
            [userManger setObject:[NSNumber numberWithLongLong:auResponse.syncUserId] forKey:@"userID"];
            [userManger setObject:auResponse.token forKey:@"Authtoken"];
            [userManger setObject:auResponse.pUserId forKey:@"pUserId"];
            [userManger setObject:auResponse.mobileNum forKey:@"mobileNum"];
            [userManger synchronize];
            
            
        }
        else if (httpResponse.statusCode == 401) {
            //密码有改动 退出当前登录
            [HB_SystemSettingVC accountLogout];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录信息已失效，请重新登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [al show];
                [al release];
            });
            
        }
        else
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证失败，请稍后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [al show];
//                [al release];
//            });
        }
        
        if (next) {
            dispatch_async(dispatch_get_main_queue(), ^{
                next(isSuccess);
            });
            
        }
    }];
    
    [self.currentask resume];
}

-(void)getMemberInfoResult:(void (^)(BOOL, MemberInfoResponse *))resultBlock
{
    
    [self Auth:^(BOOL isAuthSuccess) {
        if (!isAuthSuccess) {
            resultBlock(NO,nil);
            return ;
        }
        MemberInfoRequest_Builder * builder = [MemberInfoRequest builder];
        NSString * userid =[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] stringValue];
        [builder setUserId:userid];
        
        NSData * reqdata = [[builder build] data];
        
        NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[[ConfigMgr getInstance] getValueForKey:@"getMemberInfoUrl" forDomain:nil]];
        [request setHTTPBody:reqdata];
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        __block BOOL isSuccess = NO;
        self.currentask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
            MemberInfoResponse * memberinfo;

            if (!error &&httpResponse.statusCode == 200) {
                @try
                {
                    memberinfo  = [MemberInfoResponse parseFromData:data];
                }
                @catch (NSException *exception) {
                    NSLog(@"解析失败");
                    return ;
                }
                @finally
                {
                    
                    
                }
               
                
                isSuccess =YES;
                [SettingInfo saveMemberInfo:[memberinfo data]];
                
                
            }
            
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    resultBlock(isSuccess,memberinfo);
                });
                
            }
            
        }];
        [self.currentask resume];

        
        
        
    }];
}

-(void)getMemberModelResult:(void (^)(BOOL, NSDictionary *))resultBlock
{
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[[ConfigMgr getInstance] getValueForKey:@"getMemberModuleUrl" forDomain:nil]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    __block BOOL isSuccess = NO;
    
    self.currentask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary * dic=nil;
        NSLog(@"-------%@",httpResponse);
        if (!error &&httpResponse.statusCode == 200) {
            @try
            {
                
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
            }
            @catch (NSException *exception) {
                NSLog(@"解析失败");
                return ;
            }
            @finally
            {
                
                
            }
            
            if ([[dic objectForKey:@"code"] integerValue]==1) {
                isSuccess =YES;
            }
            
            
        }
        
        if (resultBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                resultBlock(isSuccess,dic);
            });
            
        }
        
    }];
    [self.currentask resume];
}

-(void)orderVipIsValidResult:(void(^)(BOOL isSuccess, NSDictionary * dic))resultBlock
{
    NSString * urlstring = [SettingInfo getConfigUrl].getMemberStatusEnabledUrl;
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:urlstring];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    __block BOOL isSuccess = NO;
    
    self.currentask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary * dic=nil;
        NSLog(@"-------%@",httpResponse);
        if (!error &&httpResponse.statusCode == 200) {
            @try
            {
                
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
            }
            @catch (NSException *exception) {
                NSLog(@"解析失败");
                return ;
            }
            @finally
            {
                
                
            }
            
            if ([[dic objectForKey:@"code"] integerValue]==0 ||[[dic objectForKey:@"code"] integerValue]==-1) {
                isSuccess =YES;
            }
            
            
        }
        
        if (resultBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                resultBlock(isSuccess,dic);
            });
            
        }
        
    }];
    [self.currentask resume];
}

-(void)OrderMemberWithOrderInfo:(HB_OrderMemberModel *)model Result:(void (^)(BOOL, MemberOrderResponse *))resultBlock
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [SettingInfo getMemberInfo];
    
    PayOrder_Builder * payOrder_builder = [PayOrder builder];
    
    //固定值
    [payOrder_builder setAppId:Open189_appId];
    [payOrder_builder setState:Open189_State];
    [payOrder_builder setPayCode:Open189_PayCode];
    [payOrder_builder setPhone:[defaults objectForKey:@"mobileNum"]];
    //传入值
    [payOrder_builder setOrderNo:model.order_no];
    [payOrder_builder setPrice:model.price];
    
    PayOrder * payorder = [payOrder_builder build];
    
    
    
    MemberOrderRequest_Builder * MORequest_builder = [MemberOrderRequest builder];
    [MORequest_builder setPayOrder:payorder];
    [MORequest_builder setUserid:[[defaults objectForKey:@"userID"] intValue]];
    [MORequest_builder setPuserid:[defaults objectForKey:@"pUserId"]];
    [MORequest_builder setLevel:model.memberLevel];
    [MORequest_builder setType:model.memberType];
    
    MemberOrderRequest * MORequest = [MORequest_builder build];
    
    
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[SettingInfo getConfigUrl].subscribeUrl];
    
    [request setHTTPBody:[MORequest data]];
    NSURLSession * session = [NSURLSession sharedSession];
    
    
    __block BOOL isSuccess = NO;
    self.currentask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        MemberOrderResponse * MOResponse = nil;
        if (!error &&httpResponse.statusCode == 200) {
            @try
            {
                MOResponse = [MemberOrderResponse parseFromData:data];
            }
            @catch (NSException *exception) {
                NSLog(@"解析失败");
                return ;
            }
            @finally
            {
                
                
            }
            
            if (MOResponse.resCode == 0) {
                isSuccess = YES;

            }
            
        }
        
        if (resultBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                resultBlock(isSuccess,MOResponse);
                
            });
            
        }
        
    }];
    [self.currentask resume];
    
    
    
}


#pragma mark 获取名片
-(void)getMyCardformServerResult:(void (^)(BOOL))resultBlock
{
    ContactMyCardRequest_Builder * builder = [ContactMyCardRequest builder];
    
    [builder addUserId:[[self userid] intValue]];
    [builder setIsMoreCard:YES];
    ContactMyCardRequest * CardReq = [builder build];

    
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[SettingInfo getConfigUrl].getContactMycardUrl];
    [request setHTTPBody:[CardReq data]];
    
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    __block BOOL isSuccess = NO;
    self.currentask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        ContactMyCardResponse * CardResponse;
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        if (!error &&httpResponse.statusCode == 200) {
            @try
            {
                CardResponse = [ContactMyCardResponse parseFromData:data];
                
            }
            @catch (NSException *exception) {
                NSLog(@"解析失败");
                return ;
            }
            @finally
            {
                
            }
            
//            [[MemAddressBook getInstance] updMyCard:CardResponse.businessCard];
            
            NSArray * CardContactarr = CardResponse.businessCardsList;
            
            NSMutableArray * cardmodelarr = [NSMutableArray arrayWithCapacity:0];
            for (Contact * cardcontact in CardContactarr) {
                [cardmodelarr addObject:[[ContactProtoToContactModel shareManager] memMycardToContactModel:cardcontact]];
            }
            
            [HB_cardsDealtool saveCardsdataWithArr:cardmodelarr];
//            isSuccess = [self syncMyCardPortrait];
            isSuccess  = [self downProdata:YES];
            
            
        }
        
        if (resultBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(isSuccess);
            });
            
        }
    }];
    [self.currentask resume];

}

//名片count
-(void)getCardCountFormServerResult:(void (^)(BOOL, NSInteger))resultBlock
{
    CuMycardCountRequest * CountReq = [[CuMycardCountRequest builder] build];
    
    NSMutableURLRequest * request = [HB_httpRequestNew getRequestString:[SettingInfo getConfigUrl].getCuMycardCountUrl];
    [request setHTTPBody:[CountReq data]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    __block BOOL isSuccess = NO;
    
    self.currentask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        CuMycardCountResponse * countResponse;
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        if (!error &&httpResponse.statusCode == 200) {
            @try
            {
                countResponse = [CuMycardCountResponse parseFromData:data];
                
            }
            @catch (NSException *exception) {
                NSLog(@"解析失败");
                return ;
            }
            @finally
            {
                
            }
            
            isSuccess =YES;
        }
        
        if (resultBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(isSuccess,countResponse.cardCount);
            });
            
        }
    }];
    
    [self.currentask resume];
}

-(id)userid
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"userID"];
}

-(void)stopcurrentRequest
{
    [self.currentask cancel];
}


+(void)buyMemberWithVc:(UIViewController *)object
{
    NSString * phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"];
    
    NSArray * arr = @[@"133",@"153",@"177",@"180",@"181",@"189",@"173",];
    
    NSString * phoneTypString = nil;
    if (phoneNum.length>3) {
        phoneTypString  = [phoneNum substringToIndex:3];
    }
    
    if (![arr containsObject:phoneTypString]) {
        UIAlertView * al= [[UIAlertView alloc] initWithTitle:@"提示" message:@"本服务暂时仅支持中国电信用户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
        [al release];
        return;
    }
    [PayInAppManager basicValueByAppId:Open189_appId andPayCode:Open189_PayCode andPhoneNum:phoneNum andState:Open189_State andAppSecret:Open189_Secret object:object];
}

+(void)PayBackInfo:(NSString *)code
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:@"服务异常" forKey:@"1"];
    [dic setObject:@"非电信用户" forKey:@"203"];
    [dic setObject:@"计费失败" forKey:@"301"];
    [dic setObject:@"计费失败,服务异常" forKey:@"302"];
    
    
    NSString * error = code;
    
    [SVProgressHUD showErrorWithStatus:error];
    
    
}

@end
