//
//  HB_ContactInfoCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import <UIKit/UIKit.h>
#import "HB_ContactInfoCellModel.h"

@interface HB_ContactInfoCell : UITableViewCell
/**
 *  普通cell的模型
 */
@property(nonatomic,retain)HB_ContactInfoCellModel *model;

/**
 *  快速返回一个cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
