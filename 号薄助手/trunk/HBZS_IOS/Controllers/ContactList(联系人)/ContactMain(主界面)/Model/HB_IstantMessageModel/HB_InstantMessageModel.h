//
//  HB_InstantMessageModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/12/30.
//
//

#import <Foundation/Foundation.h>

@interface HB_InstantMessageModel : NSObject<NSCoding>
/**
 *  类型
 */
@property(nonatomic,copy)NSString *type;
/**
 *  账户名
 */
@property(nonatomic,copy)NSString *account;
/**
 *  第几个im
 */
@property(nonatomic,assign)NSInteger index;



@end
