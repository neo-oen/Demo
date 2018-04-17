//
//  HB_ContactInfoMoreViewCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/29.
//
//

#import <UIKit/UIKit.h>

@interface HB_ContactInfoMoreViewCell : UITableViewCell

/**
 *  cell的标题
 */
@property(nonatomic,retain)UILabel * nameLabel;

/**
 *  快速返回一个cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
