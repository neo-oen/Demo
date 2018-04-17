//
//  HB_FeedBackDetailFrameModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#import <Foundation/Foundation.h>
#import "HB_FeedBackDetailModel.h"

@interface HB_FeedBackDetailFrameModel : NSObject
/** 数据模型 */
@property(nonatomic,retain)HB_FeedBackDetailModel *model;
/** ‘Q’的frame */
@property(nonatomic,assign)CGRect characterQFrame;
/** ‘A’的frame */
@property(nonatomic,assign)CGRect characterAFrame;
/** ‘问题内容’的frame */
@property(nonatomic,assign)CGRect questionFrame;
/** ‘回复内容’的frame */
@property(nonatomic,assign)CGRect answerFrame;
/** ‘问题的时间’的frame */
@property(nonatomic,assign)CGRect questionTimeFrame;
/** ‘回复的时间’的frame */
@property(nonatomic,assign)CGRect answerTimeFrame;
/** ‘底部细线’的frame */
@property(nonatomic,assign)CGRect bottomLineFrame;
/** cell的hight */
@property(nonatomic,assign)CGFloat cellHight;


@end
