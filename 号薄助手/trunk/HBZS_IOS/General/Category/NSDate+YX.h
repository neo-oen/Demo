//
//  NSDate+YX.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/19.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (YX)
/** 把世界标准时间（UTC/GMT）转化为当前时区的时间（消除8小时误差） */
- (NSDate *)getLocalDate;
/** 根据日期获取星期几(这里切记不用考虑8小时误差，直接用日期就好) */
-(NSString*)getWeekday;
/** 获取年份 */
-(NSInteger)getYear;
/** 获取月份 */
-(NSInteger)getMonth;
/** 获取当前月份的第几周 */
-(NSInteger)getWeekOfMonth;
/** 获取天 */
-(NSInteger)getDay;
/** 获取小时 */
-(NSInteger)getHour;
/** 获取分钟 */
-(NSInteger)getMinite;
/** 获取秒 */
-(NSInteger)getSecond;
#pragma mark - 判断
/** 判断是否是今天 */
-(BOOL)isToday;
/** 判断是否是昨天 */
-(BOOL)isYestorday;
/** 判断是否为七天之内 */
-(BOOL)isInAWeek;
/** 判断是否为本月 */
-(BOOL)isThisMonth;
/** 判断是否为今年 */
-(BOOL)isThisYear;

@end
