//
//  HB_netMsgSearchCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/12/13.
//

#import <UIKit/UIKit.h>
#import "HB_ContactSimpleModel.h"
@interface HB_netMsgSearchCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *namelabel;
@property (retain, nonatomic) IBOutlet UILabel *numberLabel;
@property (retain, nonatomic) IBOutlet UILabel *QcellCorelabel;
@property(nonatomic,retain)HB_ContactSimpleModel * model;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
