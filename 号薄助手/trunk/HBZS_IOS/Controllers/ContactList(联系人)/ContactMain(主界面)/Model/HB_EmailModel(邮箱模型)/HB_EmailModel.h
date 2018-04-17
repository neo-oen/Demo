//
//  HB_EmailModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/13.
//
//

#import <Foundation/Foundation.h>

@interface HB_EmailModel : NSObject<NSCoding>
/**
 *  邮箱类型
 */
@property(nonatomic,copy)NSString *emailType;
/**
 *  邮箱地址
 */
@property(nonatomic,copy)NSString *emailAddress;
/**
 *  第几个邮箱
 */
@property(nonatomic,assign)NSInteger index;

@end
