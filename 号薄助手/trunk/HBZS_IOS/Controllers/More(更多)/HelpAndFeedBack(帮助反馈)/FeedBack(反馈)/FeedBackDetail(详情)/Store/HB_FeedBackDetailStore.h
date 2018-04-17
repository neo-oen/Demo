//
//  HB_FeedBackDetailStore.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#import <Foundation/Foundation.h>
@class HB_FeedBackDetailStore;

@protocol HB_FeedBackDetailStoreDelegate <NSObject>
/** 获取到数据 */
-(void)feedBackDetailStore:(HB_FeedBackDetailStore *)store didFinishReceiveData:(NSArray *)frameModelArr;
@end



@interface HB_FeedBackDetailStore : NSObject

/** 发送网络请求 */
-(void)sendRequestAndResumeTask;

/** 代理 */
@property(nonatomic,assign)id<HB_FeedBackDetailStoreDelegate> delegate;

@end
