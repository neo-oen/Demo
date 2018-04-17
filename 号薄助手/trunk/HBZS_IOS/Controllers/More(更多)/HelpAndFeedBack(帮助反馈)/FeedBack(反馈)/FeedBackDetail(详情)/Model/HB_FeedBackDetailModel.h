//
//  HB_FeedBackDetailModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#import <Foundation/Foundation.h>

@interface HB_FeedBackDetailModel : NSObject
/** 提问内容 */
@property(nonatomic,copy)NSString *question;
/** 回复内容 */
@property(nonatomic,copy)NSString *answer;
/** 提问时间 */
@property(nonatomic,copy)NSString *questionTime;
/** 答复时间 */
@property(nonatomic,copy)NSString *answerTime;

@end
