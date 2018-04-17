//
//  HB_HelpGroupModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/18.
//
//

#import <Foundation/Foundation.h>

@interface HB_HelpGroupModel : NSObject

/**
 *  问题
 */
@property(nonatomic,copy)NSString *question;
/**
 *  答案
 */
@property(nonatomic,copy)NSString *answer;
/**
 *  是否展开
 */
@property(nonatomic,assign,getter=isOpen)BOOL open;


+(instancetype)modelWithDict:(NSDictionary *)dict;

-(instancetype)initWithDict:(NSDictionary * )dict;

@end
