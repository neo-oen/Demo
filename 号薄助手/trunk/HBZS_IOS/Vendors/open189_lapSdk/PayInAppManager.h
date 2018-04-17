//
//  PayInAppManager.h
//  MixInAappPayLibdemo
//
//  Created by dust on 16/3/21.
//  Copyright © 2016年 dust. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PayInAppManager : NSObject 

/*    本SDK 中包含三个文件：MixInAppPayLib.a , PayInAppManager.h, MixInAppPayLib.bundle (SDK所需图片资源)
 *    开发者只需传送一下参数 app_id,pay_code,phone,state(可传空，保留字段)，app_Secret
 *    需要传入 SKD被使用的 视图控制器
 *    需要加入以下类库 ：CFNetwork.framework,libz.1.1.3.tbd,CoreGraphics.framework,MobileCoreServices.framework
                      SystemConfiguration.framework,
 
      需要在 TARGETS -> Linking -> Other Linker Flags 加入“-ObjC” (以便解决类别冲突)
 */

+ (void)basicValueByAppId:(NSString *)AppIdStr
               andPayCode:(NSString *)payCodeStr
              andPhoneNum:(NSString *)phoneNumStr
                 andState:(NSString *)stateStr
             andAppSecret:(NSString *)appSecret
         callBackSelector:(SEL)cbSelector
                   object:(UIViewController *)viewController;

+ (void)basicValueByAppId:(NSString *)AppIdStr
               andPayCode:(NSString *)payCodeStr
              andPhoneNum:(NSString *)phoneNumStr
                 andState:(NSString *)stateStr
             andAppSecret:(NSString *)appSecret
                   object:(UIViewController *)viewController;
@end
