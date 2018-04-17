//
//  memberWebViewCtr.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/29.
//
//

#import "HB_WebviewCtr.h"
#import "HB_MemberModel.h"

@protocol memWebVcDelegate <NSObject>

-(void)memberWebVcBuymember;

@end

@interface memberWebViewCtr : HB_WebviewCtr

@property(nonatomic,retain)HB_MemberModel * model;
@end
