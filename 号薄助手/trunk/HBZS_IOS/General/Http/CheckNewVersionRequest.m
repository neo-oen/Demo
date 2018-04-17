//
//  CheckNewVersionRequest.m
//  HBZS_IOS
//
//  Created by zimbean on 14-7-18.
//
//

#import "CheckNewVersionRequest.h"

@implementation CheckNewVersionRequest

+ (void)requestDidFinsh:(CheckNewVersionResponseBlock)responseBlock{
    NSMutableString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger currentVersionNum= [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    
    NSString *urlString = @"http://itunes.apple.com/lookup?id=499531986";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:5.0f];
    
//    NSOperationQueue *globalQueue = [[NSOperationQueue alloc]init];
    NSOperationQueue *Queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:Queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        
        if (!error) {
            if (data) {
                NSDictionary *result = nil;
                @try {
                    result = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
                }
                @catch (NSException *exception) {
                    responseBlock(NO);
                    return;
                }
                @finally {
                    NSArray *results = [result objectForKey:@"results"];
                    if (results.count > 0) {
                        NSDictionary *dict = [results objectAtIndex:0];
                        NSMutableString *newVersion = [dict objectForKey:@"version"];
                        
                        NSInteger newVersionNum = [[newVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
                        
                        if (newVersionNum > currentVersionNum) {
                            responseBlock(YES);
                            return;
                        }
                        else{
                            responseBlock(NO);
                            return;
                        }
                    }
                    
                    responseBlock(NO);
                }
            }
        }
        else{
            responseBlock(NO);
        }
    }];
}

@end
