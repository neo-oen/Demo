//
//  HB_PhoneNumModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/12.
//
//

#import <Foundation/Foundation.h>

@interface HB_PhoneNumModel : NSObject<NSCoding>
/**
 *  电话号码类型
 */
@property(nonatomic,copy)NSString *phoneType;
/**
 *  电话号码
 */
@property(nonatomic,copy)NSString *phoneNum;
/**
 *  号码归属地
 */
@property(nonatomic,copy)NSString *areaQuary;
/**
 *  第几个电话号码
 */
@property(nonatomic,assign)NSInteger index;

@end
