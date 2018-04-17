//
//  HB_GroupSelectView.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/29.
//
//

#import <UIKit/UIKit.h>
#import "HB_GroupModel.h"

@class HB_GroupSelectView;

@protocol HB_GroupSelectViewDelegate <NSObject>
/**
 *  选中某一个分组，其中groupID = -100 表示‘全部联系人’ -101-->‘未分组’ -102-->‘管理分组’
 *
 *  @param groupModel      分组模型
 */
- (void)groupSelectView:(HB_GroupSelectView *)groupSelectView  didSelectGroupModel:(HB_GroupModel *)groupModel;

@end


@interface HB_GroupSelectView : UIView
/** 代理 */
@property(nonatomic,assign)id<HB_GroupSelectViewDelegate> delegate;

@end


