//
//  HB_HotActivityCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/20.
//
//

#import <UIKit/UIKit.h>
#import "GetSysMsgProto.pb.h"
@interface HB_HotActivityCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, nonatomic) IBOutlet UILabel *readcount;
@property (retain, nonatomic) IBOutlet UIImageView *heardImageView;
@property (retain, nonatomic) IBOutlet UILabel *contectLabel;

-(void)setdata:(SysMsg *)msg;
@end
