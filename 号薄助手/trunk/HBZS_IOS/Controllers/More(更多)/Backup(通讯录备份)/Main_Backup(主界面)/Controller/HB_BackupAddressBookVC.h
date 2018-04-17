//
//  HB_BackupAddressBookVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/13.
//
//

#import "BaseViewCtrl.h"
#import "HB_BackUpBottomView.h"
@interface HB_BackupAddressBookVC : BaseViewCtrl
{
    CGFloat fProgress;
    
    CGFloat fstamp;
    
    BOOL bDataFirst;
    
    BOOL PRO_GOING;
    
    NSInteger iSendNum; //上传的条数
    
    NSInteger iReceiveNum; //下载的条数
}

@property(nonatomic,strong)HB_BackUpBottomView * bottonview;

- (void)noticeBySyncEvent:(id)event;

@end
