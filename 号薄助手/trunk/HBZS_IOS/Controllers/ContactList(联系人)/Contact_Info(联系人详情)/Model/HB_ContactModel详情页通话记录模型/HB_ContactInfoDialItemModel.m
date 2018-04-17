//
//  HB_ContactInfoDialItemModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/16.
//
//

#import "HB_ContactInfoDialItemModel.h"
#import "NSDate+YX.h"

@implementation HB_ContactInfoDialItemModel
-(void)dealloc{
    [_name release];
    [_phoneNum release];
    [_callDate release];
    [_callDate_Day release];
    [_callDate_time release];
    [super dealloc];
}
-(void)setCallDate:(NSDate *)callDate{
    _callDate = [callDate retain];
    //1.给_callDate_Day赋值
    self.callDate_Day=[self getCallDateDayStrWihtDate:_callDate];
    //2.给_callDate_time赋值
    //把世界标准时间（UTC/GMT）转化为当前时区的时间（消除8小时误差）
    NSInteger hour=[callDate getHour];
    NSInteger minite=[callDate getMinite];
    self.callDate_time=[NSString stringWithFormat:@"%02d:%02d",hour,minite];
}
/**
 *  计算拨号日期的最终表示形式：‘今天’‘昨天’‘星期三’‘10-19’‘15-10-19’
 */
-(NSString *)getCallDateDayStrWihtDate:(NSDate*)date{
    NSInteger year=[date getYear];
    NSString * yearStr=[NSString stringWithFormat:@"%d",year];
    yearStr=[yearStr substringFromIndex:2];
    NSInteger month=[date getMonth];
    NSInteger day=[date getDay];
    //1.判断是否为今年
    if ([date isThisYear]) {
        //2.判断是否为今天
        if ([date isToday]) {
            return @"今天";
        }
        //3.判断是否为昨天
        if ([date isYestorday]) {
            return @"昨天";
        }
//        //4.判断是否是七天之内，如果是七天之内，就显示星期几
//        if ([date isInAWeek]) {
//            return [date getWeekday];
//        }
        //5.其余时间，如果是当年，直接返回月份+日期
        return [NSString stringWithFormat:@"%02ld-%02ld",month,day];
    }else{
        return [NSString stringWithFormat:@"%@-%02ld-%02ld",yearStr,month,day];
    }
}



@end
