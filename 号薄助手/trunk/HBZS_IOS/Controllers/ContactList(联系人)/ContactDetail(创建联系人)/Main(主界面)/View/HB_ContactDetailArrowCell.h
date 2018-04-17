//
//  HB_ContactDetailArrowCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

#import <UIKit/UIKit.h>
#import "HB_ContactDetailArrowCellModel.h"

@interface HB_ContactDetailArrowCell : UITableViewCell

/**
 *  数据模型
 */
@property(nonatomic,retain)HB_ContactDetailArrowCellModel *model;
/**
 *  快速返回一个右侧带箭头的cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
