//
//  HB_ContactInfoDialItemModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/16.
//
//详情页用到 的通话记录模型

#import <Foundation/Foundation.h>

@interface HB_ContactInfoDialItemModel : NSObject
/**
 *  名字
 */
@property(nonatomic,copy)NSString *name;
/**
 *  电话号码
 */
@property(nonatomic,copy)NSString *phoneNum;
/**
 *  原始的拨号时间
 */
@property(nonatomic,retain)NSDate *callDate;
/**
 *  转换以后的拨号日期，例如：星期三、昨天、今天、12-23日...
 */
@property(nonatomic,copy)NSString *callDate_Day;
/**
 *  转换以后的拨号时间，例如：11：22、08：55...
 */
@property(nonatomic,copy)NSString *callDate_time;

/**
 *  联系人id
 */
@property(nonatomic,assign)NSInteger recordID;

@end
