//
//  HB_MemberCenterHeadview.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/7.
//
//

#import <UIKit/UIKit.h>
#import "GetMemberInfoProto.pb.h"

@class HB_MemberCenterHeadview;
@protocol MemberCenterHearderDelegate <NSObject>

/*
 * index =0 订购btn   index = 1  VIPbtn 会员变更记录跳转按钮
 */
-(void)memberHeaderView:(HB_MemberCenterHeadview *)headerView clickWithIndex:(NSInteger)index;


@end
@interface HB_MemberCenterHeadview : UIView
@property (retain, nonatomic) IBOutlet UIImageView *headerImageView;

@property (retain, nonatomic) IBOutlet UILabel *levelLabel;//占时不启用
@property (retain, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *bottonLabel;
@property (retain, nonatomic) IBOutlet UIButton *membtn;

@property(nonatomic, retain)id<MemberCenterHearderDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIButton *memberChangeRecode;

@property (retain, nonatomic) IBOutlet UIView *bottomView;

//约束
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelWidth;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelLeftTrailing;
-(void)setMemberViewDataWithMemberInfo:(MemberInfoResponse *)memberInfo;
@end
