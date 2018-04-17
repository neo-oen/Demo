//
//  HB_ContactDetailGroupManageCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/9/17.
//
//

#import <UIKit/UIKit.h>

@interface HB_ContactDetailGroupManageCell : UITableViewCell
/**
 *  分组名字
 */
@property (retain, nonatomic) IBOutlet UILabel *groupNameLabel;
/**
 *  右侧选中图片
 */
@property (retain, nonatomic) IBOutlet UIImageView *selectedImageView;


/**
 *  快速创建cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
