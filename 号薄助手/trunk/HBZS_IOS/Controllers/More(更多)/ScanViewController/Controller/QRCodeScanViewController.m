//
//  QRCodeScanViewController.m
//  3D-touch_test
//
//  Created by 冯强迎 on 16/4/26.
//  Copyright © 2016年 冯强迎. All rights reserved.
//
#define tempHeight 160
#import "QRCodeScanViewController.h"
#import "SVProgressHUD.h"
#import "ZBarReaderController.h"

@interface QRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;


@property (nonatomic,assign) CGRect scanRect;

@end

@implementation QRCodeScanViewController

-(id)initWithBlock:(void(^)(NSString*,BOOL))ScanBlock{
    if (self=[super init]) {
        self.ScanResult=ScanBlock;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self stepNavigationItem];
    
    [self hiddenTabBar];

    [self createScanFrame];
    
    [self CreateLightButton];
    
    [self createScanAVCaptureSession];//此方法必须在 [self createScanFrame] 调用 因为扫描区域的计算基于createScanFrame 中的qrScanFrameImageView(边框图片)的坐标

    
}

-(void)stepNavigationItem
{
    self.title = @"二维码扫描";
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    [btn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"相册" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
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
    
    //计算扫描区域  比所见区域长宽大20
    
    self.scanRect = CGRectMake(qrScanFrameImageView.frame.origin.x-20, qrScanFrameImageView.frame.origin.y-20, qrScanFrameImageView.frame.size.width+40, qrScanFrameImageView.frame.size.height+40);
}

-(void)createScanFrameViewWithFrame:(CGRect)tempViewFrame;
{
    UIImageView * tempImageView = [[UIImageView alloc] initWithFrame:tempViewFrame];
    tempImageView.alpha = 0.5;
    tempImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tempImageView];
    
}

- (void)CreateLightButton
{
    UIButton * LightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LightBtn.frame = CGRectMake(0, 0, 65, 87);
    LightBtn.center = CGPointMake(self.view.center.x,self.view.frame.size.height-120);
    [LightBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [LightBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_scan_off"] forState:UIControlStateSelected];
    
    [LightBtn addTarget:self action:@selector(LightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LightBtn];
    
}

-(void)LightClick:(UIButton *)lightBtn
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    lightBtn.selected = !lightBtn.selected;
    if (device.torchMode==AVCaptureTorchModeOff) {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        
    }else {
        //闪光灯关闭
        
        [device setTorchMode:AVCaptureTorchModeOff];
    }
}

-(BOOL)createScanAVCaptureSession
{
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“号簿助手”打开相机访问权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        return NO;
        
    }
    
    
    NSError * error;
    //初始化捕捉设备
    AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //用captureDevice创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        return NO;
    }
    
    //创建媒体输出流
    AVCaptureMetadataOutput * metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //设置代理
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //实例化捕捉回话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //输入流加入到回话
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
    }
    
    //媒体输出流 加入会话
    if ([_captureSession canAddOutput:metadataOutput]) {
        [_captureSession addOutput:metadataOutput];
    }
    
    
    //设置输出类型
    metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //设置区域大小 x,y 需要对调   w，h需要对调
    CGFloat view_H = Device_Height-64;
    [metadataOutput setRectOfInterest:CGRectMake(self.scanRect.origin.y/view_H, self.scanRect.origin.x/Device_Width, self.scanRect.size.height/view_H, self.scanRect.size.width/Device_Width)];
    
    //预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    _videoPreviewLayer.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_captureSession startRunning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_captureSession stopRunning];
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //闪光灯关闭
    if (device.torchMode==AVCaptureTorchModeOn)
    {
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_captureSession stopRunning];
    NSString * stringValue;
    self.isScanning = NO;
    if (metadataObjects.count>0) {
        
        AVMetadataMachineReadableCodeObject * metadataObject= metadataObjects.firstObject;
        stringValue = metadataObject.stringValue;
        self.isScanning = YES;
    }
    [self.navigationController popViewControllerAnimated:NO];
    if (self.ScanResult) {
        
        self.ScanResult(stringValue,self.isScanning);
    }
    

    NSLog(@"%@",stringValue);
}


-(void)navItemClick:(UIButton *)btn
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark ImagePickerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [SVProgressHUD show];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        ZBarReaderController * imageReader = [ZBarReaderController new];
        [imageReader.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
        
        id<NSFastEnumeration> result = [imageReader scanImage:image.CGImage];
        
        ZBarSymbol *symbol = nil;
        for (symbol in result) {
            //ZBLog(@"%@", symbol.data);
            break;
        }
        if (!symbol.data) {
            
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法识别此图片！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [al show];
            
        }
        else if (self.ScanResult) {
            NSString * str1 = symbol.data;
            
            if ([str1 canBeConvertedToEncoding:NSShiftJISStringEncoding])
            {
                str1 = [NSString stringWithCString:[symbol.data cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
                
                if (str1 == nil) {
                    str1 = symbol.data;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            self.ScanResult(str1,YES);
        }
        [SVProgressHUD dismiss];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
