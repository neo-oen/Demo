//
//  HB_FeedBackInfoModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/5.
//
//

#import <Foundation/Foundation.h>

@interface HB_FeedBackInfoModel : NSObject
/**
 *  反馈内容（问题）
 */
@property(nonatomic,copy)NSString *feedBackContent;
/**
 *  反馈时间
 */
@property(nonatomic,copy)NSString *time;
/**
 *  反馈状态（是否回复）
 */
@property(nonatomic,copy)NSString *replayStatus;


@end
