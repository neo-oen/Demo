//
//  AccountVc.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/6.
//
//

#import "BaseViewCtrl.h"
#import "CTPass.h"
#import "SyncEngine.h"
#import "UIViewController+TitleView.h"
#import "HBZSAppDelegate.h"
@interface AccountVc : BaseViewCtrl
{
    UITextField * nameTextField;
    UITextField * passWordTextField;
    UIButton * loginButton;
}

@property(nonatomic,copy)void(^AccountBlock)();

- (void)CTPassResult:(ResultType)Type andResultInfo:(NSDictionary *)ResultInfo;

- (void)loginStatus:(SyncState_t)state;

@end
