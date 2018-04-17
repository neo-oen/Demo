//
//  HB_UrlModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/12/29.
//
//

#import <Foundation/Foundation.h>

@interface HB_UrlModel : NSObject<NSCoding>

/**
 *  网址类型
 */
@property(nonatomic,copy)NSString *type;

/**
 *  网址
 */
@property(nonatomic,copy)NSString *url;

/**
 *  第几个url
 */
@property(nonatomic,assign)NSInteger index;


@end
