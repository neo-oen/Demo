//
//  HB_ContactDetailPhoneEmailTypeCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/14.
//
//

#import <UIKit/UIKit.h>

@interface HB_ContactDetailPhoneEmailTypeCell : UITableViewCell
/**
 *  分组名字
 */
@property (retain, nonatomic) IBOutlet UILabel *typeNameLabel;
/**
 *  右侧选中图片
 */
@property (retain, nonatomic) IBOutlet UIImageView *selectedImageView;

/**
 *  快速创建cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
