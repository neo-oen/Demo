//
//  HB_ContactListVC.m
//  HBZS_iOS
//
//  Created by zimbean on 15/7/7.
//  Copyright (c) 2015年 shtianxin. All rights reserved.

/** 系统版本 */
#define  SYSTEM_VERSION [[UIDevice currentDevice].systemVersion intValue]

/**
 ‘全部联系人’‘未分组’‘管理分组’对应的groupID（自己构造的）
 */
typedef enum {
    KSelectViewAllContactGroupID = -100 , //‘全部联系人’对应的groupID（自己构造的）
    KSelectViewNoGroupID = -101 , //‘未分组’对应的groupID（自己构造的）
    KSelectViewGroupManageGroupID = -102 //‘管理分组’对应的groupID（自己构造的）
}KSelectViewCustomerGroupIDType;

#import "NSString+Extension.h"
#import "HB_ContactListVC.h"
#import "HB_ContactDataTool.h"
#import <AddressBook/AddressBook.h>
#import "HB_ContactCell.h"
#import "HB_ContactModel.h"
#import "HB_ContactSimpleModel.h"
#import "pinyin.h"
#import "HB_CenterLetterView.h"
#import "HB_addContactView.h"//新建联系人view
//#import "MyZbViewController.h"
#import "QRCodeScanViewController.h"//二维码扫描
#import "HB_TitleViewButton.h"//自定义头标题（按钮）
#import "HB_GroupSelectView.h"//头标题，选择分组视图
#import "HB_ContactDetailController.h"//新建联系人vc
#import "HB_SearchKeyBoardView.h"
#import "GroupData.h"
#import "HB_GroupManageVC.h"//分组管理
#import "HB_ContactInfoVC.h"//联系人详情
#import "HB_ContactSendTopTool.h"//联系人置顶的相关操作类
#import "SVProgressHUD.h"
//#import "HB_ContactMyCardVC.h"//‘我的名片’vc
#import "HB_ContactListDataSource.h"              //主tableView的DataSource
#import "HB_ContactSearchResultDataSource.h"      //搜索列表的dataSource
#import "HB_ContactKeyboardSearchDataSource.h"    //自定义键盘搜索列表的dataSource
#import "HB_BusinessCardParser.h"//二维码名片解析

#import "HB_ContactCloudShareVc.h"
#import "HB_BatchDeleteVc.h"

//#import "HB_MaCardInfoVc.h"
#import "ContactProtoToContactModel.h"
#import "SettingInfo.h"

#import "HB_cardsDealtool.h"
#import "HBZSAppDelegate.h"
@interface HB_ContactListVC () <UITableViewDelegate,
                                UISearchBarDelegate,
                                HB_addContactViewDelegate,
                                SearchKeyBoardViewDelegate,
                                HB_GroupSelectViewDelegate,HB_ContactDetailDelagete,UISearchDisplayDelegate,UITableViewDataSource>

#pragma mark - 控件

/** 导航栏左侧的BarButtonItem */
@property(nonatomic,retain)UIBarButtonItem * navLeftItem;
/** 导航栏左侧的button */
@property(nonatomic,retain)UIButton * navLeftBtn;
/** 导航栏右侧的搜索键盘BarButtonItem */
@property(nonatomic,retain)UIBarButtonItem * navRightKeyboardItem;
/** 导航栏右侧的搜索键盘button */
@property(nonatomic,retain)UIButton * navRightKeyboardBtn;
/** 导航栏中间标题按钮 */
@property(nonatomic,retain)HB_TitleViewButton * navTitleViewBtn;
/** 导航栏左侧按钮点击展示的浮层视图 */
@property(nonatomic,retain)HB_addContactView * leftView;
/** 导航栏右侧按钮点击展示的浮层视图 */
@property(nonatomic,retain)HB_SearchKeyBoardView * rightView;
/** 导航栏中间标题栏按钮点击展示的浮层视图 */
@property(nonatomic,retain)HB_GroupSelectView * middleGroupView;
/** 当tableView没有数据的时候，展示的提示语 */
@property(nonatomic,retain)UILabel *alertLabel;
/** 中央圆形搜索提示 */
@property(nonatomic,retain)HB_CenterLetterView *centerLetterView;
/** 联系人tableView */
@property(nonatomic,retain)UITableView *tableView;
/** 搜索框 */
@property(nonatomic,retain)UISearchBar *searchBar;
/** 搜索控制器 */
@property(nonatomic,retain)UISearchDisplayController *contactsearchDisplayController;
/** 自定义字母键盘搜索，搜索结果的tableView */
@property(nonatomic,retain)UITableView *keyboardSearchTableView;
/** 当前页面展示的tableView */
@property(nonatomic,retain)UITableView *currentTableView;


#pragma mark - 数据源

/**  所有联系人dataSource */
@property (nonatomic,retain) HB_ContactListDataSource * tableViewDataSource;
/**  搜索结果dataSource */
@property (nonatomic,retain) HB_ContactSearchResultDataSource * searchDataSource;
/**  自定义键盘搜索的dataSource */
@property(nonatomic,retain) HB_ContactKeyboardSearchDataSource * keyboardSearchDataSource;


@end

@implementation HB_ContactListVC

#pragma mark - life cycle
-(void)dealloc{
    [_navLeftItem release];
    [_navRightKeyboardItem release];
    [_leftView release];
    [_middleGroupView release];
    [_rightView release];
    [_alertLabel release];
    [_centerLetterView release];
    [_tableView release];
    [_searchBar release];
    [_contactsearchDisplayController release];
    [_keyboardSearchTableView release];
    [_tableViewDataSource release];
    [_searchDataSource release];
    [_keyboardSearchDataSource release];
    //移除监听
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"EndLoadingContactNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"EndLoadingContactNotification" object:nil];
    //导航栏上的按钮，以及头部视图
    self.navigationItem.leftBarButtonItem = self.navLeftItem;
    self.navigationItem.rightBarButtonItem = self.navRightKeyboardItem;
    self.navigationItem.titleView = self.navTitleViewBtn;
    //搜索无数据的时候的提示语
    [self.view addSubview:self.alertLabel];
    //搜索框
    [self.view addSubview:self.searchBar];
    //初始化搜索控制器
    [self initsearchDisplayController];
    //列表
    [self.view addSubview:self.tableView];
    //自定义键盘搜索结果的列表
    [self.view addSubview:self.keyboardSearchTableView];
    //导航栏上按钮点击对应的左中右三个浮层视图
    [self.view addSubview:self.leftView];
    [self.view addSubview:self.middleGroupView];
    [self.view addSubview:self.rightView];
    //屏幕中间的字母导航
    [self.view addSubview:self.centerLetterView];
    //默认当前展示在界面上的tableView是self.tableView
    self.currentTableView=self.tableView;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(EnterForeground:)
     
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)EnterForeground:(NSNotification *)notification
{
    NSLog(@"快刷新啦");
    [self.tableViewDataSource refreshDataSource];
    
    [_tableView reloadData];
    
}



-(void)viewWillAppear:(BOOL)animated{
    self.rightView.characterArr = [self getcharMutableArr];
    [super viewWillAppear:animated];
    [self showTabBar];
    
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //每次一开始就加载所有联系人
//    [self.navTitleViewBtn setTitle:@"全部联系人" forState:UIControlStateNormal];
    [self.tableViewDataSource refreshDataSource];

    [_tableView reloadData];
    
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //页面跳转的时候，隐藏控件
    self.centerLetterView.alpha=0;
    [self hiddenLeftView];
    [self hiddenRightView];
    [self hiddenTitleView];
    //去除键盘监听
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
/**
 *  初始化UIcontactsearchDisplayController
 */
-(void)initsearchDisplayController{
    _contactsearchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    
    _contactsearchDisplayController.delegate = self;

    _contactsearchDisplayController.searchResultsDataSource=self.searchDataSource;
    _contactsearchDisplayController.searchResultsDelegate=self;
    _contactsearchDisplayController.searchResultsTableView.rowHeight=60;
    _contactsearchDisplayController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}
#pragma mark - TableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //无数据时候的提示语
    self.alertLabel.hidden = ![self.tableViewDataSource dataArrIsNull];
    
    if (tableView==self.tableView) {
//        if (section==0) {//我的名片
//            return 0;
//        }
        if ([self.tableViewDataSource.dataArr[section] count] == 0){
            return 0;
        }else{
            return 20;
        }
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if ([self.tableViewDataSource.dataArr[section] count]==0){
            return 0;
        }else{
            return 0.5;
        }
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==self.tableView) {
        NSString * titleStr = nil;
//        if (section==0) {//我的名片
//            return nil;
//        }
        if ([self.tableViewDataSource.dataArr[section] count]==0){
            return nil;
        }else if (section==0){
            titleStr = @"★";
        }else if (section== self.tableViewDataSource.dataArr.count-1){
            titleStr = @"#";
        }else{
            unichar a = section-1+'A' ;
            titleStr = [NSString stringWithFormat:@"%C",a];
        }
        UIView * headerView=[[[UIView alloc]init] autorelease];
        headerView.backgroundColor=[UIColor whiteColor];
        headerView.frame=CGRectMake(0, 0, tableView.bounds.size.width, 20);
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15-15, 20)];
        label.text=titleStr;
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=COLOR_E;
        [headerView addSubview:label];
        [label release];
        return headerView;
    }else{
        return nil;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView==self.tableView) {
        if ([self.tableViewDataSource.dataArr[section] count]==0){
            return nil;
        }else{
            UIView * footerView=[[[UIView alloc]init] autorelease];
            footerView.frame=CGRectMake(0, 0, tableView.bounds.size.width, 0.5);
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15-15, 0.5)];
            lineLabel.backgroundColor=COLOR_H;
            [footerView addSubview:lineLabel];
            [lineLabel release];
            return footerView;
        }
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableView){
        //联系人主界面列表
//        if (indexPath.section==0) {
//            //“我的名片”
////            HB_ContactMyCardVC * myCardVC=[[HB_ContactMyCardVC alloc]init];
//            HB_MaCardInfoVc * myCardInfoVc = [[HB_MaCardInfoVc alloc] init];
//            Contact * MeContact = [[MemAddressBook getInstance] myCard];
//            myCardInfoVc.contactModel = [[ContactProtoToContactModel shareManager] memMycardToContactModel:MeContact];
//
//            [self.navigationController pushViewController:myCardInfoVc animated:YES];
//            [myCardInfoVc release];
//        }
//        else{
            HB_ContactInfoVC * infoVC=[[HB_ContactInfoVC alloc]init];
            HB_ContactSimpleModel * model=self.tableViewDataSource.dataArr[indexPath.section][indexPath.row];
            NSInteger i =model.contactID.intValue;
            infoVC.recordID=i;
            [self.navigationController pushViewController:infoVC animated:YES];
            [infoVC release];
//        }
    }else if(tableView == self.keyboardSearchTableView){
        //自定义键盘定位搜索
        HB_ContactInfoVC * infoVC=[[HB_ContactInfoVC alloc]init];
        HB_ContactSimpleModel * model=self.keyboardSearchDataSource.dataArr[indexPath.row];
        NSInteger i = model.contactID.intValue;
        infoVC.recordID=i;
        [self.navigationController pushViewController:infoVC animated:YES];
        [infoVC release];
        //隐藏搜索结果列表
        self.keyboardSearchTableView.hidden = YES;
        self.rightView.textField.text = nil;
        self.currentTableView = self.tableView;
    }else{
        //UISearchDisplay自带的搜索结果列表
        HB_ContactInfoVC * infoVC=[[HB_ContactInfoVC alloc]init];
        HB_ContactSimpleModel * model=self.searchDataSource.dataArr[indexPath.row];
        NSInteger i = model.contactID.intValue;
        infoVC.recordID=i;
        [self.navigationController pushViewController:infoVC animated:YES];
        [infoVC release];
    }
}
#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

#pragma mark searchDisplayController method

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0)
{
    self.currentTableView=self.tableView;
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self showTabBar];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(_searchBar.frame), Device_Width, Device_Height-CGRectGetMaxY(_searchBar.frame)-49-64);
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller NS_DEPRECATED_IOS(3_0,8_0);
{
    [self hiddenLeftView];
    [self hiddenRightView];
    [self hiddenTitleView];
    [self hiddenTabBar];
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(_searchBar.frame), Device_Width, Device_Height);
//    self.currentTableView=self.contactsearchDisplayController.searchResultsTableView;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    //如果不在此方法中设置 搜索table会出错
    
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setContentOffset:CGPointZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];//scrollview的contentview的顶点相对于scrollview的位置，例如你的contentInset = (0 ,100)，那么你的contentview就是从scrollview的(0 ,100)开始显示
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchDataSource.searchText = searchString;
    
    if (self.searchDataSource.dataArr.count == 0) {
        
        UITableView *tableView1 = self.contactsearchDisplayController.searchResultsTableView;
        
        for( UIView *subview in tableView1.subviews ) {
            
            if( [subview class] == [UILabel class] ) {
                
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                
                lbl.text = @"未有搜索到相关联系人";
                
            }
        }
        
    }
    return YES;
}




#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hiddenLeftView];
    [self hiddenTitleView];
    if (self.currentTableView != self.keyboardSearchTableView) {
        [self hiddenRightView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.currentTableView != self.tableView) {
        return;
    }
    //判断是否是手指拖动引起的滑动
    if(scrollView.panGestureRecognizer.numberOfTouches==0){//不是
        NSArray * arr = self.tableView.indexPathsForVisibleRows;
        if (arr.count) {//如果存在可见的cell才显示中央圆形字母
            NSIndexPath * indexPath=arr[0];
                self.centerLetterView.alpha=1;
            if (indexPath.section == 0) {
                self.centerLetterView.letter=@"★";
            }
            else if (indexPath.section==self.tableViewDataSource.dataArr.count-2) {
                self.centerLetterView.letter=@"#";
            }else{
                self.centerLetterView.letter=[NSString stringWithFormat:@"%c",(char)('A'+indexPath.section-1)];
            }
            
            [UIView animateWithDuration:1.75f animations:^{
                self.centerLetterView.alpha=0;
            }];
        }
    }
}
#pragma mark - HB_addContactViewDelegate
-(void)addContactViewDidClick:(HB_addContactView *)addContactView withButtonTag:(NSInteger)tag{
    [self hiddenLeftView];
    if (![HBZSAppDelegate checkAddressBookRABC]) {
        return ;
    }
    if (tag==CREATE_NEW_CONTACT) {//新建联系人
        HB_ContactDetailController * contactDetailVC=[[HB_ContactDetailController alloc]init];
        contactDetailVC.title=@"新建联系人";
        contactDetailVC.delegate = self;
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:contactDetailVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        [contactDetailVC release];
        [nav release];
    }else if (tag==SWEEP_CODE_ADD_CONTACT){//扫码添加
        __unsafe_unretained HB_ContactListVC *weakSelf = self;
        QRCodeScanViewController * QRScanVc = [[QRCodeScanViewController alloc] initWithBlock:^(NSString * result, BOOL isSuccess) {
            //判断扫码的结果，进行对应的操作
            HB_ScanResultAnalyze * analyzer = [[[HB_ScanResultAnalyze alloc] initWithCurrentVc:weakSelf] autorelease];
            [analyzer AnalyzeResult:result];

        }];
        
        [self.navigationController pushViewController:QRScanVc animated:YES];
        [QRScanVc release];
    
    }
    else if (tag == CONTACT_SHARE_BY_CLOUD)
    {
        if (![SettingInfo getAccountState]) {
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先前往\"我的\"进行登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [al release];
            return ;
        }
        HB_ContactCloudShareVc * vc= [[HB_ContactCloudShareVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else if (tag == BATCH_DELETE)
    {
        HB_BatchDeleteVc * vc= [[HB_BatchDeleteVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    
}
#pragma mark - HB_GroupSelectViewDelegate
/**
 *  点击了某一个分组
 */
-(void)groupSelectView:(HB_GroupSelectView *)groupSelectView didSelectGroupModel:(HB_GroupModel *)groupModel{
    [self hiddenTitleView];
    if (groupModel.groupID== KSelectViewGroupManageGroupID) {//‘管理分组’
        HB_GroupManageVC * vc=[[HB_GroupManageVC alloc]init];
        [vc hiddenTabBar];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else{//‘全部联系人--> -100’  ‘未分组--> -101’  以及 真正的某一个分组
        //重新修改frame
        NSMutableDictionary * attributesDict=[NSMutableDictionary dictionary];
        attributesDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
        CGSize titleSize = [groupModel.groupName boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesFontLeading attributes:attributesDict context:nil].size;
        self.navTitleViewBtn.frame=CGRectMake(0, 0, titleSize.width + 20, 30);
        self.navTitleViewBtn.center = CGPointMake(self.view.center.x, 22);
        
        [self.navTitleViewBtn setTitle:groupModel.groupName forState:UIControlStateNormal];
        self.tableViewDataSource.groupID=groupModel.groupID;
        [self.tableView reloadData];
    }
}
#pragma mark - SearchKeyBoardViewDelegate
-(void)searchKeyBoardView:(HB_SearchKeyBoardView *)searchKeyBoardView withSearchText:(NSString *)searchText{
    //1.如果有搜索内容，就显示keyboardSearchTableView，反之则隐藏
    if (searchText.length == 0) {
        self.keyboardSearchTableView.hidden=YES;
        self.currentTableView=self.tableView;
    }else{
        self.keyboardSearchTableView.hidden=NO;
        self.currentTableView=self.keyboardSearchTableView;
    }
    self.keyboardSearchDataSource.searchText=searchText;
    [self.keyboardSearchTableView reloadData];
    //2.找出搜索结果中所有的声母，添加到数组，设置给searchKeyBoardView
    NSMutableArray * charArr=[[NSMutableArray alloc]init];
    for (int i=0; i<self.keyboardSearchDataSource.dataArr.count; i++) {
        HB_ContactSimpleModel * model =self.keyboardSearchDataSource.dataArr[i];
        NSString * nameStrPinYin = [model.name chineseToPinYin];
        nameStrPinYin = [nameStrPinYin substringFromIndex:searchText.length];
        if (nameStrPinYin.length) {
            char c = [nameStrPinYin characterAtIndex:0];
            [charArr addObject:[NSString stringWithFormat:@"%c",c]];
        }
    }
    searchKeyBoardView.characterArr=charArr;
    [charArr release];
}

-(NSArray * )getcharMutableArr
{
    //获取所有联系人的首字母，让其可点击
    NSMutableArray * charMutableArr=[[[NSMutableArray alloc]init] autorelease];
    NSArray * contactDictArr=[HB_ContactDataTool contactGetAllContactSimpleProperty];
    for (int i=0; i<contactDictArr.count; i++) {
        //1.字典转模型
        NSDictionary * contactDict =contactDictArr[i];
        HB_ContactSimpleModel * simpleModel=[[HB_ContactSimpleModel alloc]init];
        [simpleModel setValuesForKeysWithDictionary:contactDict];
        NSString * nameStr_PinYin=[simpleModel.name chineseToPinYin];
        char firstChar=[nameStr_PinYin characterAtIndex:0];
        [charMutableArr addObject:[NSString stringWithFormat:@"%c",firstChar]];
        [simpleModel release];
    }
    return charMutableArr;
}

#pragma mark - event response
-(void)notificationAction:(NSNotification *)notifation{
    //刷新数据源
    [self.navTitleViewBtn setTitle:@"全部联系人" forState:UIControlStateNormal];
    [self.tableViewDataSource refreshDataSource];
    [_tableView reloadData];
}
-(void)navLeftBtnClick:(UIButton *)btn{
    [self hiddenRightView];
    [self hiddenTitleView];
    
    btn.selected=!btn.selected;
    if (btn.selected) {
        _leftView.clipsToBounds=NO;
        _leftView.frame=CGRectMake(15, 0, 100, 44 * 4 + 20);
    }else{
        _leftView.clipsToBounds=YES;
        _leftView.frame=CGRectZero;
    }
}
-(void)navTitleViewBtnClick:(UIButton *)btn{
    [self hiddenLeftView];
    [self hiddenRightView];
    
    btn.selected=!btn.selected;
    if (btn.selected) {
        _middleGroupView.clipsToBounds=YES;
        CGFloat middleGroupView_W=112.5;
        CGFloat middleGroupView_H=200;
        CGFloat middleGroupView_X=self.view.bounds.size.width*0.5-middleGroupView_W*0.5;
        CGFloat middleGroupView_Y=0;
        _middleGroupView.frame=CGRectMake(middleGroupView_X, middleGroupView_Y, middleGroupView_W , middleGroupView_H);
        btn.imageView.transform=CGAffineTransformMakeRotation(M_PI);
    }else{
        _middleGroupView.clipsToBounds=YES;
        _middleGroupView.frame=CGRectZero;
        btn.imageView.transform=CGAffineTransformMakeRotation(0);
    }
}
-(void)navRightBtnClick:(UIButton *)btn{
    [self hiddenLeftView];
    [self hiddenTitleView];
    
    btn.selected=!btn.selected;
    if (btn.selected) {
        _rightView.clipsToBounds=NO;//
        CGFloat rightView_W=180;
        CGFloat rightView_H=360;
        CGFloat rightView_X=self.view.bounds.size.width-rightView_W;
        CGFloat rightView_Y=0;
        _rightView.frame=CGRectMake(rightView_X, rightView_Y, rightView_W, rightView_H);
    }else{
        _rightView.clipsToBounds=YES;//为了隐藏子控件
        _rightView.frame=CGRectZero;
    }
}
#pragma mark - private methods
/**  隐藏左侧视图 */
-(void)hiddenLeftView{
    _leftView.clipsToBounds=YES;
    _leftView.frame=CGRectZero;
    _navLeftBtn.selected=NO;
}
/**  隐藏右侧视图 */
-(void)hiddenRightView{
    _rightView.clipsToBounds=YES;
    _rightView.frame=CGRectZero;
    _navRightKeyboardBtn.selected=NO;
}
/**  隐藏中部视图 */
-(void)hiddenTitleView{
    _middleGroupView.clipsToBounds=YES;
    _navTitleViewBtn.selected=NO;
    _navTitleViewBtn.imageView.transform=CGAffineTransformMakeRotation(0);
    _middleGroupView.frame=CGRectZero;
}
#pragma mark - setter and getter
/**
 *  导航栏左侧的barButtonItem
 */
-(UIBarButtonItem *)navLeftItem{
    if (!_navLeftItem) {
        _navLeftItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftBtn];
    }
    return _navLeftItem;
}
/**
 *  导航栏左侧的Button
 */
-(UIButton *)navLeftBtn{
    if (!_navLeftBtn) {
        _navLeftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_navLeftBtn setFrame:CGRectMake(0, 0, 20, 20)];
        _navLeftBtn.exclusiveTouch = YES;
        [_navLeftBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        [_navLeftBtn addTarget:self action:@selector(navLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navLeftBtn;
}
/**
 *  导航栏右侧的barButtonItem
 */
-(UIBarButtonItem *)navRightKeyboardItem{
    if (!_navRightKeyboardItem) {
        _navRightKeyboardItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightKeyboardBtn];
    }
    return _navRightKeyboardItem;
}
/**
 *  导航栏右侧的Button
 */
-(UIButton *)navRightKeyboardBtn{
    if (!_navRightKeyboardBtn) {
        _navRightKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navRightKeyboardBtn setFrame:CGRectMake(0, 0, 20, 20)];
        _navRightKeyboardBtn.exclusiveTouch = YES;
        [_navRightKeyboardBtn setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
        [_navRightKeyboardBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navRightKeyboardBtn;
}
/**
 *  导航栏中间的按钮
 */
-(HB_TitleViewButton *)navTitleViewBtn{
    if (!_navTitleViewBtn) {
        _navTitleViewBtn = [HB_TitleViewButton buttonWithType:UIButtonTypeCustom];
        [_navTitleViewBtn setTitleColor:COLOR_I forState:UIControlStateNormal];
        _navTitleViewBtn.titleLabel.font=[UIFont boldSystemFontOfSize:20];
        NSString * titleStr=@"全部联系人";
        NSMutableDictionary * attributesDict=[[NSMutableDictionary alloc]init];
        attributesDict[NSFontAttributeName]=[UIFont boldSystemFontOfSize:20];
        CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(200, 30) options:NSStringDrawingUsesFontLeading attributes:attributesDict context:nil].size;
        [attributesDict release];
        [_navTitleViewBtn setTitle:titleStr forState:UIControlStateNormal];
        _navTitleViewBtn.frame=CGRectMake(0, 0, titleSize.width + 20, 30);
        [_navTitleViewBtn setImage:[UIImage imageNamed:@"筛选1"] forState:UIControlStateNormal];
        [_navTitleViewBtn addTarget:self action:@selector(navTitleViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navTitleViewBtn;
}
/**
 *  搜索框
 */
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_searchBar sizeToFit];
        _searchBar.delegate=self;
    }
    return _searchBar;
}
/**
 *  中央的圆形字母提示
 */
-(HB_CenterLetterView *)centerLetterView{
    if (!_centerLetterView) {
        _centerLetterView=[[HB_CenterLetterView alloc]init];
        CGFloat centerLetter_W=50;
        CGFloat centerLetter_H=50;
        CGFloat centerLetter_X=SCREEN_WIDTH-centerLetter_W-50;
        CGFloat centerLetter_Y=100;
        _centerLetterView.frame=CGRectMake(centerLetter_X, centerLetter_Y, centerLetter_W, centerLetter_H);
        _centerLetterView.alpha=0;
    }
    return _centerLetterView;
}
/**
 *  左侧浮层视图
 */
-(HB_addContactView *)leftView{
    if (!_leftView) {
        _leftView=[[HB_addContactView alloc]init];
        _leftView.clipsToBounds=YES;
        _leftView.delegate=self;
    }
    return _leftView;
}
/**
 *  中部浮层视图
 */
-(HB_GroupSelectView *)middleGroupView{
    if (!_middleGroupView) {
        _middleGroupView=[[HB_GroupSelectView alloc]init];
        _middleGroupView.clipsToBounds=YES;
        _middleGroupView.delegate=self;
    }
    return _middleGroupView;
}
/**
 *  左侧浮层视图
 */
-(HB_SearchKeyBoardView *)rightView{
    if (!_rightView) {
        _rightView=[[HB_SearchKeyBoardView alloc]init];
        _rightView.clipsToBounds=YES;
        _rightView.delegate=self;
        
        _rightView.characterArr=[self getcharMutableArr];
        
        //3.1添加阴影
        _rightView.layer.shadowColor=[[UIColor blackColor]CGColor];
        _rightView.layer.shadowOffset=CGSizeMake(-2, 2);
        _rightView.layer.shadowOpacity=0.5;
    }
    return _rightView;
}


/**
 *  主列表
 */
-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat tableView_X=0;
        CGFloat tableView_Y=CGRectGetMaxY(_searchBar.frame);
        CGFloat tableView_W=SCREEN_WIDTH;
        CGFloat tableView_H=SCREEN_HEIGHT-tableView_Y-49-64;
        CGRect tableViewFrame=CGRectMake(tableView_X,tableView_Y,tableView_W,tableView_H);
        _tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.rowHeight=60;
        _tableView.delegate=self;
        _tableView.dataSource=self.tableViewDataSource;
    }
    return _tableView;
}
-(UITableView *)keyboardSearchTableView{
    if (!_keyboardSearchTableView) {
        CGFloat tableView_X=0;
        CGFloat tableView_Y=0;
        CGFloat tableView_W=SCREEN_WIDTH;
        CGFloat tableView_H=SCREEN_HEIGHT-49-64;
        CGRect tableViewFrame=CGRectMake(tableView_X,tableView_Y,tableView_W,tableView_H);
        _keyboardSearchTableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _keyboardSearchTableView.dataSource=self.keyboardSearchDataSource;
        _keyboardSearchTableView.delegate=self;
        _keyboardSearchTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _keyboardSearchTableView.rowHeight=60;
        _keyboardSearchTableView.hidden=YES;
    }
    return _keyboardSearchTableView;
}
/**
 *  搜索无数据的时候的提示语
 */
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel=[[UILabel alloc]init];
        _alertLabel.textColor=COLOR_H;
        _alertLabel.font=[UIFont boldSystemFontOfSize:30];
        _alertLabel.frame=CGRectMake(0, 150, SCREEN_WIDTH, 60);
        _alertLabel.textAlignment=NSTextAlignmentCenter;
        _alertLabel.text=@"暂无数据";
        _alertLabel.hidden=YES;
    }
    return _alertLabel;
}
/**  列表数据源 */
-(HB_ContactListDataSource *)tableViewDataSource{
    if (!_tableViewDataSource) {
        _tableViewDataSource=[[HB_ContactListDataSource alloc]init];
    }
    return _tableViewDataSource;
}
/**  搜索结果数据源 */
-(HB_ContactSearchResultDataSource *)searchDataSource{
    if (!_searchDataSource) {
        _searchDataSource=[[HB_ContactSearchResultDataSource alloc]init];
    }
    return _searchDataSource;
}
/**  自定义键盘搜索的dataSource */
-(HB_ContactKeyboardSearchDataSource *)keyboardSearchDataSource{
    if (!_keyboardSearchDataSource) {
        _keyboardSearchDataSource=[[HB_ContactKeyboardSearchDataSource alloc]init];
    }
    return _keyboardSearchDataSource;
}

-(void)ContactDetailController:(HB_ContactDetailController *)ContactDetailController SavedContact:(NSInteger)contactId
{
    HB_ContactInfoVC * infoVC=[[HB_ContactInfoVC alloc]init];
    infoVC.recordID = (int)contactId;
    [self.navigationController pushViewController:infoVC animated:NO];

}

@end
