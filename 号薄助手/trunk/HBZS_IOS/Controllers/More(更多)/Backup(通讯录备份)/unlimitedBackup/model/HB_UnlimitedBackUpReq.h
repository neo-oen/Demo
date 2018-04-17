//
//  HB_UnlimitedBackUpReq.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/8/19.
//
//

#import <Foundation/Foundation.h>

@interface HB_UnlimitedBackUpReq : NSObject


/**reqtype  1--验证是否为会员    0--开通会员*/
/**reqtype  resultCode 0--是会员或开通成功  1--不是会员或开通失败*/
+(void)MemberInfoRequestType:(NSInteger)reqtype resultBlock:(void (^)(NSError * __nullable error,NSInteger resultCode,NSString * __nullable startdate))GetmenberResult;


@end
