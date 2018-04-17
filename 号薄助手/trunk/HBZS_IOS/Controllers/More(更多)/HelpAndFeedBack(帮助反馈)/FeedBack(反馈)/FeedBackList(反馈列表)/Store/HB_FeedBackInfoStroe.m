//
//  HB_FeedBackInfoStroe.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/5.
//
//

#import "HB_FeedBackInfoStroe.h"
#import "HB_FeedBackInfoModel.h"
#import "Public.h"

@implementation HB_FeedBackInfoStroe
/**
 *  快速返回一个HB_FeedBackInfoModel模型数组
 */
+(NSArray *)feedBackInfoStoreModelArr{
    HB_FeedBackInfoStroe *store=[[HB_FeedBackInfoStroe alloc]init];
    NSArray * arr=[NSArray arrayWithArray:[store getFeedBackInfoModelArr]];
    [store release];
    return arr;
}
/**
 *  获得HB_FeedBackInfoModel模型数组
 */
-(NSArray *)getFeedBackInfoModelArr{
    NSMutableArray * mutableArr=[[[NSMutableArray alloc]init] autorelease];
    
    NSString *hostUrlStr = @"http://10000club.189.cn:80/service/queryByPhone.php?";
    NSString *curTime = [Public getCurrentTimeStr];
    NSString* phoneStr = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];
    NSString *urlStr = [NSString stringWithFormat:
                        @"%@app_version=IPhone_1.0.0&client_imei=%@&client_mdn=%@&sig=%@&time=%@&application_id=15&page_count=%d&page=%d",
                        hostUrlStr,[Public getDeviceID],phoneStr,[Public getSigStr:curTime],curTime,100,1];
    
    NSURL * url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    NSURLSession * session=[NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        NSLog(@"data=%@,error=%@,response=%@",data,error,response);
        if (data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
        }
    }];

    [dataTask resume];

    
/**********先构造假数据************/
    for (int i=0; i<4; i++) {
        HB_FeedBackInfoModel * model=[[HB_FeedBackInfoModel alloc]init];
        model.feedBackContent=@"没有一点问题啊没有一点问题啊没有一点问题啊";
        model.time=@"2016-12-12  23:23";
        model.replayStatus=@"已答复";
        [mutableArr addObject:model];
        [model release];
    }
    
/**********************/

    
    return mutableArr;
}
#pragma mark - 网络请求
-(void)connect{

    
}


@end
