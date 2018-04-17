//
//  HB_MoreTopMemberView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/5.
//
//

#import <UIKit/UIKit.h>
#import "GetMemberInfoProto.pb.h"
#import "MemAddressBook.h"
#import "HB_ContactModel.h"
typedef enum {
    MoreTopClick_Card = 1,
    MoreTopClick_QRcode = 2,
    MoreTopClick_MemberCenter =3,
    MoreTopClick_login = 4,
    MoreTopClick_Register = 5,
    MoreTopClick_RegetInfo = 6
} MoreTopClickType;

typedef enum {
    moreTopGetMebInfo_getting = 1,
    moreTopGetMebInfo_Suc = 2,
    moreTopGetMebInfo_Error = 3
}moreTopGetMebInfoStatu;

@class HB_MoreTopMemberView;
@protocol TopMemberViewDelegate <NSObject>

-(void)TopMemberView:(HB_MoreTopMemberView *)topMemberView BtnClick:(MoreTopClickType)btnType;

@end

@interface HB_MoreTopMemberView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *headerImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;
@property (retain, nonatomic) IBOutlet UIImageView *memberLevel;
@property (retain, nonatomic) IBOutlet UIView *LoginAndRegView;
@property (retain, nonatomic) IBOutlet UIButton *MycardBtn;

@property (retain, nonatomic) IBOutlet UIButton *registerBtn;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *registerLeft;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *loginLeft;


@property(retain,nonatomic)UIButton * Regetbtn;
@property(retain,nonatomic)UIActivityIndicatorView *activityIndicator;

@property(retain,nonatomic)id<TopMemberViewDelegate>delegate;
@property(retain,nonatomic)HB_ContactModel * contactmodel;
-(void)setdataWith:(MemberInfoResponse *)memberInfo;
-(void)reStepInterFaceWithloginStatu:(BOOL)loginStatu;
-(void)updateAlertViewWithType:(moreTopGetMebInfoStatu)statu;
@end
