//
//  HB_TopActivityCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/19.
//
//

#import <UIKit/UIKit.h>
#import "GetSysMsgProto.pb.h"
@class HB_TopActivityCell;
@protocol topActivityDelegate <NSObject>

-(void)TopActivityCell:(HB_TopActivityCell *)cell clickwithIndex:(NSInteger)index;

@end
@interface HB_TopActivityCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *topimageView;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;

@property(retain,nonatomic)id<topActivityDelegate>delegate;
-(void)setdataWith:(SysMsg *)msg;
@end
