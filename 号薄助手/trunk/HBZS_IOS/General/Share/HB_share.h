//
//  HB_share.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/6/28.
//
//

#import <Foundation/Foundation.h>

//友盟  2015.8.25 -yx
#import "UMSocial.h"
#import "UMSocialYixinHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface HB_share : NSObject<UMSocialUIDelegate>
+(void)RegisterUMShare;

-(void)shareWithCurrentVc:(id)currentVc andTitle:(NSString *)title andText:(NSString *)shareInfo andUrl:(NSString *)shareUrl andImage:(UIImage *)headImage andSharePlatForms:(NSArray *)Platforms;

//纯图片分享 默认支持微信，qq，易信好友
-(void)imageShare:(UIImage*)image withVc:(id)vc withSharePlatForms:(NSArray*)platForms;

@end
