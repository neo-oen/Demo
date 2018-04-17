//
//  MainViewCtrl.m
//  HBZS_IOS
//
//  Created by yingxin on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewCtrl.h"
#import "HBZSAppDelegate.h"
#import "GobalSettings.h"

#import "SyncLogItem.h"
#import "SyncEngine.h"
#import "SyncErr.h"

#import "HB_MachineDataModel.h"

#import "MemAddressBook.h"
#import "Public.h"
//#import "SyncEngineImpl.h"
#import "AccountVc.h"
#define kTriggerOffSet 100.0f

#define oneDayTimeintervla 86400
@interface MainViewCtrl ()<UIAlertViewDelegate>

@end

@implementation MainViewCtrl

@synthesize nextViewController1;

@synthesize nextViewController2;

@synthesize disableTouch;

//@class MainViewCtrl;// 遇到相互包含的问题了

static MainViewCtrl * mainvc;
+(MainViewCtrl *)shareManager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainvc  = [[MainViewCtrl alloc] init];
    });
    return mainvc;
}

- (void)dealloc{
    
    [nextViewController1 release];
    nextViewController1 = nil;
    [nextViewController2 release];
    nextViewController2 = nil;
    [lifeChannelVC release];
    lifeChannelVC = nil;
    [moreVC release];
    moreVC = nil;
    
    [self removeObserver:self forKeyPath:@"ContactChangers"];
    [super dealloc];
}



- (void)allocNextViewController1{
    nextViewController1 = [[DialViewCtrl alloc] init];
    
    nextViewController1.view.frame = CGRectMake(0, 0, Device_Width, Device_Height);
    
    [nextViewController1.view setBackgroundColor:[UIColor whiteColor]];
    
    nextViewController1.leftBtnIsBack = NO;
}

- (void)allocNextViewController2{
    nextViewController2 = [[HB_ContactListVC alloc] init];
    
}



- (void)allocMoreVC{
    moreVC = [[HB_MoreViewController alloc]init];
    moreVC.leftBtnIsBack = NO;
}

- (void)allocLifeChannelVC{
    lifeChannelVC = [[HB_LifeViewController alloc]init];
    lifeChannelVC.leftBtnIsBack = NO;
}
- (id)init{
    
    self = [super init];
    
    if (self) {
        [self allocNextViewController1];
        
        [self allocNextViewController2];
        
        [self allocLifeChannelVC];
        [self allocMoreVC];
        groupEditing = NO;
//        curIndex = 1;
        [self addObserver:self forKeyPath:@"ContactChangers" options:NSKeyValueObservingOptionNew context:NULL];
        
        
#pragma mark 进入程序第一次自己检测
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if ([SettingInfo getIsAutosyn]&&[SettingInfo getAccountState]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self StartAutoSyncByType];
                });
            }
            
        });
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
    
    
    
    

}

-(void)StartAutoSyncByType
{
    NSInteger autoSyncType = [SettingInfo getAutoSyncType];
    
    if (autoSyncType == 0) {
        [self UpdataContactChanges];
    }
    else
    {
        
        NSString * freqString = nil;
        NSInteger frequency;
        if (autoSyncType == 1) {
            //每天
            frequency = oneDayTimeintervla;
            freqString = @"一天";
        }
        else if (autoSyncType == 2) {
            //每周
            frequency = oneDayTimeintervla *7;
            freqString = @"一周";
        }
        else if (autoSyncType == 3) {
            
            //每月
            frequency = oneDayTimeintervla *30;
            freqString =@"一个月";
        }
        
        NSDate * lastSyncdate = [SettingInfo getlastSyncdate];
        NSInteger sinceLastSynctimeIntervla = [[NSDate date] timeIntervalSince1970]- [lastSyncdate timeIntervalSince1970];
        
        if (sinceLastSynctimeIntervla >=frequency) {
            NSString * str = [NSString stringWithFormat:@"距上次备份超过%@,是否立即进行自动备份",freqString];
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"自动备份提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"否",@"是", nil];
            al.delegate = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [al show];
                [al release];
            });
        }
    }
}

-(void)UpdataContactChanges
{
    if (![SettingInfo getIsAutosyn]) {
        //判断是否开启自动同步
        return;
    }
    if ([[HBZSAppDelegate getAppdelegate] isSyncOperatingOrRemovingRepead]) {
        //在备份过程或者去重过程中不进行
        return;
    }
    self.ContactChangers = [[MemAddressBook getInstance] getContactChangesCount];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSInteger changes = [[change objectForKey:@"new"] integerValue];
    NSLog(@"%ld",[[change objectForKey:@"new"] integerValue]);
    if (changes == -1) {
        [self starAutoSync:1];
    }
    else if (changes>=10)
    {
        [self starAutoSync:2];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [delegate setTabBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -
#pragma mark pop and push idxview
- (void)popOldAndpushNewByindex:(int)idx
{
    curIndex = idx;
    
    HBZSAppDelegate *appDelegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navController popToRootViewControllerAnimated:NO];
    
    UIViewController * nextctrl = nil;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    switch (idx) {
        case 0:{
            nextctrl = nextViewController1;
            break;
        }
        case 1:{
            nextctrl = nextViewController2;
            break;
        }
       
        case 2:{
            nextctrl = lifeChannelVC;
            break;
        }
        case 3:{
            nextctrl = moreVC;
            break;
        }
        default:
            break;
    }
    
    if (appDelegate.navController) {
       
        [appDelegate.navController pushViewController:nextctrl animated:NO];
    }
}

-(void)SaveLastPageNum
{
    [SettingInfo setLastPageNum:curIndex + 100];
}

#pragma mark dialKeyBoardHide
- (void)dialKeyBoardHide:(BOOL)bhide{
    if (nextViewController1) {
        [nextViewController1.dialKeyBoardView setHidden:bhide animated:YES];
    }
}

#pragma mark touches event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (curIndex!=1) {
        return ;
    }
    
    if (disableTouch) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    HBZSAppDelegate *appDelegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    touchBeganPoint = [touch locationInView:[appDelegate window]];
}

// Scale or move select view when touch moved (Add by Ethan, 2011-11-27)
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    return;//2015.4.21,取消侧滑菜单

    if (curIndex!=1) {
        return ;
    }
    
    if (disableTouch) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
  //  nextViewController2.mybook.allowsSelection = NO;
    
    HBZSAppDelegate *appDelegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGPoint touchPoint = [touch locationInView:[appDelegate window]];
    
    CGFloat xOffSet = touchPoint.x - touchBeganPoint.x;
    
    if (xOffSet < 0) {
        //    [appDelegate makeRightViewVisible];
        //设置tableView禁止上下滚动
        //    [nextViewController2.mybook setScrollEnabled:NO];
    }
    else if (xOffSet > 0) {
        [appDelegate makeLeftViewVisible];
        //设置tableView禁止上下滚动
       // [nextViewController2.mybook setScrollEnabled:NO];
        
        
        self.navigationController.view.frame = CGRectMake(xOffSet,
                                                          self.navigationController.view.frame.origin.y,
                                                          self.navigationController.view.frame.size.width,
                                                          self.navigationController.view.frame.size.height);
        
        //move TabBar
        HBZSAppDelegate* delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        delegate.tabBar.frame = CGRectMake(xOffSet,
                                           delegate.tabBar.frame.origin.y,
                                           delegate.tabBar.frame.size.width,
                                           delegate.tabBar.frame.size.height);
    }
}



// reset indicators when touch ended
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (curIndex!=1) {
        return ;
    }
    
    if (disableTouch) {
        return;
    }
    
    // animate to left side
    if (self.navigationController.view.frame.origin.x < -kTriggerOffSet)
        [self moveToLeftSide];
    // animate to right side
    else if (self.navigationController.view.frame.origin.x > kTriggerOffSet)
        [self moveToRightSide];
    // reset
    else
        [self restoreViewLocation];
}

#pragma mark -
#pragma mark Other methods
// restore view location
- (void)restoreViewLocation {
    //Added on Nov.17 2013
    mainViewIsOutOfStage = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigationController.view.frame = CGRectMake(0,
                                                                           self.navigationController.view.frame.origin.y,
                                                                           self.navigationController.view.frame.size.width,
                                                                           self.navigationController.view.frame.size.height);
                         
                         //move TabBar
                         HBZSAppDelegate* delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate] ;
                         delegate.tabBar.frame = CGRectMake(0, delegate.tabBar.frame.origin.y, delegate.tabBar.frame.size.width, delegate.tabBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         HBZSAppDelegate *appDelegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
                         UIControl *overView = (UIControl *)[[appDelegate window] viewWithTag:10086];
                         [overView removeFromSuperview];
                         
                         [appDelegate makeShadowDisable];
                     }];
}

// move view to left side
- (void)moveToLeftSide {
    return;//2015.4.21,取消侧滑菜单
    
    mainViewIsOutOfStage = YES;
    
    [self animateMainViewToSide:CGRectMake(-220.0f,
                                           self.navigationController.view.frame.origin.y,
                                           self.navigationController.view.frame.size.width,
                                           self.navigationController.view.frame.size.height)];
}

// move view to right side
- (void)moveToRightSide {
    return;//2015.4.21,取消侧滑菜单
    
    mainViewIsOutOfStage = YES;
    
    if (groupEditing) {
        [self animateMainViewToSide:CGRectMake(183.0f,
                                               self.navigationController.view.frame.origin.y,
                                               self.navigationController.view.frame.size.width,
                                               self.navigationController.view.frame.size.height)];
    }
    else{
        [self animateMainViewToSide:CGRectMake(130.0f,
                                               self.navigationController.view.frame.origin.y,
                                               self.navigationController.view.frame.size.width,
                                               self.navigationController.view.frame.size.height)];
    }
}

- (void)moveToGroupEdit{
    return;//2015.4.21,取消侧滑菜单

    mainViewIsOutOfStage = YES;
   
    groupEditing = YES;
    
    [self animateMainViewToSide:CGRectMake(183.0f,
                                           self.navigationController.view.frame.origin.y,
                                           self.navigationController.view.frame.size.width,
                                           self.navigationController.view.frame.size.height)];
}

// animate home view to side rect
- (void)animateMainViewToSide:(CGRect)newViewRect {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.navigationController.view.frame = newViewRect;
                         
                         //move TabBar
                         HBZSAppDelegate* delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate] ;
                         delegate.tabBar.frame = CGRectMake(newViewRect.origin.x, delegate.tabBar.frame.origin.y, delegate.tabBar.frame.size.width, delegate.tabBar.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         HBZSAppDelegate *appDelegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
                         
                         UIControl *overView = (UIControl *)[[appDelegate window] viewWithTag:10086];
                         
                         if (overView) {
                             overView.frame = self.navigationController.view.frame;
                         }else {
                             UIControl *overView = [[UIControl alloc] init];
                             overView.tag = 10086;
                             overView.backgroundColor = [UIColor clearColor];
                             overView.frame = self.navigationController.view.frame;
                             [overView addTarget:self action:@selector(overViewAction:) forControlEvents:UIControlEventTouchDown];
                             [[appDelegate window] addSubview:overView];
                             [overView release];
                         }
                         
                     }];
}

- (void)overViewAction:(UIControl*)sender{
    [sender removeFromSuperview];
    
    [self restoreViewLocation];
}

#pragma mark -
#pragma mark action

//- (void)groupSelectedIndex:(NSInteger)idx groupName:(NSString*)gname{
//    if (nextViewController2) {
//        [nextViewController2 groupSelectedIndex:idx groupName:gname];
//    }
//}
//
//- (void)groupDeleteGroupId:(NSInteger)gid{
//    if (nextViewController2) {
//        [nextViewController2 groupDeleteGroupId:gid ];
//    }
//}

//- (void)noticeBySyncEvent:(id)event{
//    if (nextViewController4)
//        [nextViewController4 noticeBySyncEvent:event];
//}

#pragma mark - 
#pragma mark reBuildContractViewAndData
//- (void)reBuildData{  //Added by kevin on July,7 2013
//    if (nextViewController2) {
//        [nextViewController2 reBuildData];
//    }
//}
//
//- (void)reBuildViewAndData {
//    if (nextViewController2)
//        [nextViewController2 reBuildViewAndData];
//}
//
//- (void)initGroupContactTableData{  //Added by kevin on July,6
//    if (nextViewController2)
//        [nextViewController2 initGroupContactTableData];
//}
//
//- (void)reChildBuildViewByDetialAdd {
//    if (nextViewController2)
//        [nextViewController2 reBuildViewByDetialAdd];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 500) {
        if (buttonIndex == 1) {
            AccountVc * vc = [[AccountVc alloc] init];
            [self.currentVc.navigationController pushViewController:vc animated:YES];
            [vc release];
            
        }
        if (self.currentVc) {
            self.currentVc  = nil;
        }
        
        
    }
    
    else
    {
        
        switch (buttonIndex) {
            case 1:
            {
                HBZSAppDelegate *delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication] delegate];
                
                [delegate setSyncViewController:self];
                [delegate setIsSyncOperatingOrRemovingRepead:YES];
                StartSync(TASK_DIFFER_SYNC);
                
                
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)starAutoSync:(NSInteger)AutosyncType
{
    NSString  * str;
    if (AutosyncType ==1) {
        str = @"检测到您本机还没备份过，是否进行静默备份？你可以在设置中取消自动同步";
    }
    else if (AutosyncType ==2)
    {
        str = @"检测到您的通讯录有10个以上变化，是否进行静默备份？你可以在设置中取消自动同步";
    }
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"自动备份提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"否",@"是", nil];
    al.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [al show];
        [al release];
    });

}

#pragma mark 静默同步回调

- (void)noticeBySyncEvent:(id)event{
    
    SyncStatusEvent* curEvent = (SyncStatusEvent*)event;
    
    switch (curEvent->status) {
        case Sync_State_Initiating:{
            break;
        }
        case Sync_State_Connecting:{
            break;
        }
        case Sync_State_Uploading:{
            
            break;
        }
        case Sync_State_Downloading:{
            
            break;
        }
        case Sync_State_Portrait_Uploading:{
        }
            break;
            
        case Sync_State_Portrait_Downloading:{
        }
            break;
        case Sync_State_Success:{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self alertResult];
            });
            break;
        }
        case Sync_State_Faild:{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self alertResult];
            });
            break;
        }
        default:
            break;
    }
}

- (void)alertResult{
    SyncStatusEvent* curEvent;
    
    curEvent = GetSyncStatus();
    
//    bDataFirst = NO;
    //    bHeadDataFirst = NO;
    
    
    SyncLogItem* syncLog = [[SyncLogItem alloc]init];
    
    [syncLog setStartTime:[self getLogTime:[SettingInfo getSyncLastBeganTime]]];
    
    [syncLog setEndTime:[self getLogTime:[NSDate date]]];
    
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    switch (curEvent->taskType) {
        case TASK_ALL_UPLOAD:
            [syncLog setSyncType:@"全量上传"];
            break;
        case TASK_ALL_DOWNLOAD:
            [syncLog setSyncType:@"全量下载"];
            [delegate addressBookRevert];
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            break;
        case TASK_SYNC_UPLOAD:
            [syncLog setSyncType:@"增量上传"];
            break;
        case TASK_SYNC_DOANLOAD:
            [syncLog setSyncType:@"增量下载"];
            [delegate addressBookRevert];
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            [USERDEFAULTS setBool:NO forKey:@"ISNeedInitAddressBookRef"];
            [USERDEFAULTS synchronize];
            
            
            break;
        case TASK_DIFFER_SYNC:
            [syncLog setSyncType:@"同步"];
            [delegate addressBookRevert];
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            [USERDEFAULTS setBool:NO forKey:@"ISNeedInitAddressBookRef"];
            [USERDEFAULTS synchronize];
            
            break;
        case TASK_MERGE_SYNC:
            [syncLog setSyncType:@"慢同步"];
            [delegate addressBookRevert];
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            [USERDEFAULTS setBool:NO forKey:@"ISNeedInitAddressBookRef"];
            [USERDEFAULTS synchronize];
            
            break;
        default:
            [syncLog setSyncType:@"其他"];
            break;
    }
    
    if (curEvent->status == Sync_State_Success){
        [SettingInfo syncEnd];
        
        [syncLog setSyncResult:@"任务成功"];
        
        //通知UI更新联系人
        [SettingInfo setContractViewShouldReloadData:YES];

#pragma mark 时光机数据保存
        SyncTaskType type = curEvent->taskType;
        switch (type) {
            case TASK_ALL_DOWNLOAD:
            case TASK_SYNC_DOANLOAD:
            case TASK_DIFFER_SYNC:
            case TASK_MERGE_SYNC:
                [[HB_MachineDataModel getglobalMachineModel] globalTimeMachineSave];
                break;
                
            default:
                break;
        }
    }
    else  if (curEvent->status == Sync_State_Faild&&curEvent->reason==GENERAL_ERROR_PASSWORD){
        

        [[ConfigMgr getInstance] setValue:@"" forKey:@"pimaccount" forDomain:nil];
        
        [[ConfigMgr getInstance] setValue:@"" forKey:@"pimpassword" forDomain:nil];
        
        [[ConfigMgr getInstance] setValue:@"" forKey:@"user_name" forDomain:nil];
        
        [[ConfigMgr getInstance] setValue:@"" forKey:@"user_psw" forDomain:nil];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setBool:NO forKey:AccountRowIsRefresh];
        [user synchronize];
        
        [syncLog setSyncResult:@"帐号或密码错误，请重新输入"];
        
        
    }
    else if(curEvent->status == Sync_State_Faild){
        
        [syncLog setSyncResult:@"任务失败"];
    }
    
    //加入一条日志
    [SettingInfo addSyncLog:syncLog];
    
    [syncLog release];
    
    //记录上次备份时间
    [SettingInfo setlastSyncdate:[NSDate date]];

    [delegate setIsSyncOperatingOrRemovingRepead:NO];
    
    
    CancelSyncTask();  //Added by kevin on June,19 2013
}

- (NSString*)getLogTime:(NSDate*)date{
    if (date == nil) {
        return @"";
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    [formatter release];
    
    return dateString;
}
-(BOOL)isAccount:(id)currentVc
{
    BOOL isAcc = [SettingInfo getAccountState];
    if (!isAcc) {
        self.currentVc = currentVc;
        [Public allocAlertview:@"提示" msg:@"您还没有登录,请先登录!" btnTitle:@"取消" btnTitle:@"去登录" delegate:self tag:500];
    }
    return isAcc;
}

@end
