//
//  HB_MessageSettingVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "BaseViewCtrl.h"

@interface HB_MessageSettingVC : BaseViewCtrl
{
    NSDateFormatter *yearformatter;
    NSDateFormatter *monthformatter;
    NSDateFormatter *dayformatter;
    
    NSDateFormatter *formatter;
}
@end
