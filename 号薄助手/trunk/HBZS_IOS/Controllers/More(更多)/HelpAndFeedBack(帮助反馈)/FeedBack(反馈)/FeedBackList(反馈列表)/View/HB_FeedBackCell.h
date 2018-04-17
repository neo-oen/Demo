//
//  HB_FeedBackCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/5.
//
//

#import <UIKit/UIKit.h>
#import "HB_FeedBackInfoModel.h"//反馈信息的模型

@interface HB_FeedBackCell : UITableViewCell
/**
 *  反馈信息的模型
 */
@property(nonatomic,retain)HB_FeedBackInfoModel *model;


/**
 *  快速返回一个cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
