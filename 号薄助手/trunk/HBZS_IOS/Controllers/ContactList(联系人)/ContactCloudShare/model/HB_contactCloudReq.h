//
//  HB_contactCloudReq.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/8/26.
//
//

#import <Foundation/Foundation.h>
#import "ContactShareProto.pb.h"
#import "SVProgressHUD.h"
#import "SettingInfo.h"

typedef enum {
    reqResCode_suc=0,//成功
    reqResCode_faild, //失败
    reqResCode_NoAccount
    
}reqResCode;
@interface HB_contactCloudReq : NSObject

@property(nonatomic,strong)NSArray * contactIds;

@property(nonatomic,copy)void(^ResBlock)(ContactShareResponse * result,NSString * myName,NSInteger reqResCode);

+(HB_contactCloudReq *)shareManage;

+(NSString *)getCloudShareName;
-(void)CloudShareByContactIds:(NSArray *)contactIdArr andResult:(void(^)(ContactShareResponse * result,NSString *myName,NSInteger reqResCode))resultBlock;

@end
