//
//  HB_MyCardQRCodeVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/26.
//
//

#import "HB_MyCardQRCodeVc.h"
#import "HB_BusinessCardParser.h"
#import "HB_ShareByQRcodeMoreView.h"
#import "HB_WebviewCtr.h"
#import "HB_styleColorSelectView.h"

#import "HB_QRimagedeal.h"
#import "HB_httpRequestNew.h"
#import "SettingInfo.h"
#import "HB_share.h"
#import "SVProgressHUD.h"
#import "HB_contactCloudReq.h"
#import "HB_cardsDealtool.h"
#import "ContactProtoToContactModel.h"
@interface HB_MyCardQRCodeVc ()<shareByQRcodeMoreViewDelegate,UIAlertViewDelegate,styleColorSelectDelegate,UIActionSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CardQRImageCollectionCelldelegate>

@property(nonatomic,strong)UICollectionView * ImagecolloectionView;

@property(nonatomic,strong)UIPageControl * pagectrl;


@property(nonatomic,strong)HB_ShareByQRcodeMoreView * moreView;

@property(nonatomic,copy)UIImage * currentImage;

@property(nonatomic,strong)HB_styleColorSelectView * styleSelectview;

@property(nonatomic,retain)UISegmentedControl * segmentedCtrl;

@property(nonatomic,retain)UILabel * remindeLabel;

@property (nonatomic,strong)NSString * SelectColorHex;

@property(nonatomic,retain)UIButton * CreatBtn;

//@property(nonatomic,retain)NSString * CardUrl;
@end

@implementation HB_MyCardQRCodeVc

-(void)dealloc
{
//    [_QRImageView release];
//    [_nameLabel release];
//    [_CardBgview release];
//    [_showPhoneNum release];
    [_moreView release];
    [_styleSelectview release];
    [_segmentedCtrl release];
    [_remindeLabel release];
    [_pagectrl release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loaddata];
    if (self.ContactModelArr.count<=0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有名片数据！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    [self setupNavigationBar];
    
    
    [self setupImageCollectionView];
    
    [self stepSegmentedCtrl];
    [self setupInterface];
    
    [self getMyCardOpenStatu];
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.ContactModelArr.count<=0) {
        return;
    }
     self.pagectrl.numberOfPages = self.ContactModelArr.count;
    [self hiddenTabBar];
    [self RefreshView];
   
}
-(void)loaddata
{
    self.ContactModelArr = [NSArray arrayWithArray:[HB_cardsDealtool getCardsdata]];
    
    [self.ImagecolloectionView reloadData];
    
    self.Urldic  = (NSMutableDictionary *)[HB_cardsDealtool getCardsUrldic];
}

-(void)setupImageCollectionView
{
    //创建布局类
    UICollectionViewFlowLayout * collectionlayout = [[UICollectionViewFlowLayout alloc] init];
    collectionlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //行间距（固定设定）
    collectionlayout.minimumLineSpacing = 0;
    //列间距
    collectionlayout.minimumInteritemSpacing = 0;
    
    
#pragma mark -alloc CollectionView
    CGFloat collectionView_W=SCREEN_WIDTH;
    CGFloat collectionView_H=300;
    CGFloat collectionView_X=0;
    CGFloat collectionView_Y=60;
    CGRect rect = CGRectMake(collectionView_X, collectionView_Y, collectionView_W, collectionView_H);
    self.ImagecolloectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:collectionlayout];
    
    self.ImagecolloectionView.pagingEnabled = YES;
    self.ImagecolloectionView.delegate = self;
    self.ImagecolloectionView.dataSource = self;
    
    self.ImagecolloectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.ImagecolloectionView];
    //注册cell
    [self.ImagecolloectionView registerClass:[HB_CardQRImageCollectionCell class] forCellWithReuseIdentifier:@"CardQRImageCollectionCell"];
    [collectionlayout release];
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

    CGFloat remiindeLabel_Y = self.ImagecolloectionView.frame.origin.y+self.ImagecolloectionView.frame.size.height + 15;
    self.remindeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, remiindeLabel_Y, Device_Width-30, 25)];
    self.remindeLabel.text = @"让对方扫描上方的二维码来获取您分享的名片";
    self.remindeLabel.textAlignment = NSTextAlignmentCenter;
    self.remindeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.remindeLabel];
    
    
    //pagecontrol
    self.pagectrl = [[UIPageControl alloc] init];
    self.pagectrl.bounds = CGRectMake(0, 0, 100, 20);
    self.pagectrl.center = CGPointMake(Device_Width/2, remiindeLabel_Y+self.remindeLabel.frame.size.height +20);
//    [self.pagectrl setValue:[UIImage imageNamed:@"未选中"] forKey:@"pageImage"];
//    [self.pagectrl setValue:[UIImage imageNamed:@"选中"] forKey:@"currentPageImage"];
    self.pagectrl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pagectrl.currentPageIndicatorTintColor = COLOR_A;
    [self.view addSubview:self.pagectrl];
    
    
    NSArray * nameArr = @[@"发送给好友",@"关于二维码"];//,@"更换样式"
    self.moreView = [[HB_ShareByQRcodeMoreView alloc] initWithNames:nameArr andStyle:More_View_Style_Right1];
    self.moreView.hidden = YES; //默认隐藏
    self.moreView.delegate = self;
    [self.view addSubview:self.moreView];
    
    
    CGFloat CreatBtn_Y = Device_Height -64 -20 -45;
    self.CreatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.CreatBtn.frame = CGRectMake(20, CreatBtn_Y, Device_Width-40, 45);
    self.CreatBtn.backgroundColor = COLOR_A;
    self.CreatBtn.layer.cornerRadius = 3;
    [self.CreatBtn setTitle:@"点击创建活码" forState:UIControlStateNormal];
    [self.CreatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.CreatBtn addTarget:self action:@selector(CreatClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.CreatBtn];
}

-(void)stepSegmentedCtrl
{
    self.segmentedArray = [NSArray arrayWithObjects:@"名片静态码",@"名片活码", nil];
    self.segmentedCtrl = [[UISegmentedControl alloc] initWithItems:self.segmentedArray];
    
    
    CGFloat seg_Y = 32;
    CGFloat seg_W = 200.f;
    CGFloat seg_H = 28.f;
    CGFloat seg_X = (Device_Width-seg_W)/2;
    
    self.segmentedCtrl.frame = CGRectMake(seg_X, seg_Y, seg_W, seg_H);
    self.segmentedCtrl.selectedSegmentIndex  = 0;
    self.segmentedCtrl.momentary = NO;
    self.segmentedCtrl.tintColor = COLOR_B;
    self.segmentedCtrl.layer.cornerRadius = (seg_H-1)/2;
    self.segmentedCtrl.clipsToBounds = YES;
    
    
    self.segmentedCtrl.layer.borderWidth = 1;
    self.segmentedCtrl.layer.borderColor = COLOR_B.CGColor;
    [self.segmentedCtrl addTarget:self action:@selector(segmentedCtrlClick:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedCtrl];
    
}
#pragma mark SegMentedClick
-(void)segmentedCtrlClick:(UISegmentedControl *)seg
{
    [self.ImagecolloectionView reloadData];
    [self RefreshView];
}

-(void)RefreshView
{
    if (self.segmentedCtrl.selectedSegmentIndex == 0) {
        self.CreatBtn.hidden = YES;
        if ([self canToQRcode]) {
            
            self.remindeLabel.text = @"让对方扫描上方的二维码来获取您分享的名片";
            
        }
        else
        {
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本张名片内容过少，建议先前往名片编辑信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [al release];
        }
    }
    else if (self.segmentedCtrl.selectedSegmentIndex == 1)
    {
        HB_ContactModel * model = [self.ContactModelArr objectAtIndex:self.CurrentIndex];
        NSString * url = [self.Urldic objectForKey:[NSString stringWithFormat:@"%d",model.cardid]];
        if (url.length)
        {
            self.remindeLabel.text = @"让对方扫描上方的二维码来获取您分享的名片";
            
            self.CreatBtn.hidden = YES;
        }
        else
        {
            self.CreatBtn.hidden = NO;
            self.remindeLabel.text = @"";
        }
    }
}

-(void)getMyCardOpenStatu
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    
    NSMutableDictionary * tempUrldic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (HB_ContactModel * model in self.ContactModelArr) {
        if (model.cardid>0) {
            NSDictionary * dic = [req SyncisOpenMyCardwithid:model.cardid];
            if (![dic objectForKey:@"error"]) {
                NSString * str =[dic objectForKey:@"cardUrl"];
                if (str.length) {
                    [tempUrldic setObject:str forKey:[NSString stringWithFormat:@"%d",model.cardid]];
                }
            }
        }
    }
    
    self.Urldic  = [NSMutableDictionary dictionaryWithDictionary:tempUrldic];
    
    [self.ImagecolloectionView reloadData];
    
    [HB_cardsDealtool saveCardsUrlWithdictionary:tempUrldic];
    
}

//-(void)showMyCardlocaCode
//{
//   
//}

//-(void)showMyCardDynamicsCodeWithIsOpen:(BOOL)isOpen
//{
//    
//    if (isOpen && self.CardUrl.length) {
//        HB_BusinessCardParser  * parser = [[HB_BusinessCardParser alloc] init];
//        
//        self.currentImage = [parser getQRImageBy:self.CardUrl];
//        
//        self.PhoneLabel.text = self.CardUrl;
//        self.remindeLabel.text = @"让对方扫描上方的二维码来获取您分享的名片";
//        
//        self.CreatBtn.hidden = YES;
//    }
//    else
//    {
//        self.CreatBtn.hidden = NO;
//        [SettingInfo removeCardShareUrl];
//        self.PhoneLabel.text = @"尚未生成名片活码";
//        self.currentImage = [UIImage imageNamed:@"二维码-名片活码-尚未生成icon"];
//        self.remindeLabel.text = @"";
//    }
//    self.nameLabel.text = [NSString stringWithFormat:@"%@%@",self.shareModel.lastName?self.shareModel.lastName:@"",self.shareModel.firstName?self.shareModel.firstName:@""];
//    
//    self.QRImageView.image = nil;
//    self.QRImageView.image = [self imageWithSelectHexImage:self.currentImage];
//    
//}

-(UIImage *)imageWithSelectHexImage:(UIImage *)image
{
    UIImage * tempImage = image;
    if (self.SelectColorHex) {
        
        tempImage = [HB_QRimagedeal QRCodeImageStyleChange:self.currentImage toColorHex:self.SelectColorHex];
    }
    return tempImage;
    
}



#pragma mark - collectionDelegate

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每一个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH,300);
}


#pragma mark - CollectiondataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ContactModelArr.count;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HB_CardQRImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardQRImageCollectionCell" forIndexPath:indexPath];
    cell.delegate = self;
    HB_ContactModel * model =[self.ContactModelArr objectAtIndex:indexPath.row];
    cell.contactmodel =model;
    cell.UrlString = [self.Urldic objectForKey:[NSString stringWithFormat:@"%d",model.cardid]];
    cell.QRimageType = self.segmentedCtrl.selectedSegmentIndex;
    
    return cell;
}
#pragma mark - scrollviewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //手动滑
    [self computeCurrentIndex];
    
    [self RefreshView];
}

-(void)computeCurrentIndex
{
    CGPoint pInView = [self.view convertPoint:self.ImagecolloectionView.center toView:self.ImagecolloectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.ImagecolloectionView indexPathForItemAtPoint:pInView];
    
    self.CurrentIndex = indexPathNow.row;
    
    self.pagectrl.currentPage = indexPathNow.row;
}

#pragma mark NavMoreDelegate
-(void)shareByQRcodeMoreView:(HB_ShareByQRcodeMoreView *)moreView WithselectIndex:(NSInteger)index
{
    [self hiddenFloatingLayer];
    switch (index) {
        case 0://发送给好友
        {
             HB_share * share = [[[HB_share alloc] init] autorelease];
            NSInteger current = self.segmentedCtrl.selectedSegmentIndex;
            
            if (current == 0) {
                HB_CardQRImageCollectionCell * cell = (HB_CardQRImageCollectionCell* )[self.ImagecolloectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.CurrentIndex inSection:0]];
                [share imageShare:[self imageWithUIView:cell.CardBgview] withVc:self withSharePlatForms:nil];
            }
            else if (current == 1)
            {
                HB_ContactModel * model = [self.ContactModelArr objectAtIndex:self.CurrentIndex];
                NSString * currenCardurl = [self.Urldic objectForKey:[NSString stringWithFormat:@"%d",model.cardid]];
                
                NSArray * arr = @[UMShareToWechatSession,UMShareToQQ,UMShareToYXSession,UMShareToSms,UMShareToEmail];
                NSString * title = @"云名片分享";
                NSString * text = [NSString stringWithFormat:@"【号簿助手】你的好友 %@ 给你分享了名片，请访问 %@ 进行查看。温馨提示：请认准号簿助手官方网址pim.189.cn ，勿轻信其他链接。",[HB_contactCloudReq getCloudShareName],currenCardurl];
                UIImage * image = [UIImage imageNamed:@"官方图标"];
                [share shareWithCurrentVc:self andTitle:title andText:text andUrl:currenCardurl andImage:image andSharePlatForms:arr];
            }
            
            
        }
            break;
//        case 1://更换样式
//        {
//            NSInteger currentIndex = self.segmentedCtrl.selectedSegmentIndex;
//            if (currentIndex == 1 && !self.isOpenMyCard) {
//                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//                [SVProgressHUD showErrorWithStatus:@"尚未生成"];
////                UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未生成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
////                [al show];
////                [al release];
//                return;
//            }
//            self.styleSelectview = [[HB_styleColorSelectView alloc] init];
//            self.styleSelectview.delegate = self;
//            [self.view addSubview: self.styleSelectview];
//        }
//            break;
        case 1://关于
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
    HB_ContactModel * model  = [self.ContactModelArr objectAtIndex:self.CurrentIndex];
    if (model.firstName.length ||model.lastName.length ||model.phoneArr.count ||model.emailArr.count) {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            HB_CardQRImageCollectionCell * cell = (HB_CardQRImageCollectionCell* )[self.ImagecolloectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.CurrentIndex inSection:0]];
            UIImageWriteToSavedPhotosAlbum([self imageWithUIView:cell.CardBgview], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
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

#pragma mark CardQRImageCollectionCelldelegate
-(void)celllongPressClick
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
    [sheet showInView:self.view];
    [sheet release];
}

#pragma mark styleDelegate
-(void)styleColorSelectView:(HB_styleColorSelectView *)styleColorSelectView selectedColorHex:(NSString *)HexString
{
//    self.SelectColorHex = HexString;
//    self.QRImageView.image=nil;
//    self.QRImageView.image = [HB_QRimagedeal QRCodeImageStyleChange:self.currentImage toColorHex:HexString];
}

-(void)hiddenFloatingLayer
{
    self.moreView.hidden = YES;
    [self.styleSelectview remove];
}


-(instancetype)initWithContactModel:(HB_ContactModel *)model
{
    self = [super init];
    if (self) {
       
        
    }
    return self;
}

-(void)CreatClick:(UIButton *)btn
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    self.view.userInteractionEnabled = NO;
    HB_ContactModel * model = [self.ContactModelArr objectAtIndex:self.CurrentIndex];
    
    Contact * memCard = [[ContactProtoToContactModel shareManager] ContactModelmemMycard:model];
    [req UpdateMyCardWithType:0 andContact:memCard Result:^(BOOL isSucess, int32_t sid, NSInteger resultCode, NSInteger recCode, NSString *url) {
        
        self.view.userInteractionEnabled = YES;
        if (!isSucess) {
            
            [SVProgressHUD showErrorWithStatus:@"创建失败"];
            return ;
        }
        [self.Urldic setObject:url forKey:[NSString stringWithFormat:@"%d",model.cardid]];
        
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        
        [self segmentedCtrlClick:self.segmentedCtrl];
        
        [HB_cardsDealtool saveCardsUrlWithdictionary:self.Urldic];
        
        
        
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
