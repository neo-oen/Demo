//
//  HB_GroupManageCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import <UIKit/UIKit.h>
#import "HB_GroupModel.h"
@class HB_GroupManageCell;

@protocol HB_GroupManageCellDelegate <NSObject>
/**
 *  编辑按钮点击
 */
-(void)groupManageCell:(HB_GroupManageCell *)cell editBtnClick:(UIButton *)editBtn;
/**
 *  删除按钮点击
 */
-(void)groupManageCell:(HB_GroupManageCell *)cell deleteBtnClick:(UIButton *)deleteBtn;
/**
 *  分享按钮点击
 */
-(void)groupManageCell:(HB_GroupManageCell *)cell shareBtnClick:(UIButton *)shareBtn;


@end

@interface HB_GroupManageCell : UITableViewCell
/** 分组管理cell的模型 */
@property(nonatomic,retain)HB_GroupModel *model;
/** 分组名字+成员个数 */
@property(nonatomic,retain)UILabel *groupNameLabel;
/** 编辑分组按钮 */
@property(nonatomic,retain)UIButton *editBtn;
/** 删除分组按钮 */
@property(nonatomic,retain)UIButton *deleteBtn;
/** 分享分组联系人按钮 */
@property(nonatomic,retain)UIButton *shareBtn;
/** 右侧箭头 */
@property(nonatomic,retain)UIImageView *arrowImageView;
/** 底部细线 */
@property(nonatomic,retain)UILabel *lineLabel;

@property(nonatomic,assign)id<HB_GroupManageCellDelegate> delegate;

/**  快速返回一个cell */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
