//
//  HB_cardsDealtool.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/6/20.
//
//

#import <Foundation/Foundation.h>
#import "ContactProto.pb.h"
#import "HB_ContactModel.h"
#import "ConfigMgr.h"

#define cardsdataKey @"CardsData"
#define cardsShareUrls @"cloudCardsUrldic"
#define cardportraits @"cardPortraits"

@interface HB_cardsDealtool : NSObject

/*获取名片数据源数组--HB_ContactModel.h **/
+(NSMutableArray *)getCardsdata;
/**保存名片数据 */
+(void)saveCardsdataWithArr:(NSMutableArray *)cardsarr;
/** 更新或新增名片*/
+(BOOL)UpdataCardwithmodel:(HB_ContactModel *)contactmodel;

#pragma mark 头像---目前不用该方法
+(void)saveCardPortraitsWith:(NSArray *)portraits;
+(NSArray *)getCardPortaits;

#pragma 云名片Url管理
/*获取名片URL 字典**/
+(NSDictionary *)getCardsUrldic;
/*获取单个名片URL **/
+(NSString * )getOneCardUrlWithid:(int32_t)cardSid;

+(void)saveCardsUrlWithdictionary:(NSDictionary *)dic;

+(void)saveCloudCardUrl:(NSString *)urlstring andSid:(int32_t *)sid;

@end
