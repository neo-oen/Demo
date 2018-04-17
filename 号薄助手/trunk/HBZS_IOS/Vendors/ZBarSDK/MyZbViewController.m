//
//  MyZbViewController.m
//  ZbarDemo20141009
//
//  Created by 冯强迎 on 15/5/18.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "MyZbViewController.h"


#define tempHeight 160
@interface MyZbViewController ()<ZBarReaderViewDelegate>
@property(nonatomic,retain)ZBarSymbolSet *symbols;

@end

@implementation MyZbViewController
-(void)dealloc{
    [_symbols release];
    [super dealloc];
}
-(id)initWithBlock:(void(^)(NSString*,BOOL))ScanBlock{
    if (self=[super init]) {
        self.ScanResult=ScanBlock;
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码扫描";
    self.leftBtnIsBack = YES;
    [self hiddenTabBar];
    
    [self CreateScanView];
    
    [self createScanFrame];
    
    [self CreateLightButton];
    
}

-(void)createScanFrame
{
    //top
    [self createScanFrameViewWithFrame:CGRectMake(0, 0, Device_Width, CGRectGetMidY(self.view.frame)-tempHeight)];
    //left
    [self createScanFrameViewWithFrame:CGRectMake(0, CGRectGetMidY(self.view.frame)-tempHeight, (Device_Width-200)/2, 200)];
    
    //right
    [self createScanFrameViewWithFrame:CGRectMake(Device_Width/2+100, CGRectGetMidY(self.view.frame)-tempHeight, (Device_Width-200)/2, 200)];
    
    //down
    [self createScanFrameViewWithFrame:CGRectMake(0, CGRectGetMidY(self.view.frame)-tempHeight+200, Device_Width, self.view.frame.size.height-200-CGRectGetMidY(self.view.frame)+tempHeight)];
    
    UILabel * QRlabel = [[UILabel alloc] initWithFrame:CGRectMake((Device_Width-200)/2,CGRectGetMidY(self.view.frame)-tempHeight+200, 200, 25)];
    QRlabel.text= @"将扫描框对准二维码，进行自动扫描";
    QRlabel.textColor = [UIColor whiteColor];
    QRlabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:QRlabel];
    
    
    UIImageView * qrScanFrameImageView = [[UIImageView alloc] initWithFrame:CGRectMake((Device_Width-200)/2, CGRectGetMidY(self.view.frame) - tempHeight, 200, 200)];
    qrScanFrameImageView.image = [UIImage imageNamed:@"qrcode_scan_Frame"];
    [self.view addSubview:qrScanFrameImageView];
    [qrScanFrameImageView release];
    
}

-(void)createScanFrameViewWithFrame:(CGRect)tempViewFrame;
{
    UIImageView * tempImageView = [[UIImageView alloc] initWithFrame:tempViewFrame];
    tempImageView.alpha = 0.5;
    tempImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tempImageView];
    [tempImageView release];
    
}

- (void)CreateLightButton
{
    UIButton * LightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LightBtn.frame = CGRectMake(0, 0, 65, 87);
    LightBtn.center = CGPointMake(self.view.center.x,self.view.frame.size.height-120);
    [LightBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [LightBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_scan_off"] forState:UIControlStateHighlighted];
    
    [LightBtn addTarget:self action:@selector(LightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LightBtn];
    
}

-(void)LightClick:(UIButton *)lightBtn
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchMode==AVCaptureTorchModeOff) {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        
    }else {
        //闪光灯关闭
        
        [device setTorchMode:AVCaptureTorchModeOff];
    }
}

- (void)CreateScanView
{
    _readerView = [[ZBarReaderView alloc]init];
    _readerView.frame =self.view.frame;
    _readerView.readerDelegate = self;
    
    //关闭闪光灯
    _readerView.torchMode = 0;
    //扫描区域
    CGRect scanMaskRect = self.view.frame; //CGRectMake((Device_Width-200)/2, CGRectGetMidY(_readerView.frame) - tempHeight, 200, 200);
    
      //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc] initWithViewController:self];
        cameraSimulator.readerView = _readerView;
    }
    
    [self.view addSubview:_readerView];
    //扫描区域计算
    _readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:_readerView.bounds];
    
    [_readerView start];
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    self.symbols = symbols;
    [readerView stop];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    ZBarSymbol *symbol = nil;
    for (symbol in self.symbols) {
        //ZBLog(@"%@", symbol.data);
        break;
    }
    if (!symbol.data) {
        return;
    }
    if (self.ScanResult) {
        

        NSString * str1 = symbol.data;
        
        if ([str1 canBeConvertedToEncoding:NSShiftJISStringEncoding])
        {
            str1 = [NSString stringWithCString:[symbol.data cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
            
            if (str1 == nil) {
                 str1 = symbol.data;
            }
        }
        self.ScanResult(str1,YES);
    }
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(0.1, 0.1,0.9, 0.9);// CGRectMake(x, y, width, height);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchMode==AVCaptureTorchModeOn) {
        //闪光灯关闭
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    
    if (_readerView) {
        [_readerView stop];
        [_readerView release];
        _readerView = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
