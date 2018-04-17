//
//  HB_ContactSimpleModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/21.
//
//

#import <Foundation/Foundation.h>

@interface HB_ContactSimpleModel : NSObject
/** 名字 */
@property(nonatomic,strong)NSString *name;
/** 名字拼音*/
@property(nonatomic,strong)NSString *PinyinName;

/** recordID */
@property(nonatomic,copy)NSString *contactID;
/** 头像 */
@property(nonatomic,retain)NSData *iconData_thumbnail;

/** 展示号码 */
@property(nonatomic,copy)NSString * showNumber;

@property(nonatomic,assign)NSRange colorRange;

@end
