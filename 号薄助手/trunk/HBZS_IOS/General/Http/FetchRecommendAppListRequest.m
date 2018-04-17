//
//  FetchRecommendAppListRequest.m
//  HBZS_IOS
//
//  Created by zimbean on 14-8-7.
//
//

#import "FetchRecommendAppListRequest.h"
#import "NSObject+SBJSON.h"
#import "RecommendAppInfo.h"

@implementation FetchRecommendAppListRequest

@synthesize urlString;
@synthesize params;

- (id)initWithUrlString:(NSString *)urlstring
                 params:(NSMutableDictionary *)dict{
    self = [super init];
    if (self) {
        self.urlString = urlstring;
        self.params = dict;
    }
    
    return self;
}

- (void)requestDidFinsh:(FetchAppListSuccessBlock)success failed:(FetchAppListFailedBlock)failed{
    
    NSString *jsonString = [params JSONRepresentation];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
     [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:jsonData];

    __block NSOperationQueue *fetchAppListQueue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:fetchAppListQueue
                           completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                               
        NSError *jsonError = nil;
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
                               
        
        if (responseData == nil) {
        
            failed(httpURLResponse.statusCode, error);
            
            return;
        }
                               
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:&jsonError];
                               NSArray *apps = [responseDict objectForKey:@"apps"];
                               NSMutableArray *recommendApps = [[NSMutableArray alloc]init];
                             
                               @try {
                                   for (NSDictionary *appDict in apps) {
                                       RecommendAppInfo *appInfo = [[RecommendAppInfo alloc]init];
                                       appInfo.appName = [appDict objectForKey:@"appName"];
                                       appInfo.appVendor = [appDict objectForKey:@"company"];
                                       appInfo.appDescription = [appDict objectForKey:@"description"];
                                       appInfo.starRate = [[appDict objectForKey:@"star"] intValue];
                                       appInfo.appIconUrl = [appDict objectForKey:@"logoPicture"];
                                       appInfo.topPictureUrl = [appDict objectForKey:@"topPicture"];
                                       NSDictionary *installDict = [appDict objectForKey:@"installInfo"];
                                       int packetByteSize = [[installDict objectForKey:@"length"] intValue];
                                       appInfo.packetSize = packetByteSize/1000.0;
                                       
                                       appInfo.downloadUrl = [installDict objectForKey:@"url"];
                                       NSArray *thumailImgs = [appDict objectForKey:@"thumbPicture"];
                                       for (int i = 0; i < thumailImgs.count; i++) {
                                           [appInfo.previewImgUrls addObject:[thumailImgs objectAtIndex:i]];
                                       }
                                       
                                       [recommendApps addObject:appInfo];
                                       [appInfo release];
                                   }
                               }
                               @catch (NSException *exception) {
                                 
                               }
                               @finally {
                                   [fetchAppListQueue release];
                                   
                                   success(recommendApps);
                               }
                               
                               
                           
    }];
}

@end
