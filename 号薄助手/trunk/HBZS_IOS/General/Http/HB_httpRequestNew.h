//
//  HB_httpRequestNew.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/8.
//
//

#import <Foundation/Foundation.h>
#import "CuMycardShareProto.pb.h"
#import "GetMemberInfoProto.pb.h"
#import "HB_OrderMemberModel.h"
#import "OrderMemberProto.pb.h"
#import "HB_ContactModel.h"
@interface HB_httpRequestNew : NSObject
@property(nonatomic,retain)NSURLSessionTask * currentask;
+(NSMutableURLRequest*)getRequestString:(NSString *)urlString;

//上传头像
-(BOOL)upCardPortrait:(HB_ContactModel*)model;
//判断是否有云名片
-(void)isOpenMyCardShareWithId:(int32_t)cardid Result:(void(^)(BOOL isSuccess,NSInteger isOpenMycard))resultBlock;
//判断是否有云名片 (同步请求)
-(NSDictionary *)SyncisOpenMyCardwithid:(int32_t)CardId;

/*云名片分享/名片上传更新   resultCode-删除云名片时用于判断是否删除成功
                        recCode - 上传名片时用于判断上传处理结果
 */
-(void)UpdateMyCardWithType:(NSInteger)type andContact:(Contact *)cardcontact Result:(void(^)(BOOL isSucess,int32_t sid,NSInteger resultCode,NSInteger recCode,NSString * url))resultBlock;

//同步方式，返回名片sid
-(int)SyncUplodaCardMycardWithType:(NSInteger)type andContact:(Contact *)cardcontact;


//会员信息
-(void)getMemberInfoResult:(void(^)(BOOL isSuccess,MemberInfoResponse * memberInfo))resultBlock;

//会员模块
-(void)getMemberModelResult:(void(^)(BOOL isSuccess, NSDictionary * dic))resultBlock;

//查询会员订购是否可用
-(void)orderVipIsValidResult:(void(^)(BOOL isSuccess, NSDictionary * dic))resultBlock;

//会员信息变更
-(void)OrderMemberWithOrderInfo:(HB_OrderMemberModel *)model Result:(void(^)(BOOL isSuccess, MemberOrderResponse * MOResponse))resultBlock;


//获取名片
-(void)getMyCardformServerResult:(void(^)(BOOL isisSuccess))resultBlock;
-(void)stopcurrentRequest;
-(void)getCardCountFormServerResult:(void(^)(BOOL isSuccess,NSInteger Cardcount))resultBlock;

//会员支付
+(void)buyMemberWithVc:(UIViewController *)object;
+(void)PayBackInfo:(NSString *)code;


//认证
-(void)Auth:(void(^)(BOOL isAuthSuccess))next;

@end
