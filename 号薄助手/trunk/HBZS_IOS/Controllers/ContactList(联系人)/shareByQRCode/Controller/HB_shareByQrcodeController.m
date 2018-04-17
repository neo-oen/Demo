//
//  HB_shareByQrcodeController.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/13.
//
//

#import "HB_shareByQrcodeController.h"
#import "HB_BusinessCardParser.h"
#import "HB_ShareByQRcodeMoreView.h"
#import "HB_styleColorSelectView.h"
#import "HB_QRimagedeal.h"
#import "HB_WebviewCtr.h"

@interface HB_shareByQrcodeController ()<shareByQRcodeMoreViewDelegate,UIAlertViewDelegate,styleColorSelectDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)UIImageView * QRImageView;

@property(nonatomic,strong)UILabel * nameLabel;

@property(nonatomic,strong)UILabel * PhoneLabel;

@property(nonatomic,strong)UIView * CardBgview;

@property(nonatomic,strong)HB_ShareByQRcodeMoreView * moreView;

@property(nonatomic,copy)UIImage * currentImage;

@property(nonatomic,strong)HB_styleColorSelectView * styleSelectview;


@end

@implementation HB_shareByQrcodeController

-(void)dealloc
{
    [_QRImageView release];
    [_nameLabel release];
    [_CardBgview release];
    [_showPhoneNum release];
    [_moreView release];
    [_styleSelectview release];
    
    [super dealloc];
}

-(instancetype)initWithContactModel:(HB_ContactModel *)model
{
    self = [super init];
    if (self) {
        self.shareModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBar];
    [self setupInterface];

}


-(void)setupNavigationBar{
    //标题
    self.title=@"二维码分享";
    
    //更多按钮
    UIButton * RightMore = [UIButton buttonWithType:UIButtonTypeCustom];
    RightMore.frame = CGRectMake(0, 0, 20, 20);
    RightMore.exclusiveTouch = YES;
    [RightMore setImage:[UIImage imageNamed:@"更多_header"] forState:UIControlStateNormal];
    [RightMore addTarget:self action:@selector(navigationBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightMore];
    
}

-(void)navigationBarButtonClick
{
    self.moreView.hidden = !self.moreView.hidden;
    [self.styleSelectview remove];
}


-(void)setupInterface
{
    CGFloat CardBgview_w =Device_Width-80;
    _CardBgview = [[UIView alloc] initWithFrame:CGRectMake(40, Device_Height>480?60:30, CardBgview_w, 300)];
    [self.view addSubview:_CardBgview];
    
    UILongPressGestureRecognizer * LongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    LongPress.minimumPressDuration = 0.8;
    LongPress.numberOfTouchesRequired = 1;
    [_CardBgview addGestureRecognizer:LongPress];
    [LongPress release];
    
    CGFloat QRImageView_X = CardBgview_w/2-100;
    CGFloat QRImageView_Y = 30;
    CGFloat QRImageView_W = 200.f;
    CGFloat QRImageView_H = 200.f;
    self.QRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QRImageView_X, QRImageView_Y, QRImageView_W, QRImageView_H)];
    [_CardBgview addSubview:self.QRImageView];
    
    
    
    CGFloat NameLabel_W =200;
    CGFloat NameLabel_H =30;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NameLabel_W, NameLabel_H)];
    self.nameLabel.center = CGPointMake(CardBgview_w/2, QRImageView_Y+QRImageView_H+20);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 0;
    [_CardBgview addSubview:self.nameLabel];
    
    
    CGFloat PhoneLabel_H = self.nameLabel.frame.origin.y+NameLabel_H +3;
    self.PhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PhoneLabel_H, CardBgview_w,25)];
    self.PhoneLabel.textAlignment = NSTextAlignmentCenter;

    [_CardBgview addSubview:self.PhoneLabel];
    
    
    CGFloat remiindeLabel_Y = _CardBgview.frame.origin.y+_CardBgview.frame.size.height + 15;
    UILabel * remindeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, remiindeLabel_Y, Device_Width-30, 25)];
    remindeLabel.text = @"让对方扫描上方的二维码来获取您分享的名片";
    remindeLabel.textAlignment = NSTextAlignmentCenter;
    remindeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:remindeLabel];
    [remindeLabel release];
    
    
    NSArray * nameArr = @[@"更换样式",@"扫二维码",@"关于二维码"];
    self.moreView = [[HB_ShareByQRcodeMoreView alloc] initWithNames:nameArr andStyle:More_View_Style_Right1];
    self.moreView.hidden = YES; //默认隐藏
    self.moreView.delegate = self;
    [self.view addSubview:self.moreView];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    if ([self canToQRcode]) {
        
        self.showPhoneNum = [NSMutableString stringWithCapacity:0];
        self.currentImage = [HB_BusinessCardParser getQRcodeImageWithContact:self.shareModel ShowPhoneNum:self.showPhoneNum];
        self.QRImageView.image =self.currentImage;
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@%@",self.shareModel.lastName?self.shareModel.lastName:@"",self.shareModel.firstName?self.shareModel.firstName:@""];
        self.PhoneLabel.text = self.showPhoneNum?self.showPhoneNum:@"";
        
    }
    else
    {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该联系人无可分享数据！请先编辑" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
        [al release];
    }
    
    [self hiddenTabBar];
    
}

#pragma mark NavMoreDelegate
-(void)shareByQRcodeMoreView:(HB_ShareByQRcodeMoreView *)moreView WithselectIndex:(NSInteger)index
{
    [self hiddenFloatingLayer];
    switch (index) {
        case 0://更换样式
        {
            self.styleSelectview = [[HB_styleColorSelectView alloc] init];
            self.styleSelectview.delegate = self;
            [self.view addSubview: self.styleSelectview];
        }
            break;
        case 1://扫描
        {
            __unsafe_unretained HB_shareByQrcodeController * weakSelf = self;
            QRCodeScanViewController * ScanVc = [[QRCodeScanViewController alloc] initWithBlock:^(NSString * result, BOOL isSuccess) {
                //判断扫码的结果，进行对应的操作
                HB_ScanResultAnalyze * analyzer = [[[HB_ScanResultAnalyze alloc] initWithCurrentVc:weakSelf] autorelease];
                [analyzer AnalyzeResult:result];
            }];
            [self.navigationController pushViewController:ScanVc animated:YES];
            [ScanVc release];
        }
            break;
        case 2://关于
        {
            
            HB_WebviewCtr  * vc= [[HB_WebviewCtr alloc] init];
            vc.url  = [NSURL URLWithString:@"http://pim.189.cn/sharehelp/backintime.html"];
            vc.titleName = @"关于二维码名片";
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
        default:
            break;
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self hiddenFloatingLayer];
}


#pragma mark ---图片像素处理

-(BOOL)canToQRcode
{
    if (!self.shareModel.firstName.length && !self.shareModel.lastName.length && !self.shareModel.phoneArr.count && !self.shareModel.emailArr.count) {
        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImageWriteToSavedPhotosAlbum([self imageWithUIView:_CardBgview], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
            
        default:
            break;
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString * str = nil;
    if (error) {
        str = [NSString stringWithFormat:@"保存失败！"];
    }
    else{
        str = [NSString stringWithFormat:@"以保存至相册"];
    }
    UIAlertView * al =[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [al show];
    [al release];
}
- (UIImage*) imageWithUIView:(UIView*) view

{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
    
}




#pragma mark AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark styleDelegate
-(void)styleColorSelectView:(HB_styleColorSelectView *)styleColorSelectView selectedColorHex:(NSString *)HexString
{
    self.QRImageView.image=nil;
    self.QRImageView.image = [HB_QRimagedeal QRCodeImageStyleChange:self.currentImage toColorHex:HexString];
}

-(void)hiddenFloatingLayer
{
    self.moreView.hidden = YES;
    [self.styleSelectview remove];
}

-(void)longPressClick:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
        [sheet showInView:self.view];
        [sheet release];
        NSLog(@"===began");
    }
    else
    {
        NSLog(@"===end");
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
