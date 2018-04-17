//
//  HB_OrderInfoController.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/14.
//
//

#import "BaseViewCtrl.h"
#import "OrderMemberProto.pb.h"

@interface HB_OrderInfoController : BaseViewCtrl

@property (retain, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (retain, nonatomic) IBOutlet UILabel *OrderType;

@property (retain, nonatomic) IBOutlet UILabel *cycleLabel;
@property (retain, nonatomic) IBOutlet UILabel *memberLevelLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;

@property(retain,nonatomic)MemberOrder * model;
@end
