//
//  QRCodeScanViewController.h
//  3D-touch_test
//
//  Created by 冯强迎 on 16/4/26.
//  Copyright © 2016年 冯强迎. All rights reserved.
//

#import "BaseViewCtrl.h"

#import <AVFoundation/AVFoundation.h>

#import "HB_ScanResultAnalyze.h"

@interface QRCodeScanViewController : BaseViewCtrl

@property (nonatomic, assign) BOOL isScanning;

@property (nonatomic, copy)void(^ScanResult)(NSString*result,BOOL isSucceed);


//初始化函数
-(id)initWithBlock:(void(^)(NSString*,BOOL))ScanBlock;

@end
