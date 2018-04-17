//
//  NSDate+YX.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/19.
//
//

#import "NSDate+YX.h"

@implementation NSDate (YX)
/**
 *  把世界标准时间（UTC/GMT）转化为当前时区的时间（消除8小时误差）
 */
- (NSDate *)getLocalDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:self] autorelease];
    return destinationDateNow;
}
/**
 *  根据当前对象获取一个NSDateComponents对象
 */
-(NSDateComponents *)getComponentsWithDate{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone=[NSTimeZone systemTimeZone];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitMonth |NSCalendarUnitWeekOfMonth| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unit fromDate:self];
    [calendar release];
    return components;
}
/**
 *  获取年份
 */
-(NSInteger)getYear{
    NSDateComponents * components=[self getComponentsWithDate];
    return components.year;
}
/**
 *  获取月份
 */
-(NSInteger)getMonth{
    NSDateComponents * components=[self getComponentsWithDate];
    return components.month;
}
/**
 *  获取当前月份的第几周
 */
-(NSInteger)getWeekOfMonth{
    NSDateComponents * components=[self getComponentsWithDate];
    return components.weekOfMonth;
}
/**
 *  获取天
 */
-(NSInteger)getDay{
    NSDateComponents * components=[self getComponentsWithDate];
    return components.day;
}
/**
 *  根据日期获取星期几(这里切记不用考虑8小时误差，直接用日期就好)
 */
-(NSString*)getWeekday{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone=[NSTimeZone systemTimeZone];
    NSDateComponents *weekdayComponents =
    [calendar components:NSCalendarUnitWeekday fromDate:self];
    int weekday = [weekdayComponents weekday];
    [calendar release];
    switch (weekday) {
        case 1:{
            return @"星期日";
        }break;
        case 2:{
            return @"星期一";
        }break;
        case 3:{
            return @"星期二";
        }break;
        case 4:{
            return @"星期三";
        }break;
        case 5:{
            return @"星期四";
        }break;
        case 6:{
            return @"星期五";
        }break;
        case 7:{
            return @"星期六";
        }break;
        default:return nil; break;
    }
}
/**
 *  获取小时
 */
-(NSInteger)getHour{
    NSDateComponents * components=[self getComponentsWithDate];
    return components.hour;
}
/**
 *  获取分钟
 */
-(NSInteger)getMinite{
    NSDateComponents * components=[self getComponentsWithDate];
    return components.minute;
}
/**
 *  获取秒
 */
-(NSInteger)getSecond{
    NSDateComponents * components=[self getComponentsWithDate];
    return components.second;
}
#pragma mark - 判断
/** 判断是否是今天 */
-(BOOL)isToday{
    if (![self isThisMonth]) {
        return NO;
    }
    NSDate * nowDate=[NSDate date];
    return [nowDate getDay]==[self getDay];
}
/** 判断是否是昨天 */
-(BOOL)isYestorday{
    if (![self isThisYear]) {
        return NO;
    }
    //走到这里，证明是同一年的
    NSDate * nowDate=[NSDate date];
    if ([self isThisMonth]) {//如果是同一个月份
        return [self getDay]+1==[nowDate getDay];
    }else{//不是同一个月份
        if ([nowDate getDay]!=1) {
            return NO;
        }else{
            switch ([self getMonth]) {//判断是几月份
                case 2:{
                    //判断是否是闰年
                    if ([self getMonth]%100==0) {//如果能被100整除的话
                        if ([self getMonth]%4==0) {
                            //闰年
                            return [self getDay]==29;
                        }else{
                            //平年
                            return [self getDay]==28;
                        }
                    }
                }break;
                case 1:{
                    return [self getDay]==31;
                }break;
                case 3:{
                    return [self getDay]==31;
                }break;
                case 5:{
                    return [self getDay]==31;
                }break;
                case 7:{
                    return [self getDay]==31;
                }break;
                case 8:{
                    return [self getDay]==31;
                }break;
                case 10:{
                    return [self getDay]==31;
                }break;
                case 12:{
                    return [self getDay]==31;
                }break;
                case 4:{
                    return [self getDay]==30;
                }break;
                case 6:{
                    return [self getDay]==30;
                }break;
                case 9:{
                    return [self getDay]==30;
                }break;
                case 11:{
                    return [self getDay]==30;
                }break;
                default: break;
            }
            return NO;
        }
    }
}
/** 判断是否为七天之内 */
-(BOOL)isInAWeek{
    NSDate * nowDate=[NSDate date];
    if ([self isThisYear]) {
        //*如果是同一年
        if ([self isThisMonth]) {
            //1.是同一个月
            return nowDate.getDay-self.getDay<=7;
        }else{
            //2.如果不是同一个月，则判断是不是相邻的两个月
            if ((nowDate.getMonth - self.getMonth) == 1 ) {
                //是相邻两个月
                switch ([self getMonth]) {//判断是几月份
                    case 2:{
                        //判断是否是闰年
                        if ([self getMonth]%100==0) {//如果能被100整除的话
                            if ([self getMonth]%4==0) {
                                //闰年
                                return (nowDate.getDay+29 - self.getDay) <= 7;
                            }else{
                                //平年
                                return (nowDate.getDay+28 - self.getDay) <= 7;
                            }
                        }
                    }break;
                    case 1:{
                        return (nowDate.getDay+31 - self.getDay) <= 7;
                    }break;
                    case 3:{
                        return (nowDate.getDay+31 - self.getDay) <= 7;
                    }break;
                    case 5:{
                        return (nowDate.getDay+31 - self.getDay) <= 7;
                    }break;
                    case 7:{
                        return (nowDate.getDay+31 - self.getDay) <= 7;
                    }break;
                    case 8:{
                        return (nowDate.getDay+31 - self.getDay) <= 7;
                    }break;
                    case 10:{
                        return (nowDate.getDay+31 - self.getDay) <= 7;
                    }break;
                    case 12:{
                        return (nowDate.getDay+31 - self.getDay) <= 7;
                    }break;
                    case 4:{
                        return (nowDate.getDay+30 - self.getDay) <= 7;
                    }break;
                    case 6:{
                        return (nowDate.getDay+30 - self.getDay) <= 7;
                    }break;
                    case 9:{
                        return (nowDate.getDay+30 - self.getDay) <= 7;
                    }break;
                    case 11:{
                        return (nowDate.getDay+30 - self.getDay) <= 7;
                    }break;
                    default: break;
                }
            }
        }
    }else{
        //*不是同一年，则需要判断是否是相邻的两年
        if ( (nowDate.getYear - self.getYear) == 1 ) {
            //是相邻的两年
            if (nowDate.getMonth==1 && self.getMonth==12) {
                //则证明一个是12月的一个是1月的
                if (nowDate.getDay + 31 - self.getDay <=7) {
                    //证明是7天之内
                    return YES;
                }
            }
        }
    }
    return NO;
}
/** 判断是否为本月 */
-(BOOL)isThisMonth{
    if (![self isThisYear]) {
        return NO;
    }
    NSDate * nowDate=[NSDate date];
    return [nowDate getMonth]==[self getMonth];
}
/** 判断是否为今年 */
-(BOOL)isThisYear{
    NSDate * nowDate=[NSDate date];
    return [nowDate getYear]==[self getYear];
}


@end
