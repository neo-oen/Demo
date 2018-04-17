//
//  VersionCheck.m
//  Path2DemoPrj
//
//  Created by yingxin on 12-5-9.
//  Copyright (c) 2012年 Ethan. All rights reserved.
//

#import "VersionCheck.h"


@implementation VersionCheck

VersionCheck* instance = nil;

+ (VersionCheck*)getInstance{
  if (instance == nil) {
    instance = [[VersionCheck alloc] init];
  }
    
  return instance;
}

+ (void)releaseInstance{
  if (instance) {
    [instance release];
      
    instance=nil;
  }
}

- (void)dealloc{
    [super dealloc];
}

- (void)checkVersion{
//  checkTime = [NSTimer scheduledTimerWithTimeInterval: 4.0
//                                               target: self
//                                             selector: @selector(postRequest)
//                                             userInfo: nil
//                                              repeats: NO];
    
    [self postRequest];
}

- (void)postRequest{
    
//    if ([checkTime isValid]) {
//        [checkTime invalidate];
//    }
    
    NSURL *url = [NSURL URLWithString:@"http://pim.189.cn/queryclientversion.aspx"];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    
    [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest setHTTPMethod:@"POST"];
    
    theConnection= [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
}

- (void)allocAlertview:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"以后再说"
                                          otherButtonTitles:@"立即升级", nil];
    [alert show];
    
    [alert release];
}

- (void)catchedTheNewVersionNum:(NSString*)verNew{
  
  NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
  if ([verNew compare:version] == NSOrderedDescending) {
    
    NSString *message = [NSString stringWithFormat:@"发现可以更新的版本%@,马上升级体验？",verNew];
      
    [self allocAlertview:message];    
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    
  }
  else if(buttonIndex == 1){
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
      
    NSString *strUrl = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", 499531986];
    
    NSURL *url = [NSURL URLWithString:strUrl];
      
    [[UIApplication sharedApplication] openURL:url];
  }
    
  [VersionCheck releaseInstance];
}

//接受到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
       [webData appendData:data];
}

//没有接受到数据
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
  
  webData=[[NSMutableData data]retain];
    
  [webData setLength:0];
}

//
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
  [connection release];
  [webData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
  
  NSString * str = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];

  if (str == nil || str.length < 1/*||str.length>6*/)
  {
    [connection release];
   
    [str release];
      
    [webData release];
      
    return;
  }
  
  [self catchedTheNewVersionNum:str];
    
  [connection release];
    
  [str release];
    NSLog(@"Version...");
  [webData release];
}

@end
