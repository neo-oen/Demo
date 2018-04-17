//
//  HB_MyCardQRCodeVc.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/26.
//
//

#import "BaseViewCtrl.h"
#import "HB_ContactModel.h"
#import "QRCodeScanViewController.h"//二维码扫描

#import "HB_CardQRImageCollectionCell.h"

@interface HB_MyCardQRCodeVc : BaseViewCtrl
-(instancetype)initWithContactModel:(HB_ContactModel *)model;

@property(nonatomic,strong)NSArray * ContactModelArr;

@property(nonatomic,strong)NSMutableDictionary * Urldic;


@property(nonatomic,retain)NSArray *segmentedArray;

@property(nonatomic,assign)BOOL isOpenMyCard;

@property(nonatomic,assign)NSInteger CurrentIndex;
@end
