//
//  NetMessageViewController.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/18.
//
//

#import "BaseViewCtrl.h"
#import "SyncEngine.h"

@interface NetMessageViewController : BaseViewCtrl


@property(nonatomic,strong)UIWebView * web;
@property(assign)BOOL isClose;
- (void)loginStatus:(SyncState_t)state;


@end
