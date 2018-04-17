//
//  HB_UnlimitedBackUpReq.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/8/19.
//
//

#import "HB_UnlimitedBackUpReq.h"

#import "AddGetMemberinfoProto.pb.h"


@implementation HB_UnlimitedBackUpReq



+(void)MemberInfoRequestType:(NSInteger)reqtype resultBlock:(void(^)(NSError * __nullable error,NSInteger resultCode,NSString * startdate))GetmenberResult
{
    
    //待验证信息
    AddGetMemberInfoRequest_Builder * builder = [AddGetMemberInfoRequest builder];
    NSString * userid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] stringValue];
    [builder setUserid:userid];
    [builder setReqtype:[NSString stringWithFormat:@"%ld",reqtype]];//reqtype 1 验证是否是会员
    
    AddGetMemberInfoRequest * infoReq = [builder build];
    
    NSData * data1 = [infoReq data];
    
    NSURL * url = [NSURL URLWithString:[[ConfigMgr getInstance] getValueForKey:@"addGetMemberinfoUrlUrl" forDomain:nil]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:VersionClient forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"application/x-protobuf" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15.0];
    [request setHTTPBody:data1];
    
//    __block AddGetMemberInfoResponse *MenberInfoResponse;
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AddGetMemberInfoResponse *MenberInfoResponse;
            if (!error) {
                @try {
                    MenberInfoResponse = [AddGetMemberInfoResponse parseFromData:data];
                } @catch (NSException *exception) {
//                    if (GetmenberResult) {
//                        GetmenberResult(error,2,nil);
//                    }
                    NSLog(@"解析失败");
                    return ;
                } @finally {
                    
                    if (GetmenberResult) {
                        GetmenberResult(nil,MenberInfoResponse.resultCode,MenberInfoResponse.startdate);
                    }
                }
            }
            else
            {
                if (GetmenberResult) {
                    GetmenberResult(error,MenberInfoResponse.resultCode,nil);
                }
            }
        });
    }];
    [dataTask resume];
}

@end
