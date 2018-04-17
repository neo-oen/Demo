//
//  DialViewCtrl.m
//  HBZS_IOS
//
//  Created by yingxin on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialViewCtrl.h"
#import "DialDetailViewCtrl.h"
#import "AreaQuery.h"
#import "Public.h"
#import "HBZSAppDelegate.h"
#import "MainViewCtrl.h"
#import "UIViewController+TitleView.h"
#import "FormatPhoneNumber.h"
#import "BaiduMobStat.h"
#import "UtilMacro.h"

#import "HB_ContactInfoVC.h"
#import "HB_ContactDetailController.h"
#import "HB_ContactPreviewVC.h"

#import "SettingInfo.h"
#import "HB_OneKeyCallModel.h"
#import "HB_OneKeyCallVC.h"
#import "HB_LiftChildWebVC.h"


#define AlertTag_oneKey 100

@interface DialViewCtrl (){

    UIWebView *_phoneCallWebView;
}



@end

@implementation DialViewCtrl

@synthesize dialTableView;

@synthesize tableDataArray;

@synthesize dialItemsArray;

@synthesize dialKeyBoardView;

- (void)dealloc
{
   // NSLog(@"DialVieCtrl...dealloc");
    if (tableDataArray) {
        [tableDataArray release];
        
        tableDataArray = nil;
    }
    
    if (dialItemsArray) {
        [dialItemsArray release];
        
        dialItemsArray = nil;
    }
    
    if (dialKeyBoardView) {
        [dialKeyBoardView release];
        dialKeyBoardView = nil;
    }
    
    if (dialTableView) {
         [dialTableView release];
        dialTableView = nil;
    }
    if (_phoneCallWebView) {
        [_phoneCallWebView release];
        _phoneCallWebView = nil;
    }

    //别忘了删除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setVCTitle:@"通话记录"];
   
    self.view.backgroundColor = [UIColor purpleColor];
    [self allocTableview];
    
    [self setTitleBackLeftBtnHidden:YES];
    
    HBZSAppDelegate * delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
//
    [delegate initSearchContactData];
    
    
    //添加监听  2015.7.2
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(appHasGoneInForeground)
                                            name:UIApplicationDidBecomeActiveNotification
                                            object:nil];
}
-(void)appHasGoneInForeground{
    [self initData];
    [dialTableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    bSound = [SettingInfo getIsDialSound];
    bShake = [SettingInfo getIsDialShake];
    
    bShowArea = [SettingInfo getIsShowArea];
    
    if(bShowArea){
        [AreaQuery getInstance];
    }
    
    [self showTabBar];
    
    [self initData];
    
    if (self.dialKeyBoardView.dialNumberString) {
        [self searchByPhoneNumber];
    }
    [dialTableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];


    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if(bShowArea){
        [AreaQuery releaseInstance];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (id)init{
    self = [super init];
    
    if (self) {
        CGFloat showOriginY = (Device_Height - 49 -275-64);
        CGFloat hiddenOriginY = Device_Height;
        dialKeyBoardView =  [[DialKeyBoardView alloc] initWithShowFrame:CGRectMake(0,showOriginY,Device_Width,275) hideFrame:CGRectMake(0,hiddenOriginY,Device_Width, 275)];
        
        
        dialKeyBoardView.delegate = self;
        
        dialItemsArray  = [[NSMutableArray alloc] init];
        
        tableDataArray = [[NSMutableArray alloc] init];
        

    }
    
    return self;
}


#pragma mark init Data
- (void)initData{
    NSMutableArray * arr = [SettingInfo getDialItems];
    
    if (arr) {
        if (dialItemsArray) {
            [dialItemsArray release];
            
            dialItemsArray = nil;
        }
        
        dialItemsArray = [[NSMutableArray alloc]init];
        
        [dialItemsArray addObjectsFromArray:arr];
        
        for (DialItem * dialItem in dialItemsArray) {
            if (dialItem.contactID <=0) {
                continue;
            }
            else{
                SearchItem * item = [ContactData getSearchItemByRecordId:dialItem.contactID];
                //更新联系人数据 以便联系人变动能及时同步
                if (item.contactID<0) {
                    dialItem.contactID = -1;
                    dialItem.name = dialItem.phone;
                }
                else{
                    //更新联系人用户名，并判断是否为空
                    dialItem.name = [NSString stringWithFormat:@"%@%@",item.contactLastName.length?item.contactLastName:@"",item.contactFirstName.length?item.contactFirstName:@""];
                }
            }
        }
    
        if ([dialItemsArray count] > 0){
            [self setTitleRightBtnHidden:NO];
        }
        else{
            [self setTitleRightBtnHidden:YES];
        }
    }
}

- (void)allocTableview{
    CGRect tableFrame = CGRectMake(0,
                                     0,
                                     Device_Width,
                                     Device_Height-44-49-kStatuBarHeight);

    dialTableView = [[UITableView alloc] initWithFrame:tableFrame
                                                 style:UITableViewStylePlain];
    dialTableView.delegate = self;
    dialTableView.dataSource = self;
    dialTableView.backgroundColor = [UIColor clearColor];
    [dialTableView setAllowsSelectionDuringEditing:YES];
    dialTableView.separatorStyle = NO;
    [self.view addSubview:dialTableView];
    //last
    [self.view  addSubview:dialKeyBoardView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark -按钮键盘响应事件
- (void)dialButtonIndex:(keyBoardType)idx{
    
    if (dialKeyBoardView.dialNumberString.length>0) {
        [self setVCTitle:dialKeyBoardView.dialNumberString];
    }
    else
    {
        [self setVCTitle:@"通话记录"];
    }
    SystemSoundID soundID = 1200;
//
//    if (idx >= 0 && idx <= 9){
//        soundID = 1200 + idx;
//    }
//    else if (idx == 110 || idx == 112 || idx == 111){
//        soundID = 1210;
//    }
//    else{
//        soundID = 1211;
//    }
//    
    if (bSound){
        AudioServicesPlaySystemSound(soundID);
    }

    if (bShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//1350
    }

    
    if ([dialKeyBoardView.dialNumberString length] > 0){
            [self searchByPhoneNumber];
            
            [self setTitleRightBtnHidden:YES];
    }
    else{
        [tableDataArray removeAllObjects];
            
        if ([dialItemsArray count]>0) {
            [self setTitleRightBtnHidden:NO];
        }
        else {
            [self setTitleRightBtnHidden:YES];
        }
    }
        
    [dialTableView reloadData];
    
}
-(void)dialingClick
{
    if (dialKeyBoardView.dialNumberString && [dialKeyBoardView.dialNumberString length]>2) {
        [self dialPhone:dialKeyBoardView.dialNumberString contactID:-1 Called:nil];
        dialKeyBoardView.dialNumberString = [NSMutableString stringWithFormat:@""];
        [self setVCTitle:@"通话记录"];
        [self.dialTableView reloadData];
    }
}

-(void)pushToaddressVc
{
    HB_LiftChildWebVC * webVc=[[HB_LiftChildWebVC alloc] init];
    webVc.titleName = [NSString stringWithFormat:@"号码百事通"];
    webVc.url = [NSURL URLWithString:@"http://dianhua.118114.cn:9088/collectionStock/o2oh5/home.html?channel=202"];
    [self.navigationController pushViewController:webVc animated:YES];
    [webVc release];
}

-(void)OneKeyDailIndex:(NSInteger)OnekeyIndex
{
    NSDictionary * dic = [SettingInfo getOneKeyCall];
    NSData * data = [dic objectForKey:[NSString stringWithFormat:@"%ld",OnekeyIndex+1]];
    if (data) {
         HB_OneKeyCallModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self dialPhone:model.phoneNum contactID:model.recordID Called:nil];
    }
    else
    {
        [Public allocAlertview:@"" msg:[NSString stringWithFormat:@"拨号键%ld还没设置一键拨号，请前往拨号设置绑定号码！",(long)OnekeyIndex+1] btnTitle:@"取消" btnTitle:@"立即设置" delegate:self tag:AlertTag_oneKey];
    }
   
}
#pragma mark dialKeyBoard  Hiden
- (void)dialKeyBoardHided:(BOOL)bhided{    
    
    if (!bhided && dialTableView.editing) {
        [self titleRightBtnDo];
    }
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!dialKeyBoardView.m_hidden) {
        HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [delegate.tabBar setDialKbdHide:YES];
    }
}

#pragma mark UITableViewDelegate UITableDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    
    if ([dialKeyBoardView.dialNumberString length] > 0){
        if([tableDataArray count] > 0){
            rowCount = [tableDataArray count];
        }
        else{
            rowCount = 3;
        }
    }
    else{
        rowCount = [dialItemsArray count];
    }
    
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark 拼接Name  Added by Kevin Zhang on 1,5 2013
- (NSString *)formatName:(NSString *)_lastname andFirstname:(NSString *)_firstname{
    NSString *temp = @"";
    
    if(_firstname != nil && _lastname != nil)
    {
        temp = [NSString stringWithFormat:@"%@ %@",_lastname,_firstname];
    }
    else if(_lastname != nil){
        temp = _lastname;//[NSString stringWithFormat:@"%@",_lastname];
    }
    else if(_firstname != nil){
        temp = _firstname;//[NSString stringWithFormat:@"%@",_firstname];
    }
    
    return temp;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //当没有结果并且有号码的时候 提示添加这个号码到联系人
    if ([dialKeyBoardView.dialNumberString length] >0 && [tableDataArray count] < 1)
    {
        static NSString *CellIdentifierNumber = @"DialViewcellNumber";
        static NSString *CellIdentifierAddTip = @"DialViewcellAddTip";
        
        if (indexPath.row == 0){
            UITableViewCell * numberCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierNumber];
            
            if (numberCell == nil){
                numberCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierAddTip] autorelease];
            }
            
            [numberCell.textLabel setText:@"创建新联系人"];
            
            return numberCell;
        }
        else if(indexPath.row == 1){
            UITableViewCell * tipCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierAddTip];
            
            if (tipCell == nil){
                tipCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierAddTip] autorelease];
            }
            
            [tipCell.textLabel setText:@"添加到已有联系人"];
            
            return tipCell;
        }
        else if (indexPath.row == 2)
        {
            UITableViewCell * tipCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierAddTip];
            
            if (tipCell == nil){
                tipCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierAddTip] autorelease];
            }
            
            [tipCell.textLabel setText:@"发送短信"];
            
            return tipCell;
        }
    }
    
    static NSString *CellIdentifier = @"DialViewcell";
    
    NSInteger contactID = -1;
    NSString  *topLabelStr = nil;
    NSString  *bottomLabelStr = nil;
    NSString *locationLabelStr = @"";
    
    
    NSRange hRange;
    
    hRange.location = 0;
    hRange.length = 0;
    
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    NSMutableArray *phoneArray = [[NSMutableArray alloc]init];
    
    DialListCell *itemCell = (DialListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (itemCell == nil){
        itemCell= [[[DialListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        [itemCell.dialInfoBtn addTarget:self action:@selector(detialBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        //cell复用前将属性还原
        [itemCell setLabelMid:@""];
        [itemCell setLabelTop:@"" lableFrame:CGRectZero highLightRange:nil];
        [itemCell setLabelBottom:@"" lableFrame:CGRectZero highLightRange:nil];
        [itemCell setLabelRight:@""];
        [itemCell setLabelDate:@""];
        [itemCell setLabelLocation:@""];
        itemCell.dialInfoBtn.hidden = NO;
    }
    
    [itemCell.dialInfoBtn setTag:indexPath.row];
    
    if ([dialKeyBoardView.dialNumberString length] > 0){
        
        if([tableDataArray count] > 0){ //画搜索结果(变色)
            //画搜索结果
            SearchItem *searchItem = [tableDataArray objectAtIndex:indexPath.row];
            
            if (searchItem == nil){
                return nil;
            }
            
            contactID = searchItem.contactID ;
            
            if ([searchItem.contactPhoneArray count] > 0) {
                bottomLabelStr = [searchItem.contactPhoneArray objectAtIndex:0];//手机号码
            }
            
            
            if ([searchItem.contactFirstName length] > 0 || [searchItem.contactLastName length] > 0){
                //姓名
                topLabelStr = [self formatName:searchItem.contactLastName andFirstname:searchItem.contactFirstName];
            }
            if (searchItem.PubNumberLogoStr) {
                topLabelStr = searchItem.contactFullName;
                itemCell.headImageView.image = [UIImage imageNamed:searchItem.PubNumberLogoStr];
                itemCell.dialInfoBtn.hidden = YES;
            }
            
            
            
            hRange = searchItem.keyRange;
            
            NSString *loc = [NSString stringWithFormat:@"%lu",(unsigned long)hRange.location];
            NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)hRange.length];
            
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObject:loc forKey:len];
            [phoneArray addObject:tmpDic];
            [nameArray addObjectsFromArray:searchItem.rangeArray];
            
            [itemCell setDialInfoBtnImg:@"右箭头"];
            
            locationLabelStr =[[AreaQuery getInstance] queryAreaByNumber:bottomLabelStr];//号码归属地
            
            itemCell.locationLabel.text = locationLabelStr;
            
        }
    }
    else{
        //画最近通话记录
        DialItem  *dialItem = [dialItemsArray objectAtIndex:indexPath.row];
        
        if (dialItem == nil){
            return nil;
        }
        itemCell.dialInfoBtn.hidden = NO;
        contactID = dialItem.contactID;

        //added on Dec 3,2013
        topLabelStr = [NSString stringWithFormat:@"%@",dialItem.name];
        
        bottomLabelStr = [NSString stringWithFormat:@"%@",dialItem.phone];
        
        locationLabelStr = [[AreaQuery getInstance] queryAreaByNumber:bottomLabelStr];
        //end
        [itemCell setDialInfoBtnImg:@"dl_dialnumarrow"];
        
        [itemCell setLabelRight:[NSString stringWithFormat:@"%lu",(unsigned long)[dialItem.times count]]];
        
        [itemCell setLabelDate:[self getSystemTime:[dialItem.times objectAtIndex:0]]];
        
        itemCell.locationLabel.text = locationLabelStr;
    }
    
    CGRect topRect;
    
    CGRect bottomRect;
    
    if (tableView.editing){
        topRect = CGRectMake(60, 14, 130*RATE, 25);
        
        bottomRect = CGRectMake(60, 38, 115*RATE, 15);
    }
    else{
        topRect = CGRectMake(60, 14, 145*RATE, 25);//170
        
        bottomRect = CGRectMake(60, 38, 130*RATE, 15);
    }
    if (contactID) {
        [itemCell setHeadImage:contactID];
    }
    
    
    if (topLabelStr == nil || topLabelStr.length == 0) {
        topLabelStr = @"未命名";
    }
    
    NSString *name = topLabelStr;
    CGFloat nameWidth = 0.0;
    
    for (int i = 0; i < topLabelStr.length; i++) {
        NSString *temp = [topLabelStr substringWithRange:NSMakeRange(i, 1)];
        
        CGFloat width = [temp sizeWithFont:[UIFont systemFontOfSize:18.0]].width;
        nameWidth = nameWidth + width;
        
        if ((nameWidth ) >= (topRect.size.width-20)) {
            name = [NSString stringWithFormat:@"%@...",[topLabelStr substringWithRange:NSMakeRange(0, i+1)]];
            break;
        }
    }
    
    [itemCell setLabelTop:name lableFrame:topRect highLightRange:nameArray];
   
    
    if (bottomLabelStr == nil || bottomLabelStr.length == 0) {
        bottomLabelStr = @"";
    }
    
    [itemCell setLabelBottom:bottomLabelStr lableFrame:bottomRect highLightRange:phoneArray];
    
    [nameArray release];
    
    [phoneArray release];
    
    if (bShowArea){
        itemCell.locationLabel.hidden = NO;
        [itemCell setLabelLocation:locationLabelStr];
    }
    
    if (!isEditModel) {
        itemCell.dateLabel.hidden = NO;
        itemCell.locationLabel.hidden = NO;
//        itemCell.dialInfoBtn.hidden = NO;

    }
    else{
        itemCell.dateLabel.hidden = YES;
        itemCell.dialInfoBtn.hidden = YES;
        itemCell.locationLabel.hidden = YES;
    }
    
    
    
    
 
    return itemCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//      cell.backgroundColor = ((indexPath.row % 2) == 0) ? UIColorWithRGB(237, 237, 237) : UIColorWithRGB(243, 243, 243);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //当没有结果并且有号码的时候 添加这个号码到联系人
    if ([dialKeyBoardView.dialNumberString length] > 0 && [tableDataArray count] < 1)
    {
        if (indexPath.row == 0)
        {
//            [SettingInfo setListenAppChangedAddressbook:YES];
            [self addNewPerson:dialKeyBoardView.dialNumberString];
            
        }
        else if (indexPath.row == 1)
        {
//            [SettingInfo setListenAppChangedAddressbook:YES]; //Added by Kevin On March 22
            [self addToLocalPerson];

            [[BaiduMobStat defaultStat]logEvent:@"callDetailAddContact" eventLabel:@"通话详情-添加至现有联系人量"];
        }
        else if (indexPath.row == 2)
        {
            NSArray * arr = [NSArray arrayWithObject:dialKeyBoardView.dialNumberString];
            [self doSendMessage:arr];
        }
        
        return;
    }
    
    if ([dialKeyBoardView.dialNumberString length] > 0)
    {
        SearchItem *searchItem = [tableDataArray objectAtIndex:indexPath.row];
        
        if ([searchItem.contactPhoneArray count] > 1)
        {
            [self dialActionMenu:searchItem.contactPhoneArray dataIndex:indexPath.row];
        }
        else if([searchItem.contactPhoneArray count] == 1)
        {
            [self dialPhone:[searchItem.contactPhoneArray objectAtIndex:0] contactID:searchItem.contactID Called:nil];
        }
    }
    else
    {
        DialItem  *dialItem = [dialItemsArray objectAtIndex:indexPath.row];
        
        [self dialPhone:dialItem.phone contactID:-1 Called:nil];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle != UITableViewCellEditingStyleDelete){
		return;
    }
    
    [dialItemsArray removeObjectAtIndex:indexPath.row];
    
    [tableView beginUpdates];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [tableView endUpdates];
    [SettingInfo setDialItems:dialItemsArray];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (dialKeyBoardView.dialNumberString.length >0) {
        return UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;

    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)pushContactDetailViewCtrl:(NSInteger)contactID{
    HB_ContactInfoVC * vc = [[HB_ContactInfoVC alloc] init];
    vc.recordID = contactID;

    [self.navigationController pushViewController:vc animated:YES];
    
    [vc release];
}

- (void)pushDialDetailViewCtrl:(DialItem *)dialItem{
    
    DialDetailViewCtrl* dialDetalvc = [[DialDetailViewCtrl alloc] initWithDialItem:dialItem];
    
    dialDetalvc.pageviewStartWithName = @"通话记录";
    dialDetalvc.DialDetaiDelegate = self;
    [self.navigationController pushViewController:dialDetalvc animated:YES];
    
    [dialDetalvc release];
}
#pragma mark detailBtnClicked
- (void)detialBtnClicked:(UIButton*)isender{
    if ([dialKeyBoardView.dialNumberString length] > 0){
        SearchItem *searchItem = [tableDataArray objectAtIndex:isender.tag];
        
        if (searchItem == nil) {
            return;
        }
        
        [self pushContactDetailViewCtrl:searchItem.contactID];
    }
    else{
        DialItem  *dialItem = [dialItemsArray objectAtIndex:isender.tag];
        
        [self pushDialDetailViewCtrl:dialItem];
    }
}

#pragma mark dial list
- (void)dialActionMenu:(NSMutableArray*)phoneNumbers dataIndex:(NSInteger)conId
{
    UIActionSheet *menu = [[UIActionSheet alloc]initWithTitle: @"拨打电话" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [menu setTag:conId];
    
    for (NSString* phone in phoneNumbers) {
        if (phone) {
            [menu addButtonWithTitle:phone];
        }
    }
    
    [menu addButtonWithTitle:@"取消"];
    
    menu.cancelButtonIndex = menu.numberOfButtons-1;
    
    [menu showInView:self.view];
    
    [menu release];
}


- (void)forceToAddFirstName:(SearchItem *)searchItem{   //无姓名用户 强制加姓名
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    //无姓名用户强制加姓名
    if (searchItem.contactFirstName == nil && searchItem.contactLastName == nil)
    {
        if ([searchItem.contactPhoneArray count] > 0){
            searchItem.contactFirstName = [searchItem.contactPhoneArray objectAtIndex:0];
        }
        else if([ContactData getRecordEmailByID:searchItem.contactID]){
            searchItem.contactFirstName = [ContactData getRecordEmailByID:searchItem.contactID];
        }
        else{
            searchItem.contactFirstName = @"未命名";
        }
        
        ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
        
        ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, searchItem.contactID);
        
        ABRecordSetValue(personRef, kABPersonFirstNameProperty, searchItem.contactFirstName, nil);
        
        ABAddressBookSave(addressBookRef, nil);
    }
}


#pragma mark 添加新联系人
- (void)addNewPerson:(NSString *)strPhone{
    HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
 
    NSString *dialPhone = [[NSString alloc]initWithFormat:@"%@",strPhone];
    dialKeyBoardView.dialNumberString = [NSMutableString stringWithFormat:@""];
    [self setVCTitle:@"通话记录"];
    [delegate.tabBar setDialKbdHide:YES];
    
    [self presentABNewPersonViewController:dialPhone];
    
    [self hiddenTabBar];
}



/*
 *添加到现有联系人所有操作
 */
#pragma mark 添加到现有联系人

-(void) addToLocalPerson
{
    HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.tabBar setDialKbdHide:YES];
    HB_ContactPreviewVC * vc = [[HB_ContactPreviewVC alloc] init];
    vc.phoneNumStr =dialKeyBoardView.dialNumberString;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


#pragma mark date And time

- (NSString*)getSystemTime:(NSDate*)date{
    if ([self twoDateIsSameDay:date second:[NSDate date]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        
        NSString *dateString = [formatter stringFromDate:date];
        
        [formatter release];
        
        return dateString;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM月dd日"];
    
    NSString *dateString=[formatter stringFromDate:date];
    
    [formatter release];
    
    return dateString;
}

#pragma mark 判断两个日期是否同一天
- (BOOL)twoDateIsSameDay:(NSDate *)fist second:(NSDate *)second{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit =NSMonthCalendarUnit |NSYearCalendarUnit |NSDayCalendarUnit;
    
    NSDateComponents *fistComponets = [calendar components: unit fromDate: fist];
    
    NSDateComponents *secondComponets = [calendar components: unit fromDate: second];
    
    if ([fistComponets day] == [secondComponets day]
        && [fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark 按号码搜索
-(void)searchByPhoneNumber
{
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (tableDataArray.count > 0) {
        [tableDataArray removeAllObjects];
    }
    
    NSArray * ARRAY  = [delegate searchData:dialKeyBoardView.dialNumberString type:-1 bGroup:NO];
  
    NSMutableSet *contactSet = [[NSMutableSet alloc]init];
    [contactSet addObjectsFromArray:ARRAY];
    
    [tableDataArray addObjectsFromArray:[[contactSet objectEnumerator] allObjects]];
    
    [contactSet release];
}


#pragma mark -
#pragma mark from father
-(void)titleRightBtnDo{
//    [dialTableView setEditing:!dialTableView.editing animated:YES];
//    
//    if (!dialTableView.editing) {
//        isEditModel = NO;
//        
//        [SettingInfo setDialItems:dialItemsArray];
//        
//        [self setTitleLeftBtnHidden:YES];
//        
//        [self setRightButton:@"bt_editright" imgHighlight:@"bt_editright_over"];
//        [dialTableView reloadData];
//    }
//    else {
//        isEditModel = YES;
//        [self setTitleLeftBtnHidden:NO];
//        
//        [self setRightButton:@"bt_okright" imgHighlight:@"bt_okright_over"];
//    }
//    
//    if ([dialItemsArray count] > 0) {
//        [self setTitleRightBtnHidden:NO];
//    }
//    else {
//        [self setTitleRightBtnHidden:YES];
//    }
}

- (void)titleLeftBtnDo{
//    [Public allocAlertview:@"温馨提示" msg:@"该操作将清空所有通话记录,是否继续" btnTitle:@"取消" btnTitle:@"确定" delegate:self tag:486];
}

#pragma mark - ContactDetailViewDelegate
- (void)didUpdateAtIndexSection:(NSInteger)section rowIndex:(NSInteger)idx item:(SearchItem *)searchItem{
    [SettingInfo setContractViewShouldReloadData:YES];
    
    [self searchByPhoneNumber];
    
    [dialTableView reloadData];
}

- (void)didDeleteAtIndexSection:(NSInteger)section rowIndex:(NSInteger)idx{
    [SettingInfo setContractViewShouldReloadData:YES];
    
    [self searchByPhoneNumber];
    
    [dialTableView reloadData];
}

#pragma mark UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    SearchItem *searchItem = [tableDataArray objectAtIndex:actionSheet.tag];
        
    if ([searchItem.contactPhoneArray count] > buttonIndex) {
        [self dialPhone:[searchItem.contactPhoneArray objectAtIndex:buttonIndex] contactID:searchItem.contactID Called:nil];
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    [actionSheet setTag:-1];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            HB_OneKeyCallVC * vc = [[HB_OneKeyCallVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark ABNewPersonViewControllerDelegate Method
//- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
//{
//    
//    switch (newPersonViewController.view.tag) {
//        case 101://新建联系人
//            
//            break;
//        case 102:
//        {
//            if(person){
//                NSInteger recordId = ABRecordGetRecordID(person);
//                //更新数据
//                
//                SearchItem* searchItem = [ContactData getSearchItemByRecordId:recordId];
//                
//                HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
//                
//                [self forceToAddFirstName:searchItem];
//                
//                [delegate updateDialItemInfo:searchItem dialItems:[SettingInfo getDialItems]]; // 更新DialItem
//                
//                [delegate editSearchContactData:searchItem];//修改数据
//                
//                [delegate.mainViewController reChildBuildViewByDetialAdd];   //更新视图数据
//                
//                [Public allocAlertview:@"提示" msg:@"添加完成" btnTitle:@"确定" btnTitle:nil delegate:nil tag:0];
//            }
//            else
//            {
//                //当取消时将监听设置为NO状态
//                [SettingInfo setListenAppChangedAddressbook:NO];
//            }
//        }
//            break;
//        default:
//            if(person){
//                NSInteger recordId = ABRecordGetRecordID(person);
//                //更新数据
//                SearchItem* searchItem = [ContactData getSearchItemByRecordId:recordId];
//                
//                HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
//                
//                [self forceToAddFirstName:searchItem];
//                
//                [delegate updateDialItemInfo:searchItem dialItems:[SettingInfo getDialItems]]; // 更新DialItem
//                
//                [delegate addSearchContactData:searchItem];
//                
//                [delegate.mainViewController reChildBuildViewByDetialAdd];   //更新视图数据
//                [Public allocAlertview:@"提示" msg:@"添加联系人成功!" btnTitle:@"确定" btnTitle:nil delegate:nil tag:0];
//            }
//            break;
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    
//    [self showTabBar];
//    
//}

- (void)presentABNewPersonViewController:(NSString *)strPhone{
    if (IOS_7_SYSTEM) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    HB_ContactDetailController * vc = [[HB_ContactDetailController alloc] init];
    vc.phoneNumFromCallHistory = strPhone;
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [vc release];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
    [nc release];
    
}


#pragma mark 详情界面代理方法
-(void)DialDetailView:(DialDetailViewCtrl *)vc deleteDialItem:(DialItem *)dialItem
{
    for (DialItem * item in dialItemsArray) {
        if ([item.phone isEqualToString:dialItem.phone]&&item.contactID== dialItem.contactID) {
            [dialItemsArray removeObject:item];
            break;
        }
    }
    [SettingInfo setDialItems:dialItemsArray];
}

#pragma mark - 拨号的webView的协议方法 2015.5.11
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"完成了。。。。");
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"完成了。。。。");

}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"玩车工了lll第三方");
    return YES;
}



@end
