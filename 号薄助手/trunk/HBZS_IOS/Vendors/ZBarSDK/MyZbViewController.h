//
//  MyZbViewController.h
//  ZbarDemo20141009
//
//  Created by 冯强迎 on 15/5/18.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "ZBarReaderView.h"
#import "ZBarCameraSimulator.h"
#import <AVFoundation/AVFoundation.h>

#import "HB_ScanResultAnalyze.h"
@interface MyZbViewController : BaseViewCtrl
{
    ZBarReaderView * _readerView;
}
@property (nonatomic, assign) BOOL isScanning;

@property (nonatomic, copy)void(^ScanResult)(NSString*result,BOOL isSucceed);
//初始化函数
-(id)initWithBlock:(void(^)(NSString*,BOOL))ScanBlock;
@end
