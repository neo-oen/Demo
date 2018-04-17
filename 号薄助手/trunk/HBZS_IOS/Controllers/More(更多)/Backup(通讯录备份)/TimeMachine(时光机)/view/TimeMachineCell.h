//
//  TimeMachineCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/12/2.
//
//

#import <UIKit/UIKit.h>
#import "HB_MachineDataModel.h"
@interface TimeMachineCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UILabel *contactCountLabel;


-(void)setDataWithModel:(HB_MachineDataModel *)model;
@end
