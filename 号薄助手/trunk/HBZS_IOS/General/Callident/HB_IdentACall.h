//
//  HB_IdentACall.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/12/7.
//
//

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>
#import "DHBSDK.h"
#import "DHBSDKYuloreZipArchive.h"


//apidata
#define APIKEY @"mdOrjOhzhslLDK7hqfPVzbeOr4VdqDk8"
#define APISIG @"vSTMlKQLdVcWTenqmyQoE1CWSWk91cHW3dNRwaorj1ecKdZH1M0W5ABynxtVXxUKUtsdvhrwrAyrowpQShkPSsyoEgkC1Zcs8Zkefdn89r7a6ORKz1mzVgtbmQbUXv41ZWbKzrXESvcECWwBwfWrt2il5cbfqzRhmOML8"
#define kDHBHost @"https://ios-telecom.dianhua.cn/"

//callExtensionId
#define extensionIdentf [NSString stringWithFormat:@"%@.hbzsCallExtension",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]]

#define isCTPIM 0

#if isCTPIM
#define groupid @"group.live.CTPIM"
#else
#define groupid @"group.ctcc.hbzsforios"
#endif

//test ---@"group.ctcc.hbzsforios"  pro---@"group.live.CTPIM"
@interface HB_IdentACall : NSObject

+ (void)registerDhb;


-(void)isneedUpdataPackage:(void(^)(BOOL isNeed))isNeed;
@end
