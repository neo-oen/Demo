//
//  HB_HelpRemoveCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/17.
//
//

#import <UIKit/UIKit.h>
#import "HB_HelpGroupModel.h"

@interface HB_HelpRemoveCell : UITableViewCell
/**
 *  模型
 */
@property(nonatomic,retain)HB_HelpGroupModel *model;


/**
 *  快速创建HB_HelpRemoveCell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
