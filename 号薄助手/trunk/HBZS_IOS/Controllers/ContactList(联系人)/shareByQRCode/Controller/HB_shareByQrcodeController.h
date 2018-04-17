//
//  HB_shareByQrcodeController.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/13.
//
//

#import "BaseViewCtrl.h"
#import "HB_ContactModel.h"
//#import "MyZbViewController.h"
#import "QRCodeScanViewController.h"//二维码扫描

@interface HB_shareByQrcodeController : BaseViewCtrl

-(instancetype)initWithContactModel:(HB_ContactModel *)model;

@property(nonatomic,strong)HB_ContactModel * shareModel;

@property(nonatomic,strong)NSMutableString * showPhoneNum;


@end

