//
//  HB_GroupMoveOrCopyVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/1.
//
//

#import "BaseViewCtrl.h"
@class HB_GroupModel;

@interface HB_GroupMoveOrCopyVC : BaseViewCtrl
/**
 *  需要变动的联系人模型数组
 */
@property(nonatomic,retain)NSArray *contactDataArr;
/**
 *  数据源的group (为了筛选显示)
 */
@property(nonatomic,assign)NSInteger currentGroupID;
/**
 *  需要的回调操作
 */
@property(nonatomic,copy)void(^optionBlock)(HB_GroupModel * groupModel);

@end
