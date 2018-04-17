//
//  HB_FeedBackDetailStore.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#import "HB_FeedBackDetailStore.h"
#import "HB_FeedBackDetailFrameModel.h"

@interface HB_FeedBackDetailStore ()<NSURLSessionDataDelegate>


@end

@implementation HB_FeedBackDetailStore

#pragma mark - life cycle
-(void)dealloc{
    
    
    [super dealloc];
}
#pragma mark - public methods
/**
 *  发送网络请求
 */
-(void)sendRequestAndResumeTask{
    NSString * urlStr=[NSString stringWithFormat:@"http://www.weather.com.cn/data/cityinfo/101020100.html"];
    NSURL * url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:1];
    request.HTTPMethod=@"GET";
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.networkServiceType=NSURLNetworkServiceTypeBackground;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}
#pragma mark - NSURLSessionDataTaskDelegate
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //解析数据，添加模型到数组
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //*****************************************假数据
    NSArray *tempArr=@[
                       @{
                           @"question":@"哈哈，做的太好了，感谢",
                           @"questionTime":@"2015-3-21  11:22",
                           @"answer":@"不客气",
                           @"answerTime":@"2015-8-21  22:22"
                           },
                       @{
                           @"question":@"问题内容问题内容问题内容问题内容问题内容问题内容问题内容问题内容",
                           @"questionTime":@"2015-3-21  11:22",
                           @"answer":@"回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复回复",
                           @"answerTime":@"2015-8-21  22:22"
                           },
                       @{
                           @"question":@"哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感哈哈，做的太好了，感",
                           @"questionTime":@"2015-3-21  11:22",
                           @"answer":@"不用问这么多吧？？？？？？",
                           @"answerTime":@"2015-8-21  22:22"
                           }
                       ];
    //***********************************************
    NSMutableArray * mutableArr=[[[NSMutableArray alloc]init] autorelease];
    for (int i=0; i<tempArr.count; i++) {
        HB_FeedBackDetailFrameModel *frameModel=[[HB_FeedBackDetailFrameModel alloc]init];
        HB_FeedBackDetailModel * model=[[HB_FeedBackDetailModel alloc]init];
        
        NSDictionary *tempDict=tempArr[i];
        [model setValuesForKeysWithDictionary:tempDict];
        
        frameModel.model=model;
        [mutableArr addObject:frameModel];
        [model release];
        [frameModel release];
    }
    NSLog(@"%@",dict);
    
    if ([self.delegate respondsToSelector:@selector(feedBackDetailStore:didFinishReceiveData:)]) {
        [self.delegate feedBackDetailStore:self didFinishReceiveData:mutableArr];
    }
}

@end
