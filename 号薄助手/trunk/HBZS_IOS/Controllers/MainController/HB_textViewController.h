//
//  HB_textViewController.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/21.
//
//

#import "BaseViewCtrl.h"

@interface HB_textViewController : BaseViewCtrl

@property(nonatomic,strong)NSString * detailString;

@property (retain, nonatomic) IBOutlet UITextView *detailText;
@end
