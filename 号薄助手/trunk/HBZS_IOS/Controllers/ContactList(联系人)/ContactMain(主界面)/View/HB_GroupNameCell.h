//
//  HB_GroupNameCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/14.
//
//

#import <UIKit/UIKit.h>
#import "HB_GroupModel.h"

@interface HB_GroupNameCell : UITableViewCell

/**
 *  分组类
 */
@property(nonatomic,retain)HB_GroupModel *groupItem;

/**
 *  返回一个分组名字的cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
