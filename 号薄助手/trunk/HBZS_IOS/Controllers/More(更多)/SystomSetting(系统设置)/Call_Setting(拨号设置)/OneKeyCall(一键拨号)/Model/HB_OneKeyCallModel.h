//
//  HB_OneKeyCallModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/31.
//
//

#import <Foundation/Foundation.h>

@interface HB_OneKeyCallModel : NSObject<NSCoding>

/**
 *  第几个按键
 */
@property(nonatomic,assign)NSInteger keyNumber;
/**
 *  联系人id
 */
@property(nonatomic,assign)NSInteger recordID;
/**
 *  缩略图
 */
@property(nonatomic,retain)NSData *iconData_thumbnail;
/**
 *  名字
 */
@property(nonatomic,retain)NSString *name;
/**
 *  电话
 */
@property(nonatomic,retain)NSString *phoneNum;



@end
