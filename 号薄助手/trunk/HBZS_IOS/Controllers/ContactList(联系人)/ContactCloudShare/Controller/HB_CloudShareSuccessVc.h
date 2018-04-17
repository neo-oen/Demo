//
//  HB_CloudShareSuccessVc.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/8/29.
//
//

#import "BaseViewCtrl.h"

#import "ContactShareProto.pb.h"

@interface HB_CloudShareSuccessVc : BaseViewCtrl
@property (retain, nonatomic) IBOutlet UITextView *UrlAndExtractCode;

@property(nonatomic,strong)ContactShareResponse * shareSucModel;

@property(nonatomic,strong)NSString * MyshareName;

#pragma mark laout

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bottomTextFormBottom;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *headImageFormText;

@end
