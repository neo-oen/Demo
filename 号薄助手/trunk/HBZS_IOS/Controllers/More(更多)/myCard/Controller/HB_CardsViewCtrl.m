//
//  HB_CardsViewCtrl.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/5/12.
//
//

#import "HB_CardsViewCtrl.h"
#import "HB_ContactModel.h"

#import "ContactProto.pb.h"
#import "ContactProtoToContactModel.h"

#import "HB_editMyCardVc.h"
#import "HB_httpRequestNew.h"
#import "HB_MyCardCloudVc.h"

#import "SVProgressHUD.h"
@interface HB_CardsViewCtrl ()<UIActionSheetDelegate,UIAlertViewDelegate,shareByQRcodeMoreViewDelegate>

@end

@implementation HB_CardsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //导航栏底部细线隐藏
    
    
    UIImage *blankImage = [[UIImage alloc]init];
    self.navigationController.navigationBar.shadowImage = blankImage;
    [blankImage release];
   
    
    
    [self setUpCollection];
    [self setUpNav];
    [self setUpleftAndRightBtn];
    [self setUpRemidView];
    
    [self hiddenTabBar];
    
    [self initdata];
    
    [self checkAndUploadLocalCard]; 
}

-(void)setupMorelistView
{
    NSArray * nameArr = @[@"添加新名片",@"分享本名片",@"删除本名片",@"设为封面"];
    self.moreView = [[HB_ShareByQRcodeMoreView alloc] initWithNames:nameArr andStyle:More_View_Style_Right1];
    self.moreView.hidden = YES; //默认隐藏
    self.moreView.delegate = self;
    [self.view addSubview:self.moreView];
    
}
-(void)dealloc
{
    [_mainCollectionView release];
    [_moreView release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self hiddenGobtn];
    
    UIView *bgView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    if (self.CardsdataArr.count == 0) {
        bgView.alpha=1;
    }
    else{
        bgView.alpha=0;
    }
    
    
    
       
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reComputeCurrentalpth];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView *bgView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    
    bgView.alpha=1;
    
    self.moreView.hidden = YES;
    
}

-(void)initdata
{
    self.CardsdataArr =  [NSMutableArray arrayWithCapacity:0];
    [self.CardsdataArr addObjectsFromArray:[HB_cardsDealtool getCardsdata]];
    [self.mainCollectionView reloadData];
    
    [self hiddenGobtn];
    
    [self setViewWithDataCount];
}


-(void)setUpRemidView
{
    self.remindLabel = [[UILabel alloc] init];
    self.remindLabel.bounds = CGRectMake(0, 0, 240, 80);
    self.remindLabel.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2-64);
    
    self.remindLabel.textColor = [UIColor grayColor];
    self.remindLabel.font = [UIFont boldSystemFontOfSize:30];
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.hidden = YES;
    self.remindLabel.text = @"无名片数据";
    [self.view addSubview:self.remindLabel];
}
-(void)setUpCollection
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
    CGFloat collectionView_H=SCREEN_HEIGHT;
    CGFloat collectionView_X=0;
    CGFloat collectionView_Y=-64;
    CGRect rect = CGRectMake(collectionView_X, collectionView_Y, collectionView_W, collectionView_H);
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:collectionlayout];
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    self.mainCollectionView.pagingEnabled = YES;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    
    
    [self.view addSubview:self.mainCollectionView];
    //注册cell
    [self.mainCollectionView registerClass:[HB_CardCollectionCell class] forCellWithReuseIdentifier:@"CardCollectCell"];
    [collectionlayout release];
    
}

-(void)setUpNav
{
    NSArray * navitemImageNames = @[@"heard_cloud",@"编辑",@"添加"];
    NSMutableArray * items = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i<navitemImageNames.count; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 25, 25)];
        btn.exclusiveTouch = YES;
        [btn setImage:[UIImage imageNamed:[navitemImageNames objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        
        [items addObject:item];
        if (i<navitemImageNames.count-1) {
            
            UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spaceItem.width = 20;
            [items addObject:spaceItem];
            [spaceItem release];
        }
        [item release];
    }
    
    
    self.navigationItem.rightBarButtonItems = items;
    
//    [self setupMorelistView];
}

-(void)setUpleftAndRightBtn
{
    CGFloat y = 264/2-13.5-64;
    CGFloat w = 27;
    CGFloat h = 27;
    self.goLeftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goLeftbtn.frame = CGRectMake(20, y, w, h);
    self.goLeftbtn.tag = 1;
    [self.goLeftbtn addTarget:self action:@selector(gobtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goLeftbtn];
    
    self.goRigthbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goRigthbtn.frame = CGRectMake(self.view.frame.size.width-20-w, y, w, h);
    self.goRigthbtn.tag = 2;
    [self.goRigthbtn addTarget:self action:@selector(gobtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goRigthbtn];
    
    
    [self.goLeftbtn setBackgroundImage:[UIImage imageNamed:@"名片背景左箭头"] forState:UIControlStateNormal];
    [self.goRigthbtn setBackgroundImage:[UIImage imageNamed:@"名片背景右箭头"] forState:UIControlStateNormal];
}


#pragma mark GoBtnClick:
-(void)gobtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1://上一张
        {
            [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        }
            break;
        case 2://下一张
        {
            [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)hiddenGobtn
{
    if (self.currentPage >=self.CardsdataArr.count - 1) {
        self.goRigthbtn.hidden = YES;
    }
    else
    {
        self.goRigthbtn.hidden = NO;
    }
    
    if (self.currentPage<=0) {
        self.goLeftbtn.hidden = YES;
    }
    else
    {
        self.goLeftbtn.hidden = NO;
    }
}

-(void)computeCurrentPage
{
    CGPoint pInView = [self.view convertPoint:self.mainCollectionView.center toView:self.mainCollectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.mainCollectionView indexPathForItemAtPoint:pInView];
    
    self.currentPage = indexPathNow.row;
}

#pragma mark - collectionDelegate

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每一个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
}


#pragma mark - CollectiondataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.CardsdataArr.count;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HB_CardCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCollectCell" forIndexPath:indexPath];
    cell.delegate = self;
    NSLog(@"1------%ld",indexPath.row);
    HB_ContactModel * model =[self.CardsdataArr objectAtIndex:indexPath.row];
    cell.contactModel = model;
    NSLog(@"2------%ld",indexPath.row);
    cell.cellIndex = indexPath.row;
    return cell;
}
#pragma mark - scrollviewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //手动滑
    [self computeCurrentPage];
    [self hiddenGobtn];
    
    [self reComputeCurrentalpth];

   
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //点击滑动
    [self computeCurrentPage];
    [self hiddenGobtn];
    
    
    [self reComputeCurrentalpth];

}

-(void)checkAndUploadLocalCard
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
        for (HB_ContactModel * model in self.CardsdataArr) {
            if (model.cardid<=0) {
                Contact * contact = [[ContactProtoToContactModel shareManager] ContactModelmemMycard:model];
                int cardid = [req SyncUplodaCardMycardWithType:1 andContact:contact];
                if (cardid>= 0 ) {
                    model.cardid = cardid;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [req upCardPortrait:model];
                    });
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HB_cardsDealtool saveCardsdataWithArr:self.CardsdataArr];
            
            [self downloadCard];
        });
        
    });
    
    
   

}
-(void)downloadCard
{
   
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    [req getMyCardformServerResult:^(BOOL isisSuccess) {
        [SVProgressHUD dismiss];
        if (!isisSuccess) {
            return ;
        }
        
        [self initdata];
        
    }];
}

#pragma mark — navigationBarButtonClick
-(void)navigationBarButtonClick:(UIButton *)btn{
    
    switch (btn.tag-100) {
        case 0://云名片
        {
            if (self.CardsdataArr.count == 0) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先创建!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }

            
            HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init] ;
            
            HB_ContactModel * model = [self.CardsdataArr objectAtIndex:self.currentPage];
            
            [req isOpenMyCardShareWithId:model.cardid Result:^(BOOL isSuccess, NSInteger isOpenMycard) {
                

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (!isSuccess) {
                        UIAlertView * al =  [[UIAlertView alloc] initWithTitle:nil message:@"请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [al show];
                        [al release];
                        return ;
                    }
                    if (isOpenMycard) {
                        NSLog(@"云端已创建过云名片");
                        UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:@"云名片操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看云名片",@"删除云名片", nil];
                        
                        [sheet showInView:self.view];
                        [sheet release];
                    }
                    else
                    {
                        NSLog(@"没创建过云名片");
                        
                        UIAlertView * al =  [[UIAlertView alloc] initWithTitle:@"创建云名片" message:@"云名片可方便您与其他人交换个人名片信息，创建后其他人可以通过网络查询到您的云名片。您也可以通过微信、QQ等工具将云名片发给你的好友。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"创建", nil];
                        al.tag = 101;
                        [al show];
                        [al release];
                        
                    }
                });
                
            }];
            
            
        }
            break;
        case 1://编辑
        {
            if (self.CardsdataArr.count==0) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先创建!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            HB_editMyCardVc * CardeditController = [[HB_editMyCardVc alloc] init];
            CardeditController.contactModel = [self.CardsdataArr objectAtIndex:self.currentPage];
            
            CardeditController.Cardindex = self.currentPage+1;
            CardeditController.editType = Edit_edit;
            CardeditController.delegate = self;
            CardeditController.title=@"编辑名片";
            UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:CardeditController];
            [self presentViewController:nav animated:YES completion:nil];
            [CardeditController release];
            [nav release];
        }
            break;
        case 2://添加
        {
            if (self.CardsdataArr.count>=5) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能添加5张名片" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                break;
            }
            
            HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
            
            [req getCardCountFormServerResult:^(BOOL isSuccess, NSInteger Cardcount) {
                if (isSuccess) {
                    if (Cardcount<5) {
                        HB_editMyCardVc * CardeditController = [[HB_editMyCardVc alloc] init];
                        //            CardeditController.contactModel = [self.CardsdataArr objectAtIndex:self.currentPage];
                        CardeditController.title=@"添加名片";
                        CardeditController.editType = Edit_AddNew;
                        CardeditController.Cardindex = Cardcount+1;
                        CardeditController.delegate = self;
                        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:CardeditController];
                        [self presentViewController:nav animated:YES completion:nil];
                        [CardeditController release];
                        [nav release];
                    }
                    else
                    {
                        //云端已经满5个名片
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"云端已存在5张名片，建议您退出名片界面后再重新进入！" preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];

                    }
                }
                else
                {
                    //请求失败
                
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"获取数据失败，请检查您的网络或者稍后再试！" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
            
            [req release];
            
        }
            break;
        default:
            break;
    }
    return;
    
    switch (btn.tag-100) {
        case 0:// 更多
        {
            self.moreView.hidden = !self.moreView.hidden;
        }
            break;
        case 1://编辑
        {
            
            if (self.CardsdataArr.count==0) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先创建!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            HB_editMyCardVc * CardeditController = [[HB_editMyCardVc alloc] init];
            CardeditController.contactModel = [self.CardsdataArr objectAtIndex:self.currentPage];
            
            CardeditController.editType = Edit_edit;
            CardeditController.delegate = self;
            CardeditController.title=@"编辑名片";
            UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:CardeditController];
            [self presentViewController:nav animated:YES completion:nil];
            [CardeditController release];
            [nav release];
        }
            break;
            
        default:
            break;
    }
    
    return;
}

#pragma mark cardCollectionCelldelegate
-(void)CardCollectionCell:(HB_CardCollectionCell *)cell contactType:(enum_cardColCellClick)type NumOrAdress:(NSString *)NOAString
{
    switch (type) {
        case card_collectionCell_Call:
        {
            [self dialPhone:NOAString contactID:-1 Called:nil];
        }
            break;
        case card_collectionCell_Message:
        {
            [self doSendMessage:@[NOAString]];
 
        }
            break;
        case card_collectionCell_Email:
        {
            [self sendEmailWithEmailArr:@[NOAString]];
        }
            break;
        default:
            break;
    }
}

-(void)CardCollectionCellDidScroll:(UIScrollView *)scrollView
{
    [self computeIconFrameAndNavigationBarFrameWithScrollView:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        //查看
        HB_ContactModel * model = [self.CardsdataArr objectAtIndex:self.currentPage];
        [self checkCloudCardWithUrl:[HB_cardsDealtool getOneCardUrlWithid:model.cardid]];
        
    }
    else if (buttonIndex == 1)
    {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"警告" message:@"云名片删除后，其他人将无法再访问到您的名片，您确定要删除吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
        al.tag = 102;
        [al show];
        [al release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //创建云名片
        if (alertView.tag == 101) {
            [self UpdataMycardWithtype:0];
        }
        else if (alertView.tag == 102)
        {
            [self UpdataMycardWithtype:2];
        }
        
        
    }
}

-(void)UpdataMycardWithtype:(NSInteger)type
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
//    [self setCloudEnableUser:NO];
    
    Contact * cardcontact = [[ContactProtoToContactModel shareManager] ContactModelmemMycard:[self.CardsdataArr objectAtIndex:self.currentPage]];
    [req UpdateMyCardWithType:type andContact:cardcontact Result:^(BOOL isSucess, int32_t sid, NSInteger resultCode, NSInteger recCode, NSString *url) {
        
//        if (!_isVisible) {
//            return ;
//        }
        
        if (!isSucess) {
//            [self setCloudEnableUser:YES];
            UIAlertView * al =  [[UIAlertView alloc] initWithTitle:nil message:@"请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [al release];
            return ;
        }
        if (type == 2) {
//            self.ClouddBtn_nav.userInteractionEnabled = YES;
            if (resultCode == 0) {
                
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"删除完成"];
                
                //删除云名片地址
                [SettingInfo removeCardShareUrl];
            }
            else
            {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
        }
        else if (type == 0) {
            //保存云名片地址
//            [SettingInfo saveCardShareUrl:shareUrl];
            
//            [self setCloudEnableUser:YES];
            
            [self checkCloudCardWithUrl:url];
        }
    }];
}

-(void)checkCloudCardWithUrl:(NSString *)Url
{
    HB_MyCardCloudVc * web = [[HB_MyCardCloudVc alloc] init];
    web.url = [NSURL URLWithString:Url];
    web.mycardModel = [self.CardsdataArr objectAtIndex:self.currentPage];
    web.titleName = @"我的云名片";
    [self.navigationController pushViewController:web animated:YES];
    
    [web release];
}

-(void)reComputeCurrentalpth
{
    HB_CardCollectionCell * cell = (HB_CardCollectionCell*)[self.mainCollectionView  cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0]];
    
    [self computeIconFrameAndNavigationBarFrameWithScrollView:cell.tableView];
}
-(void)computeIconFrameAndNavigationBarFrameWithScrollView:(UIScrollView *)scrollView{
//        if (scrollView.contentOffset.y < (-ICON_Height)) {
//            CGRect frame=self.headerIconView.frame;
//            //计算出比例，便于下方计算icon放大的倍数
//            float a = -scrollView.contentOffset.y/frame.size.height;
//            CGFloat iconImageView_W = frame.size.width * a;
//            CGFloat iconImageView_H = frame.size.height * a;
//            CGFloat iconImageView_X = -(frame.size.width * a - SCREEN_WIDTH)*0.5;
//            CGFloat iconImageView_Y = scrollView.contentOffset.y;
//            self.headerIconView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);_backgroundView
//        }
//    UIView *bgView = [self.navigationController.navigationBar valueForKey:@"_UIBarBackground"];
//    bgView.alpha = (ICON_Height + scrollView.contentOffset.y)/(ICON_Height - 64);
    UIView *bgView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    
        bgView.alpha=(scrollView.contentOffset.y + ICON_Height)/(ICON_Height-64);
    
}

-(void)setViewWithDataCount
{
    UIView *bgView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    if (self.CardsdataArr.count == 0)
    {
        self.remindLabel.hidden = NO;
        bgView.alpha=1;
    }
    else
    {
        self.remindLabel.hidden = YES;
        bgView.alpha = 0;
    }
}


#pragma editMyCardDelegate
-(void)editFinishWithType:(EditType)type
{
//    HB_ContactModel * model = [self.CardsdataArr objectAtIndex:1];
//    
//    return;
    
    if (type==Edit_edit) {
        [HB_cardsDealtool saveCardsdataWithArr:self.CardsdataArr];
    }
    [self initdata];
    if (self.CardsdataArr.count) {
        if (type == Edit_AddNew) {
            [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.CardsdataArr.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
    }
    
}

#pragma mark shareByQRcodeMoreViewDelegate
-(void)shareByQRcodeMoreView:(HB_ShareByQRcodeMoreView *)moreView WithselectIndex:(NSInteger)index
{
    
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
