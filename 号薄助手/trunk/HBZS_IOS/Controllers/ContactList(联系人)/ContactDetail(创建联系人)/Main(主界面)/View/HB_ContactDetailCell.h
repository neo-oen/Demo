//
//  HB_ContactDetailCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

#import <UIKit/UIKit.h>
#import "HB_ContactDetailCellModel.h"
@class HB_ContactDetailCell;

@interface HB_ContactDetailCell : UITableViewCell

/**  数据模型 */
@property(nonatomic,retain)HB_ContactDetailCellModel *model;

/**  快速返回一个普通的cell */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
