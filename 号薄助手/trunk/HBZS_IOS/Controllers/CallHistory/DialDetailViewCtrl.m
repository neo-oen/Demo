//
//  DialDetailViewCtrl.m
//  HBZS_IOS
//
//  Created by yingxin on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialDetailViewCtrl.h"
#import <QuartzCore/QuartzCore.h>
#import "ContactData.h"
#import "HBZSAppDelegate.h"
#import "SettingInfo.h"
#import "Public.h"
#import "MainViewCtrl.h"
#import "DialDetailViewCell.h"
#import "FormatPhoneNumber.h"
#import "UIViewController+TitleView.h"
#import "BaiduMobStat.h"
#import "UtilMacro.h"
#import "UIDevice+Extension.h"
#import "DialDetailHeaderView.h"

#import "HB_ContactInfoVC.h"
#import "HB_ContactDetailController.h"
#import "HB_ContactPreviewVC.h"
#import "AreaQuery.h"
@interface DialDetailViewCtrl ()<UIAlertViewDelegate,HB_ContactDetailDelagete>

- (void)addNewPerson:(NSString*)strPhone;

@end

@implementation DialDetailViewCtrl

@synthesize localDialItem;

-(void)dealloc{
    
    if (localDialItem) {
        [localDialItem release];
        
        localDialItem = nil;
    }
    
    if (detailTableView) {
        [detailTableView release];
        
        detailTableView = nil;
    }
    
    if (formatter) {
        [formatter release];
        
        formatter = nil;
    }
    
    [super dealloc];
}

- (id)initWithDialItem:(DialItem*)dialItem{
    self = [super init];
    
    if(self){
        localDialItem = [[DialItem alloc]init];//[dialItem retain];

        localDialItem.name = dialItem.name;
        
        localDialItem.phone = dialItem.phone;
        
        [localDialItem.times addObjectsFromArray:dialItem.times];
        
        localDialItem.contactID = dialItem.contactID;
        
        [self.view setFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (IOS_7_SYSTEM) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [SettingInfo setListenAppChangedAddressbook:NO];
    
    [self hiddenTabBar];
    SearchItem *searchItem = [ContactData getSearchItemByRecordId:self.localDialItem.contactID];
    if (searchItem.contactID ==-1&&self.localDialItem.contactID>0) {
        self.localDialItem.contactID = -1;
        [detailTableView reloadData];

    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self showTabBar];
}

- (void)titleLeftBackBtnDo{
    [self.navigationController popViewControllerAnimated:YES];

    
}

- (void)allocTableview{
    detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,Device_Width, Device_Height-64) style:UITableViewStyleGrouped];
    
    [detailTableView setBackgroundColor:UIColorWithRGB(243, 243, 243)];
    detailTableView.delegate = self;
    
    detailTableView.dataSource = self;
    
    detailTableView.separatorStyle = NO;
    
    [self.view addSubview:detailTableView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColorWithRGB(243, 243, 243)];
    [self setVCTitle:@"通话记录"];
  
    formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    [self allocTableview];
    
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark UITableViewDelegate UITableViewDataSource Method

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    cell.backgroundColor = ((indexPath.row % 2) == 0) ? UIColorWithRGB(243, 243, 243) : UIColorWithRGB(237, 237, 237);
    cell.backgroundColor = UIColorWithRGB(243, 243, 243);
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (section == 2) {
        return localDialItem.times.count;
    }
    else
    {
        return 0;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (localDialItem.contactID ==-1) {
        if (section == 0) {
            return 0.01f;
        }
        
    }
    else
    {
        if (section == 3||section == 4) {
            return 0.01f;
        }
    }
    if (section == 2) {
        return 0.01;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 60.0f;
    
    
    return rowHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (localDialItem.contactID ==-1) {
        if (section == 0) {
            return 0.01f;
        }
        
    }
    else
    {
        if (section == 3||section == 4) {
            return 0.01f;
        }
    }
    if (section == 2) {
        return 0.01;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(55, 0, Device_Width-60-15, 1)];
    
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.3;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:lineView];
    
    [lineView release];
    if (localDialItem.contactID ==-1) {
        if (section == 0) {
            lineView.hidden = YES;
        }
        
    }
    else
    {
        if (section == 3||section == 4) {
            lineView.hidden = YES;

        }
    }
    return footerView;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    switch (section) {
        case 0:
        {
            if (localDialItem.contactID != -1) {
                view = [self createNameheaderView];
            }
        }
            break;
        case 1:
        {
            view = [self createnumberHeaderView];
        }
            break;
        case 2:
        {
            view = [self createDialItemTimesHeaderView];
        }
            break;
        case 3:
        {
            if (localDialItem.contactID == -1) {
                view = [self createAddnewContactHeaderView];
            }
        }
            break;
        case 4:
        {
            if (localDialItem.contactID == -1) {
                view = [self createAddlocalHeaderView];
            }
        }
            break;
        case 5:
        {
            view = [self createDeleteHeaderView];
        }
            break;

        default:
            break;
    }
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DialDetailViewCell *cell;

    if (indexPath.section == 2) {
        
        static NSString *CellIdentifier = @"DetailViewcell";
        
        cell = (DialDetailViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            cell= [[[DialDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.dateLabel.text = [self setDate:indexPath.row];
        cell.timeLabel.text = [self setTime:indexPath.row];
        
    }
    return cell;
}

-(NSString *)setDate:(NSInteger)timesrow
{
    
    NSDate * now = [NSDate date];
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:[localDialItem.times objectAtIndex:timesrow]]/(24*60*60);
    
    if (timeBetween<1) {
        return @"今天";
    }
    else if(timeBetween>1&&timeBetween<=2)
    {
        return @"昨天";
    }
    else
    {
        NSMutableString * str = [NSMutableString stringWithString:[self dateToString:[localDialItem.times objectAtIndex:timesrow]]];
        return [[str componentsSeparatedByString:@" "] firstObject];

    }
    
}

-(NSString *)setTime:(NSInteger)timesrow
{
    NSMutableString * str = [NSMutableString stringWithString:[self dateToString:[localDialItem.times objectAtIndex:timesrow]]];
    
    return [[str componentsSeparatedByString:@" "] lastObject];
}

- (NSString*)dateToString:(NSDate*)date{
    NSString *dateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    return dateString;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 添加新联系人
- (void)addNewPerson:(NSString*)strPhone{

}

- (void)forceToAddFirstName:(SearchItem *)searchItem{
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //无姓名用户强制加姓名
    if (searchItem.contactFirstName == nil && searchItem.contactLastName == nil) {
        if ([searchItem.contactPhoneArray count]>0) {
            searchItem.contactFirstName = [searchItem.contactPhoneArray objectAtIndex:0];
        }
        else if([ContactData getRecordEmailByID:searchItem.contactID]){
            searchItem.contactFirstName = [ContactData getRecordEmailByID:searchItem.contactID];
        }
        else {
            searchItem.contactFirstName = @"未命名" ;
        }
        
        ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
        
        ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, searchItem.contactID);
        
        ABRecordSetValue(personRef, kABPersonFirstNameProperty, searchItem.contactFirstName, nil);
        
        ABAddressBookSave(addressBookRef, nil);
    }
}


#pragma mark initview

-(UIView *)createNameheaderView
{
    DialDetailHeaderView * view = [[[DialDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 60)] autorelease];
    view.leftImageView.image = [UIImage imageNamed:@"系统头像"];
    [view.titlebtn setTitle:localDialItem.name forState:UIControlStateNormal];
    [view.titlebtn addTarget:self action:@selector(dialDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.titlebtn setTitleColor:[UIColor grassColor] forState:UIControlStateNormal];
    view.titlebtn.tag = DialDetailBtnContact;
    return view;

}

-(UIView *)createnumberHeaderView
{
    DialDetailHeaderView * view = [[[DialDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 60)] autorelease];
    view.leftImageView.image = [UIImage imageNamed:@"电话"];
    
    [view.titlebtn setTitle:localDialItem.phone forState:UIControlStateNormal];
    view.titlebtn.center = CGPointMake(view.titlebtn.center.x, view.titlebtn.center.y-10);
    [view.titlebtn addTarget:self action:@selector(dialDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.titlebtn setTitleColor:[UIColor grassColor] forState:UIControlStateNormal];
    view.titlebtn.tag = DialDetailBtnDial;
    
    
//    [Public setButtonBackgroundImage:@"" highlighted:nil button:view.rightbtn];
    [view.rightbtn setImage:[UIImage imageNamed:@"短信"] forState:UIControlStateNormal];
    view.rightbtn.tag = DialDetailBtnMessge;
    [view.rightbtn addTarget:self action:@selector(dialDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    view.numberTypelab.text = [NSString stringWithFormat:@"呼出"];
    view.Attributionlab.text = [[AreaQuery getInstance]queryAreaByNumber:localDialItem.phone];
    return view;
}

-(UIView *)createDialItemTimesHeaderView
{
    DialDetailHeaderView * view = [[[DialDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 60)] autorelease];
    view.leftImageView.image = [UIImage imageNamed:@"时间"];
    return view;
}

-(UIView *)createAddnewContactHeaderView
{
    DialDetailHeaderView * view = [[[DialDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 60)] autorelease];
    view.leftImageView.image = [UIImage imageNamed:@"创建联系人"];
    
    [view.titlebtn setTitle:@"创建联系人" forState:UIControlStateNormal];
    [view.titlebtn addTarget:self action:@selector(dialDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.titlebtn setTitleColor:[UIColor grassColor] forState:UIControlStateNormal];

    view.titlebtn.tag = DialDetailBtnAddnew;

    return view;
}

-(UIView *)createAddlocalHeaderView
{
    DialDetailHeaderView * view = [[[DialDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 60)] autorelease];
    view.leftImageView.image = [UIImage imageNamed:@"添加到已有联系人"];
    
    [view.titlebtn setTitle:@"添加到现有联系人" forState:UIControlStateNormal];
    [view.titlebtn addTarget:self action:@selector(dialDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.titlebtn setTitleColor:[UIColor grassColor] forState:UIControlStateNormal];
    view.titlebtn.tag = DialDetailBtnAddLocal;
    
    return view;
    

}

-(UIView *)createDeleteHeaderView
{
    DialDetailHeaderView * view = [[[DialDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 60)] autorelease];
    
    [view.titlebtn setTitle:@"删除记录" forState:UIControlStateNormal];
    [view.titlebtn addTarget:self action:@selector(dialDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.titlebtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    view.titlebtn.tag = DialDetailBtnDelete;

    
    view.leftImageView.image = [UIImage imageNamed:@"删除可点击"];
    return view;
}

-(void)dialDetailButtonClick:(UIButton *)button
{
    switch (button.tag) {
        case DialDetailBtnContact:
        {
            [self pushToContactInfo];
        }
            break;
        case DialDetailBtnDial:
        {
            [self dialPhone:localDialItem.phone contactID:localDialItem.contactID Called:^{
                [self reloadLocalDialItem];
            }];
        }
            break;
        case DialDetailBtnMessge:
        {
            NSArray * phones = [NSArray arrayWithObjects:localDialItem.phone, nil];
            [self doSendMessage:phones];
        }
            break;
        case DialDetailBtnAddnew:
        {
            HB_ContactDetailController * vc = [[HB_ContactDetailController alloc] init];
            vc.delegate = self;
            vc.phoneNumFromCallHistory = localDialItem.phone;
            UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
            [vc release];
            [self presentViewController:nc animated:YES completion:^{
                
            }];
            [nc release];
        }
            break;
        case DialDetailBtnAddLocal:
        {
            HB_ContactPreviewVC * vc = [[HB_ContactPreviewVC alloc] init];
            vc.phoneNumStr = localDialItem.phone;
            vc.tempdelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
            break;
        case DialDetailBtnDelete:
        {
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定需要删除此条通话记录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [al show];
            [al release];
            
        }
            break;
        default:
            break;
    }
}

-(void)pushToContactInfo
{
    HB_ContactInfoVC * vc = [[HB_ContactInfoVC alloc] init];
    vc.recordID = localDialItem.contactID;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.DialDetaiDelegate DialDetailView:self deleteDialItem:self.localDialItem];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)ContactDetailController:(HB_ContactDetailController *)ContactDetailController SavedContact:(NSInteger)contactId
{
    //联系人保存后 更新本记录电话id
    localDialItem.contactID = contactId;
    [self updateViewAnddata];
}

-(void)updateViewAnddata
{
    ///contact小于0时
    if (self.localDialItem.contactID>0) {
        HBZSAppDelegate * delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
        SearchItem *searchItem = [ContactData getSearchItemByRecordId:self.localDialItem.contactID];
        
        //    [self forceToAddFirstName:searchItem];
        
        [delegate updateDialItemInfo:searchItem dialItems:[SettingInfo getDialItems]];  //更新DialItem
        
        [delegate addSearchContactData:searchItem];
        
        NSString* lastname = searchItem.contactFirstName;
        
        NSString* firstname = searchItem.contactLastName;
        
        NSString* name = nil;
        
        if(lastname != nil && firstname != nil){
            name = [NSString stringWithFormat:@"%@ %@",lastname,firstname];
        }
        else if(lastname != nil){
            name = lastname;
        }
        else if(firstname != nil){
            name = firstname;
        }
        else{
            name = localDialItem.phone;
        }
        
        localDialItem.name = name;
        
        [SettingInfo dialItemBecomeContractItem:localDialItem.phone name:name cid:searchItem.contactID];
        
        //更新视图数据
        [detailTableView reloadData];
    }
}

-(void)reloadLocalDialItem
{
    DialItem * item = [SettingInfo getDialItemBy:self.localDialItem.phone andId:self.localDialItem.contactID];
    if (item) {
        self.localDialItem = item;
        [detailTableView reloadData];
    }
}


@end
