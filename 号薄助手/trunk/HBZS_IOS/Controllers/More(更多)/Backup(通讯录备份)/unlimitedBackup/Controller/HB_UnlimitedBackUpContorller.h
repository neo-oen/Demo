//
//  HB_UnlimitedBackUpContorller.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/7/15.
//
//

#import "BaseViewCtrl.h"
#import "UnlimitedBpStartView.h"
#import "SettingUnlimitedBackupView.h"
#import "SyncProgressView.h"

@interface HB_UnlimitedBackUpContorller : BaseViewCtrl<UnlimitedBpStartViewDelegate,SettingUnlimitedBackupViewDelegate,UIAlertViewDelegate>

@property(nonatomic,retain)UnlimitedBpStartView * StartView;

@property(nonatomic,retain)SettingUnlimitedBackupView * StepsView;

@property(nonatomic,retain)SyncProgressView * progressv;


@end
