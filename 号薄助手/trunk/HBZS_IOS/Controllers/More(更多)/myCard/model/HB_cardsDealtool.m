//
//  HB_cardsDealtool.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/6/20.
//
//

#import "HB_cardsDealtool.h"
#import "DownloadPortraitProto.pb.h"
#import "HB_httpRequestNew.h"
#import "ContactProtoToContactModel.h"
@implementation HB_cardsDealtool

+(NSMutableArray *)getCardsdata
{ /*元素为HB_ContactModel对象*/
    NSData * data = [[NSUserDefaults standardUserDefaults] valueForKey:cardsdataKey];
    NSMutableArray * arr= [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return arr;
}
+(void)saveCardsdataWithArr:(NSMutableArray *)cardsarr
{ /* cardsArr中的元素为 HB_ContactModel 对象**/
    if (cardsarr.count>5) {
        [cardsarr removeObjectsInRange:NSMakeRange(5, cardsarr.count-5)];
    }
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:cardsarr];
    
    NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:data forKey:cardsdataKey];
//    [[ConfigMgr getInstance] setValue:data forKey:cardsdataKey forDomain:nil];
    [userdef synchronize];
    
}
+(BOOL)UpdataCardwithmodel:(HB_ContactModel *)contactmodel
{
    BOOL isaddNewCard = YES;
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObjectsFromArray:[self getCardsdata]];
    
    
    for (NSInteger i = 0; i<arr.count; i++) {
        HB_ContactModel * model = [arr objectAtIndex:i];
        if (abs(model.cardid) == abs(contactmodel.cardid)&&contactmodel.cardid != 0) {
            [arr replaceObjectAtIndex:i withObject:contactmodel];
            //如果已存在该名片id，则设置为NO 表示非新增
            isaddNewCard = NO;
            break;
        }
    }
    if (arr.count<5&&isaddNewCard) {
        
        [arr addObject:contactmodel];
    }
    else
    {
        [self saveCardsdataWithArr:arr];
        return NO;
    }
    
    [self saveCardsdataWithArr:arr];
    
    return YES;
}

+(void)clearCard
{
    NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults];
    
    [userdef removeObjectForKey:cardportraits];
    [userdef removeObjectForKey:cardsShareUrls];
    [userdef removeObjectForKey:cardsdataKey];
    [userdef synchronize];
}



+(void)saveCardPortraitsWith:(NSArray *)portraits
{
    NSMutableArray * Cardarr = [self getCardsdata];
    
    for (DownloadPortraitData * downloadpor in portraits) {
        for (HB_ContactModel * model in Cardarr) {
            if (model.cardid == downloadpor.portraitSid) {
                if (downloadpor.portraitData.imageData) {
                    model.iconData_original = downloadpor.portraitData.imageData;
                }
            }
        }
    }
    
    [self saveCardsdataWithArr:Cardarr];
        
}

+(NSArray *)getCardPortaitsBydata
{
    NSUserDefaults * userdef = [NSUserDefaults standardUserDefaults];
    
    return [userdef objectForKey:cardportraits];
    
}
+(NSArray *)getCardPortaits
{
    NSArray * arr = [self getCardPortaitsBydata];
    NSMutableArray * portaits = [NSMutableArray arrayWithCapacity:0];
    for (NSData * data in arr) {
        DownloadPortraitData * portaitdata = [DownloadPortraitData parseFromData:data];
        [portaits addObject:portaitdata];
    }
    return portaits;
}





+(NSDictionary *)getCardsUrldic
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:cardsShareUrls];
}
+(NSString *)getOneCardUrlWithid:(int32_t)cardSid
{
    NSDictionary * dic = [self getCardsUrldic];
    return [dic objectForKey:[NSString stringWithFormat:@"%d",cardSid]];
}
+(void)saveCardsUrlWithdictionary:(NSDictionary *)dic
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:cardsShareUrls];
    [userDefaults synchronize];
}
+(void)saveCloudCardUrl:(NSString *)urlstring andSid:(int32_t *)sid
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[self getCardsUrldic]];
    
    [dic setValue:urlstring forKey:[NSString stringWithFormat:@"%d",sid]];
    
    [self saveCardsUrlWithdictionary:dic];
    
}




@end
