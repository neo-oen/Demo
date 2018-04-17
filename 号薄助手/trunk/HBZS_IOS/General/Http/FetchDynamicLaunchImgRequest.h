//
//  FetchDynamicLaunchImg.h
//  HBZS_IOS
//
//  Created by zimbean on 14-7-17.
//
//

#import <Foundation/Foundation.h>

@interface FetchDynamicLaunchImgRequest : NSObject

+ (void)fetchLaunchImg;
+ (void)contactBgImage;

//获取launchImage存储路径
+(NSString *)LaunchImgPath;
@end
