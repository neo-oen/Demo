//
//  FetchRecommendAppListRequest.h
//  HBZS_IOS
//
//  Created by zimbean on 14-8-7.
//
//

#import <Foundation/Foundation.h>

typedef void (^FetchAppListSuccessBlock) (NSMutableArray *);
typedef void (^FetchAppListFailedBlock) (int, NSError *);

@interface FetchRecommendAppListRequest : NSObject{
    
}

@property (nonatomic, retain)NSString *urlString;
@property (nonatomic, retain)NSDictionary *params;

- (id)initWithUrlString:(NSString *)urlstring
                 params:(NSMutableDictionary *)dict;

- (void)requestDidFinsh:(FetchAppListSuccessBlock)success failed:(FetchAppListFailedBlock)failed;

@end
