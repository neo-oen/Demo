//
//  HB_AddressModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/12/28.
//
//

#import <Foundation/Foundation.h>

@interface HB_AddressModel : NSObject<NSCoding>

/** 地址类型 */
@property(nonatomic,copy)NSString *type;
/** 国家 */
@property(nonatomic,copy)NSString *country;
/** 州、省 */
@property(nonatomic,copy)NSString *state;
/** 市 */
@property(nonatomic,copy)NSString *city;
/** 街道 */
@property(nonatomic,copy)NSString *street;
/** 邮编 */
@property(nonatomic,copy)NSString *zip;
/** 国家编码 */
@property(nonatomic,copy)NSString *countryCode;
/** 第几个地址 */
@property(nonatomic,assign)NSInteger index;

@end
