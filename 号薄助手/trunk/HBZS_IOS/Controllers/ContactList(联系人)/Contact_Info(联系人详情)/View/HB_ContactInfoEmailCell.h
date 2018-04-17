//
//  HB_ContactInfoEmailCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import <UIKit/UIKit.h>
#import "HB_ContactInfoEmailCellModel.h"
@class HB_ContactInfoEmailCell;

@protocol HB_ContactInfoEmailCellDelegate <NSObject>
/**
 *  发送邮箱按钮点击
 */
-(void)contactInfoEmailCellDidSendEmail:(HB_ContactInfoEmailCell*)emailCell;
@end

@interface HB_ContactInfoEmailCell : UITableViewCell
/**
 *  普通cell的模型
 */
@property(nonatomic,retain)HB_ContactInfoEmailCellModel *model;
/**
 *  HB_ContactInfoEmailCell的代理
 */
@property(nonatomic,assign)id<HB_ContactInfoEmailCellDelegate> delegate;
/**
 *  快速返回一个cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
