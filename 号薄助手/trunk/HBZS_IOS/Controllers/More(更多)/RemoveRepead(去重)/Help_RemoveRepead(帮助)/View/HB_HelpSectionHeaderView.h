//
//  HB_HelpSectionHeaderView.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/18.
//
//

#import <UIKit/UIKit.h>
#import "HB_HelpGroupModel.h" 
@class HB_HelpSectionHeaderView;

@protocol HB_HelpSectionHeaderViewDelegate <NSObject>
/**
 *  按钮点击的代理方法
 */
-(void)helpSectionDidClickWihtHeaderView:(HB_HelpSectionHeaderView * )headerView;

@end

@interface HB_HelpSectionHeaderView : UITableViewHeaderFooterView
/**
 *  代理
 */
@property(nonatomic,assign)id<HB_HelpSectionHeaderViewDelegate> delegate;
/**
 *  模型
 */
@property(nonatomic,retain)HB_HelpGroupModel *model;


/**
 *  快速返回一个view
 */
+(instancetype)headerViewWithTableView:(UITableView * )tableView;

@end
