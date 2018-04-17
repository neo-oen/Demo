//
//  HB_FeedBackDetailCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#import <UIKit/UIKit.h>
#import "HB_FeedBackDetailFrameModel.h"

@interface HB_FeedBackDetailCell : UITableViewCell
/** frame模型 */
@property(nonatomic,retain)HB_FeedBackDetailFrameModel *frameModel;

/**
 *  快速返回一个celL
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
