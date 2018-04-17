 //
//  AppDelegate.m
//  HBZS_IOS
//
//  Created by yingxin on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HBZSAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MainViewCtrl.h"
#import "BaseViewCtrl.h"
#import "SyncEngine.h"
#import "GobalSettings.h"
#import "SettingInfo.h"
#import "AreaQuery.h"
#import "ContactPeople.h"
#import "Public.h"
#import "Reachability.h"
#import "UncaughtExceptionHandler.h"
#import "DialViewCtrl.h"
#import "GetSplashProto.pb.h"
#import "VendorMacro.h"
#import "BaiduMobStat.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "VendorMacro.h"
#import "UIDevice+Reachability.h"
#import "UIDevice+Extension.h"
#import "ZBLog.h"
#import "UIAlertView+Extension.h"
#import "FetchDynamicLaunchImgRequest.h"
#import "GuidePageViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "SettingInfo.h"
#import "GroupData.h"

//友盟  2015.8.25 -yx
#import "UMSocial.h"
#import "UMSocialYixinHandler.h"
#import "UMSocialWechatHandler.h"
#import "HB_share.h"

//时光机
#import "HB_MachineDataModel.h"

#import "SettingInfo.h"
#import "HB_httpRequestNew.h"
#import "SVProgressHUD.h"

@implementation HBZSAppDelegate


@synthesize window = _window;

@synthesize launchImgData;

@synthesize gapHeight;

@synthesize operateWindow;
@synthesize operateWindow2;

@synthesize contactDic;

@synthesize navController;

@synthesize leftViewController;
@synthesize rightViewController;

@synthesize mainViewController;

@synthesize tabBar;


@synthesize searchContactArray;

@synthesize setViewInstance;

//@synthesize isSyncOperatingOrRemovingRepead;
//            isSyncOperatingOrRemovingRepead;
@synthesize messageCenterVC;

@synthesize fetchNewMessageTimer;

- (void)dealloc
{
//    [leftViewController release];
//    [rightViewController release];
    [mainViewController release];
    [navController release];
    
    [self.tabBar removeFromSuperview];
    
    [_window release];
    
    if (searchContactArray != nil) {
        [searchContactArray removeAllObjects];
        
        [searchContactArray release];
        
        searchContactArray = nil;
    }
    
    [self releaseAddressBookRef];
    
    [super dealloc];
}

+(HBZSAppDelegate *)getAppdelegate
{
    HBZSAppDelegate * delegate = (HBZSAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}
//- (void)setisSyncOperatingOrRemovingRepead:(BOOL)isSyncingOrRemoving{
//    isSyncOperatingOrRemovingRepead = isSyncingOrRemoving;
//}

- (void)launchWithOptions{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GuidePageIsDisplayFinsh" object:nil];
    
    [self registerBaiduMobStat];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSomethingWhenEndLoadingContactData:)
                                                 name:@"EndLoadingContactNotification"
                                               object:nil];
    

    
    mainViewController = [MainViewCtrl shareManager];
    
    navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = navController;
    [navController release];
    

    
#pragma mark 实例化tabbar
    self.tabBar = [MyTabBar shareManger];

    self.tabBar.delegate = self;
    

    [self.window.rootViewController.view addSubview:self.tabBar];
    [self.tabBar release];
    [self.tabBar createTabViewandShowSelected];
    
    if (IOS_7_SYSTEM) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

#pragma mark ----------------------------------
#pragma mark ****** UIApplicationDelegate *****
#pragma mark ----------------------------------

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [NSThread sleepForTimeInterval:1.0];
//    [_window makeKeyAndVisible];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor=[UIColor clearColor];
    if(IOS_7_SYSTEM)
    {
        self.window.rootViewController = [[[UIViewController alloc] init] autorelease];
    }
    //注册友盟
    [HB_share RegisterUMShare];
       
    [application setStatusBarHidden:YES];
    

    _isSyncOperatingOrRemovingRepead = NO;
 
//    InstallUncaughtExceptionHandler();
    

    
//创建数据库
    [self createMessageCenterDatabase];
    [HB_MachineDataModel createTimeMachineDb];
    

    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"IsFirstInstall"];

    if ([self isNewVersionClint]) {
        
        //默认显示无号码联系人
        [SettingInfo setIsShowNoNumberContact:YES];
        
        [userDefaults synchronize];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(launchWithOptions) name:@"GuidePageIsDisplayFinsh"
                                                   object:nil];
        GuidePageViewController *guideVC = [[GuidePageViewController alloc]initWithNibName:nil bundle:nil];
        self.window.rootViewController = guideVC;
        
        
        [guideVC release];
    }
    else{
        
        NSString *launchImgPath = [FetchDynamicLaunchImgRequest LaunchImgPath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:launchImgPath] && [LaunchViewController isInEndDate]) {
            launchImgData = [[NSData alloc]initWithContentsOfFile:launchImgPath];
            launchVC = [[LaunchViewController alloc]initWithLauchImgData:launchImgData];
            
            int displayTime = [[[ConfigMgr getInstance]getValueForKey:@"displayTime" forDomain:nil] intValue];
            
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:displayTime target:self selector:@selector(launchWithOptions) userInfo:nil repeats:NO];
            launchVC.playtimer = timer;
            launchVC.playCountdouw = displayTime;
            launchVC.skipBlock = ^(){
                [self launchWithOptions];
            };
            
            self.window.rootViewController = launchVC;
            [launchImgData release];
            [launchVC release];
        }
        else{
            [self launchWithOptions];
        }

    }
    
    [self RegisterApns:application];
    
    [self provingAccoutInfo];
    [self.window makeKeyAndVisible];
    

    [self setupNavigationBarAppearance];
    
	return YES;
}

-(void)setupNavigationBarAppearance{
    //1.统一设置导航栏的属性
    UINavigationBar * navigationBar=[UINavigationBar appearance];
    
    //    navigationBar.translucent = YES;
    
    
    
    //1.1标题属性
    NSMutableDictionary * attributeDict=[[NSMutableDictionary alloc]init];
    attributeDict[NSFontAttributeName]=[UIFont boldSystemFontOfSize:20];
    attributeDict[NSForegroundColorAttributeName]=COLOR_I;
    [navigationBar setTitleTextAttributes:attributeDict];
    navigationBar.tintColor=COLOR_I;
    
    //    navigationBar.barTintColor  = COLOR_B;
    //1.2背景图
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    //2.navigationBarItem属性设置
    UIBarButtonItem * item =[UIBarButtonItem appearance];
    NSMutableDictionary * itemDict=[[NSMutableDictionary alloc]init];
    itemDict[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    itemDict[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [item setTitleTextAttributes:itemDict forState:UIControlStateNormal];
    [itemDict release];
}
#pragma mark 注册推送消息

-(void)RegisterApns:(UIApplication *)application
{
    if ([SYSTEMVERSION floatValue]>=10.0) {
        //ios 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
//                [[UIApplication sharedApplication] registerForRemoteNotifications];
                NSLog(@"succeeded!");
            }
        }];
        
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
        
       
    }
    else if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [application registerForRemoteNotifications];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
    }
}


-(BOOL)isNewVersionClint
{
    NSMutableString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger currentVersionNum= [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    
    NSInteger lastVersion = [SettingInfo getLastVersion];
    
    return (currentVersionNum >lastVersion);
}


//版本号处理
-(void)VersionDeal
{
    if ([self isNewVersionClint]) {
        //版本有更新
        NSMutableString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSInteger currentVersionNum= [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
        [SettingInfo saveLastVersion:currentVersionNum];

        if([SettingInfo getAccountState]) {
            //更新后如果是登录状态
            
            //判断登录数据是否完整
            NSString *account = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];
            if (!account.length) {
                [SettingInfo setAccountState:NO];
                return;
            }
            //
            
            HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
            
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showWithStatus:@"数据更新中"];
            [req getMyCardformServerResult:^(BOOL isisSuccess) {
                [SVProgressHUD dismiss];
                if (!isisSuccess) {
                    [SettingInfo setAccountState:NO];
                }
                
            }];
        
            
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    [YXApi handleOpenURL:url delegate:self];
    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
//    [YXApi handleOpenURL:url delegate:self];
    
    return [UMSocialSnsService handleOpenURL:url];
}

//本地推送  响应方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

    NSDictionary *userInfo = notification.userInfo;
    
    if ([[userInfo objectForKey:@"BackupReminderNotification"] isEqualToString:@"BackupReminderNotification"]) {
        NSLog(@"didReceiveLocalNotification: %@", notification.alertBody);
        BOOL isSuccess = [db executeUpdate:@"insert into SystemMessage (content) values(?)", notification.alertBody];
        
        if (!isSuccess) {
            NSLog(@"didReceiveLocalNotification Insert failed....");
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	ZBLog(@"applicationWillResignActive");
    
    if (operateWindow) {
        [operateWindow removeFromSuperview];
        operateWindow = nil;
    }
    
    if (operateWindow2) {
        [operateWindow2 removeFromSuperview];
        operateWindow2 = nil;
    }
    
    gapHeight = 0;
    
#pragma mark app将要进入后台时 更新消息数量提醒图标
    
    PushManager * manager = [PushManager shareManager];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [manager getNoReadMessagesCount];
    
    
#pragma mark 2015.5.11 添加，主要为了记录应用是否是因为拨号而进入的后台,1表示程序是因为拨号而进入的后台
    //相应的，当程序进入前台时候，执行block，并且要把isCall的值改为0
    if ([SYSTEMVERSION floatValue]>=8.0) {
        CTCallCenter *callCenter = [UIDevice checkDeviceCallState];
        NSArray *calls = [callCenter.currentCalls  allObjects];
        if ([calls count]>0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isCall"];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    ZBLog(@"applicationDidBecomeActive");
    
    [self dialKbdHide:YES];
    
//    if (![UIDevice addressBookGetAuthorizationStatus]) {
//        [UIAlertView alertViewWithTitle:@"授权提示"
//                                message:@"IOS 6.0以上系统因权限限制,需要进入\"系统设置->隐私->通讯录\"开启通讯录权限许可后才能使用"];
//    }
    
    //这个block，在拨号界面中，用途是用来在拨号完成后，刷新通话记录界面。
    if (_block) {
        _block();
    }

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // save the config while entering background.
	ZBLog(@"applicationDidEnterBackground");

    if ([self isNewVersionClint]) {
        return;
    }
    [self ReLoadAddressBookRef];
    [SettingInfo setListenAppChangedAddressbook:YES];

    [[ConfigMgr getInstance] save];

    
    //2015.5.11 添加，主要为了记录应用是否是因为拨号而进入的后台,1表示程序是因为拨号而进入的后台
    //相应的，当程序进入前台时候，执行block，并且要把isCall的值改为0
    if ([SYSTEMVERSION floatValue]<8.0) {
        CTCallCenter *callCenter = [UIDevice checkDeviceCallState];
        NSArray *calls = [callCenter.currentCalls  allObjects];
        if ([calls count]>0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isCall"];
        }
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application{
    //将要从后台转到前台
    
	ZBLog(@"applicationWillEnterForeground");
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if ([SettingInfo getFirstPageNum] ==3) {
        [mainViewController SaveLastPageNum];
    }
	ZBLog(@"applicationWillTerminate");
}

- (void)createMessageCenterDatabase{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MessageCenter.db"];
    
    db = [[FMDatabase alloc]initWithPath:dbPath] ;
    
    if (![db open]) {
        
        NSLog(@"Could not open db.");
    }
    else{
        if (![db tableExists:@"NewMessage"]) {
            BOOL isSuccess = [db executeUpdate:@"CREATE TABLE NewMessage (jobServerId INTEGER,timestamp long long,isRead INTEGER,iconUrl text, title text, content text, imgTitleUrl text, imgContentUrl1 text, imgContentUrl2 text, imgContentUrl3 text, urlDetail text,StartDate)"];
            
            if (!isSuccess) {
                NSLog(@"NewMessage table create failed");
            }
        }
        
        if (![db tableExists:@"SystemMessage"]) {
            BOOL isSuccess =  [db executeUpdate:@"CREATE TABLE SystemMessage (content text)"];
            if (!isSuccess) {
                NSLog(@"SystemMessage table create failed");
            }
        }
        
        [db close];
        
    }
}

#pragma mark ----------------------------------------------
#pragma mark  ************* Init **************************
#pragma mark ----------------------------------------------
#pragma mark  init  VC


//- (void)initRightViewController{
//    rightViewController = [[RightCollectViewCtrl alloc] init];
//    
//    rightViewController.view.frame = CGRectMake(320-self.rightViewController.view.frame.size.width,
//                                                20,
//                                                self.rightViewController.view.frame.size.width,
//                                                self.rightViewController.view.frame.size.height);
//    
//    
//    
//    [self.window addSubview:rightViewController.view];
//    
//    [rightViewController setVisible:NO];
//}

#pragma mark handle EndLoadingContactNotification Notification
- (void)initSyncEngine{
    InitSyncEngine();
}

- (void)deviceSign{
    StartSync(TASK_DEVICE_SIGN);//设备签到
}

- (void)handleSomethingWhenEndLoadingContactData:(NSNotification *)notification{
    ZBLog(@"recevied notification:...EndLoadingContactNotification");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    
    NSString *documentPath = [paths objectAtIndex:0];
    [[ConfigMgr getInstance] load];
    
    //将归属地数据库资源文件部署到应用程序沙盒
    [AreaQuery installDataBaseFile];
    
//    //初始化数据
//    [self initSearchContactData];
    
   
    
    

    [UIDevice generateUUID];
    
    //
    if (1) {//[UIDevice canConnectToNetwork]
        //无论网络是否连接 都实例化同步引擎SyncEngine
        NSOperationQueue *initQueue = [[NSOperationQueue alloc]init];
        [initQueue setMaxConcurrentOperationCount:1];
        
        NSInvocationOperation *initSyncEngineOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(initSyncEngine) object:nil];
        [initQueue addOperation:initSyncEngineOperation];
        [initSyncEngineOperation release];
        
        if ([UIDevice canConnectToNetwork]) {
            NSInvocationOperation *deviceSignOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(deviceSign) object:nil];
            [initQueue addOperation:deviceSignOperation];
            [deviceSignOperation release];
            
            
            NSInvocationOperation *fetchLaunchImgOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(fetchLaunchImageFromServer) object:nil];
            [initQueue addOperation:fetchLaunchImgOperation];
            [fetchLaunchImgOperation release];
            
        }
       
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EndLoadingContactNotification"
                                                  object:nil];
    
#pragma mark 设置标记document下文件不进行就行
  
    
    [SettingInfo fileList:documentPath];
}


#pragma mark  //////// Operate View

- (void)drawContactOperateView{
    CGRect rectView = CGRectMake(0,57+gapHeight, SCREEN_WIDTH, Device_Height-20);//57
    
    operateWindow = [[UIView alloc] initWithFrame:rectView];
    [operateWindow setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
    [operateWindow addGestureRecognizer:tapGesture];
    
    [self.window addSubview:operateWindow];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame=CGRectMake(152.5/320 * SCREEN_WIDTH ,0, 155, 183);//152.5
    imageView.image=[UIImage imageNamed:@"_opview_bg"];
    imageView.tag=10000;    //注释掉，可能有冲突2015.4.22
    
    [operateWindow addSubview:imageView];
    
    [operateWindow bringSubviewToFront:imageView];
    
    [imageView release];
}
#pragma mark - 操作优化：通讯录页面 点击右上角“+”号。点击 弹出窗口以外的地方能把弹出窗收起
-(void)tapGestureAction{
    [self releaseContactOperateView];
}

- (void)releaseContactOperateView{
    if (operateWindow) {
        [operateWindow removeFromSuperview];
        [operateWindow release];
        operateWindow = nil;
    }
}


#pragma mark ----------------------------
#pragma mark ****** AddressBook ********
#pragma mark ----------------------------

#pragma mark 创建、释放地址簿句柄
/// /////////////////
//   修改联系人信息，需重新初始化AddressBookRef,否则不能读取最新联系人信息.
//////新增、删除联系人不需要重新初始化AddressBookRef ///
///////////////
- (ABAddressBookRef)getAddressBookRef {
    if (_addressBook == nil) {
        
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error)
        {
            dispatch_semaphore_signal(sema);
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"EndLoadingContactNotification" object:nil];
            });
        });
        //如果之前的block没有执行，则sema的资源数为零，程序将被阻塞
        //当用户选择同意，block的方法被执行， sema资源数为1；
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //
        //            if (granted) {
        //
        //            }else{
        //                ZBLog(@"用户拒绝了通讯录权限");
        //            }
        //        });
        //    });
//        ABAddressBookRegisterExternalChangeCallback(_addressBook, addressBookChanged, (__bridge void *)self);//监测通讯录数据库是否变化
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [HBZSAppDelegate checkAddressBookRABC];
        });
//        ABAuthorizationStatus status=ABAddressBookGetAuthorizationStatus();
//        if (status == kABAuthorizationStatusDenied) {
//            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"授权提示" message:@"因权限限制,需要进入\"系统设置->隐私->通讯录\"开启号簿助手的权限许可后才能使用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//            [alert show];
//            [alert release];
//        }

    }
    
    
    
    
    return _addressBook;
}

//重新读取联系人权柄
- (ABAddressBookRef)ReLoadAddressBookRef {
    if (self.isSyncOperatingOrRemovingRepead) {
        return _addressBook;//同步进行过程中不进行从新获取通讯录
    }
    _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 dispatch_semaphore_signal(sema);
                                                 
                                             });
    //如果之前的block没有执行，则sema的资源数为零，程序将被阻塞
    //当用户选择同意，block的方法被执行， sema资源数为1；
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_release(sema);
    
    
    ABAddressBookRegisterExternalChangeCallback(_addressBook, addressBookChanged, (__bridge void *)self);//监测通讯录数据库是否变化
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         [HBZSAppDelegate checkAddressBookRABC];
    });
   
//    ABAuthorizationStatus status=ABAddressBookGetAuthorizationStatus();
//    if (status == kABAuthorizationStatusDenied) {
//        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"授权提示" message:@"因权限限制,需要进入\"系统设置->隐私->通讯录\"开启号簿助手的权限许可后才能使用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
    
    return _addressBook;
}

+(BOOL)checkAddressBookRABC
{
    
    ABAuthorizationStatus status=ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusDenied) {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"授权提示" message:@"因权限限制,需要进入\"系统设置->隐私->通讯录\"开启号簿助手的权限许可后才能使用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}

- (void)addressBookRevert{
    if (_addressBook) {
        ABAddressBookRevert(_addressBook);
    }
}

- (void)releaseAddressBookRef {
    if(NULL != _addressBook&&!self.isSyncOperatingOrRemovingRepead) {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, addressBookChanged,self);
        CFRelease(_addressBook);
        
        _addressBook = nil;
    }
}


#pragma mark 监测通讯录数据库是否发生变化
/*
 *  监测通讯录数据库是否发生变化
 */
void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void* context) {
    NSLog(@"addressBookChanged......");

    [USERDEFAULTS setBool:YES forKey:@"ISNeedInitAddressBookRef"];
    [USERDEFAULTS synchronize];
    
    HBZSAppDelegate* delegate = (HBZSAppDelegate*)context;
    if (!delegate.isSyncOperatingOrRemovingRepead) {
        
        if ([SettingInfo getIsListenAppChangedAddressbook]) {//刷新数据
            
            [[MainViewCtrl shareManager] UpdataContactChanges];//变化数量
            HBZSAppDelegate* delegate = (HBZSAppDelegate*)context;
            
            ZBLog(@"addressBookChanged called, app.ab=......yyyyyy");
            
            [SettingInfo setListenAppChangedAddressbook:NO];
            
//            [delegate releaseAddressBookRef];
            [delegate addressBookRevert];
            [delegate getAddressBookRef];
            
            [USERDEFAULTS setBool:NO forKey:@"ISNeedInitAddressBookRef"];
            [USERDEFAULTS synchronize];
            
            [delegate initSearchContactData];
            [delegate resetDialItemInfos:delegate.searchContactArray];
            
        }
    }
    
}

#pragma mark 添加联系人到搜索库
- (void)addContactToSearchLibrary:(SearchItem *)searchItem localID:(NSInteger)_index{
    //添加到搜索库
    ContactPeople *contactPeople = [[ContactPeople alloc] init];
    contactPeople.localID = [NSNumber numberWithInt:_index];
    contactPeople.name = searchItem.contactFullName;
    contactPeople.lastName = searchItem.contactLastName;
    contactPeople.firstName = searchItem.contactFirstName;
    contactPeople.phoneArray = searchItem.contactPhoneArray;
    contactPeople.contactId = searchItem.contactID;
    contactPeople.contactGroupID = searchItem.contactGroupID;
    
    [contactDic setObject:contactPeople forKey:contactPeople.localID];
    //添加到搜索库
    [[SearchCoreManager share] AddContact:contactPeople.localID
                                     name:contactPeople.name
                                    phone:contactPeople.phoneArray];
 
    [contactPeople release];
}

#pragma mark -
- (void)getSearchCoreManager{
    contactDic = [[NSMutableDictionary alloc]init];
    
    int i = 0;
    
    for (SearchItem *searchItem in searchContactArray) {
        if (!searchItem.PubNumberLogoStr)
        {
            [self addContactToSearchLibrary:searchItem localID:i];
        
        ++i;
        }
    }
}

- (void)releaseSearchCoreManage{
    [[SearchCoreManager share]Reset];
    
    if (contactDic) {
        [contactDic release];
        contactDic = nil;
    }
}
#pragma mark init SearchContactData
- (void)initSearchContactData{
    ZBLog(@"initSearchContactData start...");
    
    if (searchContactArray != nil){
        [searchContactArray release];
        searchContactArray = nil;
    }
  
    searchContactArray = [[NSMutableArray alloc]init];
    [searchContactArray addObjectsFromArray:[ContactData getSearchAllContact]];
    
#pragma mark 向搜索添加公众号
    NSArray * PubNumberDataArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"PubNumber" ofType:@"plist"]];
    for (NSDictionary * dic in PubNumberDataArr) {
        SearchItem *searchItem = [SearchItem searchItemAlloc];
        
        searchItem.contactFullName = dic[@"name"];
        searchItem.PubNumberLogoStr = dic[@"logoname"];
        searchItem.contactPhoneArray = [[[NSMutableArray alloc]init]autorelease];
        [searchItem.contactPhoneArray addObject:dic[@"number"]];
        searchItem.contactType = -4;
        
        [searchContactArray addObject:searchItem];
    }

    [self releaseSearchCoreManage];
  
    contactDic = [[NSMutableDictionary alloc]init];
    
    int i = 0;
    
    for (SearchItem * searchItem in searchContactArray) {
        if (!searchItem.PubNumberLogoStr)
        {
        [self addContactToSearchLibrary:searchItem localID:i];
        
        ++i;
        }
    }
   
    ////根据姓排序
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"chineseFirstName" ascending:YES];
    
    NSArray *sortDescriptors3 = [NSArray arrayWithObject:sortDescriptor3];
    
    [searchContactArray sortUsingDescriptors:sortDescriptors3];
    
    [sortDescriptor3 release];
    
    ZBLog(@"initSearchContactData end...");
    
    //更新键盘搜索索引
    NSLog(@"更新键盘搜索索引");
}

#pragma mark setSearchContactGroupType
- (void)setSearchContactGroupType:(NSMutableArray*) array type:(NSInteger) type groupID:(NSInteger) groupID{
    for (SearchItem *searchItem in searchContactArray){
        searchItem.keyRange = NSMakeRange(0, 0);
        
        [searchItem.rangeArray removeAllObjects];
        
        if ([array containsObject:[NSString stringWithFormat:@"%ld",(long)searchItem.contactID]]){
            searchItem.contactType = type;             //联系人类型：全部(-1)/群组(群ID)/搜索(-2)
            searchItem.contactGroupID = groupID;
        }
        else{
            searchItem.contactType = -3;
            searchItem.contactGroupID = -1;
        }
    }
}

- (void)setSearchContactType:(NSInteger) type bGroupID:(BOOL) bGroupID{
    SearchItem *searchItem = nil;
    
    NSInteger contactCount = [searchContactArray count];
    
    for (NSInteger i = 0; i < contactCount; i ++){
        searchItem = (SearchItem*)[searchContactArray objectAtIndex:i];
        
        searchItem.keyRange = NSMakeRange(0, 0);
        
        [searchItem.rangeArray removeAllObjects];
        
        if (searchItem != nil){
            searchItem.contactType = type;
            
            if (bGroupID){
                searchItem.contactGroupID = -1;
            }
        }
    }
}

//searchContactArrayByStr调用
- (void)searchNameBySearchStr:(SearchItem *)searchItem searchText:(NSString *)searchStr type:(int)type{
    NSRange range;
    
    range.length = 0;
    
    range.location = 0;
    
    if (nil != searchItem.contactFirstName || nil != searchItem.contactLastName)
    {
        NSString *str = nil;
        
        str = [self formatName:searchItem.contactLastName andFirstname:searchItem.contactFirstName];
        
        range = [[str uppercaseString] rangeOfString:searchStr];
        
        if (range.length > 0){//如果姓名中包含搜索关键字
            searchItem.contactType = type;
#if 0
            NSString *loc = [NSString stringWithFormat:@"%d",range.location];
            
            NSString *len = [NSString stringWithFormat:@"%d",range.length];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            
            [dict setObject:loc forKey:len];
            
            [searchItem.rangeArray addObject:dict];
            
            [dict release];
#endif
            return;
        }
        //简拼搜索
        range =  [searchItem.contactSearchSimple rangeOfString:searchStr];
        
        if (range.length > 0){
            searchItem.contactType = type;
#if 0
            NSString *loc = [NSString stringWithFormat:@"%d",range.location];
            
            NSString *len = [NSString stringWithFormat:@"%d",range.length];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            
            [dict setObject:loc forKey:len];
            
            [searchItem.rangeArray addObject:dict];
            
            [dict release];
#endif
            return;
        }
        //全拼搜索
        range = [searchItem.contactSearch rangeOfString:searchStr];
        
        if (range.location == 0 && range.length > 0){
            searchItem.contactType = type;
#if 0
            NSString *loc = [NSString stringWithFormat:@"%d",range.location];
            
            NSString *len = [NSString stringWithFormat:@"%d",range.length];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            
            [dict setObject:loc forKey:len];
            
            //  [searchItem.rangeArray addObject:dict];
            
            [dict release];
#endif
            return;
        }
        
        if ([searchStr length] > 1)//跨汉字及简拼匹配
        {
            if ([searchStr canBeConvertedToEncoding:NSASCIIStringEncoding]) //简拼匹配
            {
                for (int j = 0; j < searchStr.length; j++)
                {
                    NSString *tmpStr = [searchStr substringWithRange:NSMakeRange(j, 1)];
                    
                    NSString *tmp = nil;//[[NSString alloc]initWithFormat:@"%@",tmpStr];
                    
                    //   tmp = [NSString stringWithFormat:@"%@",tmpStr];
                    
                    NSRange range2;
                    
                    range2.location = 0;
                    range2.length = 0;
                    
                    NSString *tmp2 = searchItem.contactSearchSimple;
                    
                    if (j != 0) {
                        tmp = [searchStr substringWithRange:NSMakeRange(j-1, 1)];
                        
                        range2 = [searchItem.contactSearchSimple rangeOfString:tmp];
                        
                        tmp2 = [str substringWithRange:NSMakeRange(range2.location+range2.length,
                                                                   searchItem.contactSearchSimple.length - range2.location-1)];
                    }
                    
                    NSRange range1;
                    
                    range1.length = 0;
                    
                    range1.location = 0;
                    
                    range1 = [tmp2 rangeOfString:tmpStr];
                    
                    if (range1.length > 0){
                        searchItem.contactType = type;
                    }
                    else{
                        searchItem.contactType = -3;
                        return;
                    }
                }
            }
            else
            {//汉字跳字搜索
                for (int j = 0; j < searchStr.length; j++)
                {
                    NSString *tmpStr = [searchStr substringWithRange:NSMakeRange(j, 1)];
                    
                    NSString *tmp = nil;
                    
                    NSRange range2;
                    
                    range2.location = 0;
                    
                    range2.length = 0;
                    
                    NSString *tmp2 = str;
                    
                    if (j != 0) {
                        tmp = [searchStr substringWithRange:NSMakeRange(j-1, 1)];
                        
                        range2 = [str rangeOfString:tmp];
                        
                        tmp2 = [str substringWithRange:NSMakeRange(range2.location+range2.length,str.length - range2.location-1)];
                    }
                    
                    
                    NSRange range1;
                    
                    range1.location = 0;
                    range1.length = 0;
                    
                    
                    range1 = [tmp2 rangeOfString:tmpStr];
                    
                    if (range1.length > 0){
                        searchItem.contactType = type;
                    }
                    else{
                        searchItem.contactType = -3;
                        return;
                        
                    }
                }
                
            }
        }
    }
}

//searchContactArrayByStr调用
- (void)searchPhoneBySearchStr:(SearchItem *)searchItem searchText:(NSString *)searchStr type:(int)type{
    NSRange range;
    
    range.location = 0;
    
    range.length = 0;
    
    NSString* phoneStr = nil;
    
    if ([searchItem.contactPhoneArray count] > 0) {
        phoneStr = [searchItem.contactPhoneArray objectAtIndex:0];
        
        if (phoneStr != nil && phoneStr.length > 0) {
            range = [phoneStr rangeOfString:searchStr];
            
            if (range.length > 0){
                searchItem.contactType = type;
                
                searchItem.keyRange = range; //(画搜索结果要用、变色)
            }
        }
    }
}

#if 1
#pragma mark //联系人  搜索   type:  -1(所有人) -3(搜索的数据)  联系人模块搜索用
- (void)searchContactArrayByStr:(NSString*)searchStr type:(NSInteger)type bGroup:(BOOL)bGroup{
    if (nil == searchStr){
        return;
    }
   // ZBLog(@"START SEARCH...");
    
    searchStr = [searchStr uppercaseString];
    
    for (SearchItem *searchItem in searchContactArray) {
        
        if (searchItem != nil)
        {
            searchItem.keyRange = NSMakeRange(0, 0);
            
            [searchItem.rangeArray removeAllObjects];
            
            searchItem.contactType = -3;
            
            if (bGroup){
                if (searchItem.contactGroupID != type){
                    continue;
                }
            }
            
            
            [self searchNameBySearchStr:searchItem searchText:searchStr type:type];
            
            [self searchPhoneBySearchStr:searchItem searchText:searchStr type:type];
        }
    }
}

#endif

#pragma mark 拼接姓名
- (NSString *)formatName:(NSString *)_lastname andFirstname:(NSString *)_firstname{
    NSString *temp = @"";
    
    if(_lastname != nil && _firstname != nil)
    {
        temp =  [NSString stringWithFormat:@"%@ %@",_lastname,_firstname];
    }else if(_lastname != nil)
    {
        temp = [NSString stringWithFormat:@"%@",_lastname];
    }else if(_firstname != nil)
    {
        temp =  [NSString stringWithFormat:@"%@",_firstname];
    }
    
    return temp;
}

#pragma mark ///////////////////  searchData(搜索)  通话记录 搜素用 /////////////////////////
- (NSArray *)searchData:(NSString*) searchStr type:(NSInteger) type bGroup:(BOOL) bGroup
{
    if (nil == searchStr){
        return nil;
    }
    
    NSMutableArray *searchArray = [[[NSMutableArray alloc]init]autorelease];
    
    NSMutableArray *searchT9SimpleArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *searchT9Array = [[NSMutableArray alloc] init];
    
    NSMutableArray *searchNumberArray = [[NSMutableArray alloc] init];
    
    SearchItem *searchItem = nil;
    
    NSRange range;
    
    range.length = 0;
    
    range.location = 0;
    
    NSInteger contactCount = [searchContactArray count];
    
    for (NSInteger i = 0; i < contactCount; i ++)
    {
        searchItem = (SearchItem*)[searchContactArray objectAtIndex:i];
        
        searchItem.keyRange = NSMakeRange(0, 0);
        
        [searchItem.rangeArray removeAllObjects];
        
        if (bGroup)
        {
            if (searchItem.contactGroupID != type){
                searchItem.contactType = -3;
                
                continue;
            }
        }
        
        if (nil != searchItem) //姓名 . 简拼 . 全拼
        {
            if (nil != searchItem.contactFirstName || nil != searchItem.contactLastName)
            {
                NSString* str = [self formatName:searchItem.contactLastName andFirstname:searchItem.contactFirstName];
                
                range = [str rangeOfString:searchStr];
                
                if (range.length > 0)
                {
                    searchItem.contactType = type;
                    
                    NSString *loc = [NSString stringWithFormat:@"%d",range.location];
                    
                    NSString *len = [NSString stringWithFormat:@"%d",range.length];
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    
                    [dict setObject:loc forKey:len];
                    
                    [searchItem.rangeArray addObject:dict];
                    
                    [dict release];
                    
                    [searchArray addObject:searchItem];
                }
                else
                {
                    if (nil != searchItem.contactT9SearchSimple)//简拼
                    {
                        range = [searchItem.contactT9SearchSimple rangeOfString:searchStr];
                        
                        if (range.length > 0){
                            searchItem.contactType = type;
                            
                            NSString *loc = [NSString stringWithFormat:@"%d",range.location];
                            
                            NSString *len = [NSString stringWithFormat:@"%d",range.length];
                            
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                            
                            [dict setObject:loc forKey:len];
                            
                            // [searchItem.rangeArray addObject:dict];
                            
                            [dict release];
                            
                            [searchT9SimpleArray addObject:searchItem];
                        }
                    }
                    else
                    {
                        if (nil != searchItem.contactT9Search)//全拼
                        {
                            range = [searchItem.contactT9Search rangeOfString:searchStr];
                            
                            if (range.length > 0)
                            {
                                searchItem.contactType = type;
                                
                                NSString *loc = [NSString stringWithFormat:@"%d",range.location];
                                
                                NSString *len = [NSString stringWithFormat:@"%d",range.length];
                                
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                                
                                [dict setObject:loc forKey:len];
                                
                                //  [searchItem.rangeArray addObject:dict];
                                
                                [dict release];
                                
                                [searchT9Array addObject:searchItem];
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        if ([searchItem.contactPhoneArray count] < 1) {
            continue;
        }
        
        //号码
        NSString* phoneStr = [searchItem.contactPhoneArray objectAtIndex:0];
        
        if (phoneStr != nil && phoneStr.length > 0)
        {
            range = [phoneStr rangeOfString:searchStr];
            
            if (range.length > 0)
            {
                searchItem.contactType = type;
                
                searchItem.keyRange = range; //(画搜索结果要用、变色)
                
                [searchNumberArray addObject:searchItem];
            }
            
            searchItem.contactType = -3;
        }
    }
    
    if ([searchT9SimpleArray count]>0)
    {
        //根据长度排序
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contactSearchSimple.length"
                                                                       ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        [searchT9SimpleArray sortUsingDescriptors:sortDescriptors];
        
        [sortDescriptor release];
        
        [searchArray addObjectsFromArray:searchT9SimpleArray];
    }
    
    if ([searchT9Array count] > 0){
        [searchArray addObjectsFromArray:searchT9Array];
    }
    
    if ([searchNumberArray count] > 0){
        [searchArray addObjectsFromArray:searchNumberArray];
    }
    
    [searchT9SimpleArray release];
    
    [searchT9Array release];
    
    [searchNumberArray release];
    
    return searchArray;
}

//delContactDataArray的元素为NSString类型的contactID
- (void)delSearchContactData:(NSArray*) delContactDataArray{
    if (delContactDataArray == nil) {
        return;
    }
    
    NSInteger count = [delContactDataArray count];
    
    for (NSInteger i = 0; i < count; i++){
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        NSString* strID = [delContactDataArray objectAtIndex:i];
        
        NSInteger contactCount = [searchContactArray count];
        
        for (NSInteger j = 0; j < contactCount; j++){
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
            
            SearchItem* searchItem = [searchContactArray objectAtIndex:j];
            
            if (searchItem.contactID == [strID intValue]){
                [searchContactArray removeObjectAtIndex:j];
                
                NSArray *allkeys = [contactDic allKeys];
                
                for (NSNumber *temp in allkeys){
                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
                    
                    ContactPeople *contactPeople = [contactDic objectForKey:temp];
                    
                    if (contactPeople.contactId == [strID intValue]){
                        [[SearchCoreManager share] DeleteContact:temp];
                        
                        [pool release];
                        
                        break;
                    }
                    
                    [pool release];
                }
                
                break;
            }
        
        [pool release];
    }
        
    [pool release];
   }
}

- (void)addSearchContactData:(SearchItem*) addContactData{
    if (addContactData != nil) {
        [searchContactArray addObject:addContactData];
        
        [self addContactToSearchLibrary:addContactData localID:[[contactDic allKeys] count]]; //增加到搜索库
    }
}

- (void)editSearchContactData:(SearchItem*) editContactData{
    if (editContactData == nil) {
        return;
    }
    
    NSInteger count = [searchContactArray count];
    
    for (NSInteger i = 0; i < count; i++){
        SearchItem* searchItem = [searchContactArray objectAtIndex:i];
        
        if (searchItem.contactID == editContactData.contactID){
            searchItem.contactFirstName = editContactData.contactFirstName;
            
            searchItem.contactLastName = editContactData.contactLastName;
            
            if (searchItem.contactPhoneArray.count > 0) {
                [searchItem.contactPhoneArray removeAllObjects];
            }
            
            [searchItem.contactPhoneArray addObjectsFromArray:editContactData.contactPhoneArray];
            
            NSArray *allkeys = [contactDic allKeys];
            
            searchItem.contactFullName = [self formatName:searchItem.contactLastName andFirstname:searchItem.contactFirstName];
            
            for (NSNumber *temp in allkeys){
                ContactPeople *contactPeople = [contactDic objectForKey:temp];
                
                if (contactPeople.contactId == searchItem.contactID) {
                    [[SearchCoreManager share] DeleteContact:temp];

                    [self addContactToSearchLibrary:searchItem localID:[[contactDic allKeys] count]];
                    
                    return;
                }
            }
        }
    }
}

#pragma mark GroupSelectedDelegate
- (void)didSelectGroupIndex:(NSInteger)idx groupName:(NSString *)gname{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [delegate releaseSearchCoreManage];
    
    contactDic = [[NSMutableDictionary alloc]init];
    
    int i = 0;
    
    if (idx < 0){//全部联系人
        for (SearchItem *searchItem in searchContactArray) {
            [self addContactToSearchLibrary:searchItem localID:i];
            
            ++i;
        }
        
        [self setSearchContactType:-3 bGroupID:YES];
        
        [mainViewController groupSelectedIndex:idx groupName:gname];
    }
    else{
        //组联系人
        NSMutableArray *array = [GroupData getGroupAllContactIDByID:idx];
        
        [self setSearchContactType:-3 bGroupID:YES];
        
        [self setSearchContactGroupType:array type:-3 groupID:idx];
        
        for (SearchItem *searchItem in searchContactArray)
        {
            if (searchItem.contactGroupID == idx){
                //添加到搜索库
                [self addContactToSearchLibrary:searchItem localID:i];
                
                ++i;
            }
            
        }
        
        [mainViewController groupSelectedIndex:idx groupName:gname];
    }
}

#pragma mark didDeleteGroupId
- (void)didDeleteGroupId:(NSInteger)gid{
    [mainViewController groupDeleteGroupId:gid];
}
#pragma mark 群组按钮(上导航左按钮)  废掉2015.7.15
- (void)didChangeToEditMode:(BOOL)bEdit{
    if (bEdit){
        [mainViewController moveToGroupEdit];
    }
    else{
        [mainViewController moveToRightSide];
    }
}
#pragma mark -
#pragma mark setAccountView
- (void)setAccountViewInstance:(id)viewInstance{
    self.setViewInstance = viewInstance;
}

- (void)setSyncViewController:(id)viewController{
    self.syncViewCtrl = viewController;
}

- (void)setMessageCenterViewController:(id)viewController{
    self.messageCenterVC = viewController;
}

#pragma mark 同步状态刷新(syncStatusRefresh)
- (void)syncStatusRefresh{
	SyncStatusEvent* curEvent;
    
	curEvent = GetSyncStatus();
    
    if (curEvent->taskType == TASK_AUTHEN){//账户验证
        if(self.setViewInstance){
            [self.setViewInstance loginStatus:curEvent->status];
        }
    }
    else{
        
        if (self.syncViewCtrl) {
            [self.syncViewCtrl noticeBySyncEvent:(id)curEvent];
        }
    }
}

#pragma mark 更新通话记录信息，保证通话记录与通讯录同步
- (void)updateDialItemInfo:(NSMutableArray *)deleteContactIds{
    NSMutableArray *dialItems = [SettingInfo getDialItems];
    NSInteger index = 0;
    
    if (dialItems == nil) {
        return;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:dialItems];
    
    for(DialItem *dialItem in dialItems){
        NSString *contactIdString = [[NSString alloc]initWithFormat:@"%d", dialItem.contactID];
        
        if ([deleteContactIds containsObject:contactIdString]) {
            dialItem.name = dialItem.phone;
            dialItem.contactID = -1;
            [items replaceObjectAtIndex:index withObject:dialItem];
        }
        
        [contactIdString release];
        
        ++ index;
    }
    
    [SettingInfo setDialItems:items];
    [items release];
}

- (void)updateDialItemInfo:(SearchItem *)searchItem dialItems:(NSMutableArray *)dialItems{
    if (dialItems == nil) {
        return;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:dialItems];
    NSInteger index = 0;
    
    for (DialItem *dialItem in dialItems) {
        if ([searchItem.contactPhoneArray containsObject:dialItem.phone]) {
            if (dialItem.contactID == -1) {//
                dialItem.name = searchItem.contactFullName;
                dialItem.contactID = searchItem.contactID;
                [items replaceObjectAtIndex:index withObject:dialItem];
                break;
            }
            
            if (dialItem.contactID == searchItem.contactID) {
                dialItem.name = searchItem.contactFullName;
                [items replaceObjectAtIndex:index withObject:dialItem];
                break;
            }
        }
        else{
            if(dialItem.contactID == searchItem.contactID) {
                dialItem.name = dialItem.phone;
                dialItem.contactID = -1;
                [items replaceObjectAtIndex:index withObject:dialItem];
                break;
            }
        }
        
        ++ index;
    }
    
    [SettingInfo setDialItems:items];
    [items release];
}

- (void)resetDialItemInfos:(NSArray *)contacts{
    NSArray *dialItems = [SettingInfo getDialItems];
    NSMutableArray *items = [[NSMutableArray alloc]initWithArray:dialItems];
    NSInteger index = 0;
    
    for(DialItem *dialItem in dialItems){
        if (contacts.count == 0) {
            dialItem.contactID = -1;
            dialItem.name = dialItem.phone;
            [items replaceObjectAtIndex:index withObject:dialItem];
            continue;
        }
        
        for (int i = 0; i < contacts.count; i++) {
            SearchItem *searchItem = [contacts objectAtIndex:i];
            
            if ([searchItem.contactPhoneArray containsObject:dialItem.phone]) {
                if (dialItem.contactID == -1) { //拨号记录之前没保存为联系人
                    dialItem.contactID = searchItem.contactID;
                    dialItem.name = searchItem.contactFullName;
                }
                else{
                    dialItem.name = searchItem.contactFullName;
                }
                
                [items replaceObjectAtIndex:index withObject:dialItem];
                break;
            }
            else if (i == (contacts.count - 1)) {
                dialItem.name = dialItem.phone;
                dialItem.contactID = -1;
                [items replaceObjectAtIndex:index withObject:dialItem];
                break;
            }
        }
        
        ++ index;
    }
    
    [SettingInfo setDialItems:items];
    [items release];
}

- (void)initContactDic{
    contactDic = [[NSMutableDictionary alloc]init];
}

#pragma mark 搜索库更新
- (void)resetSearchLibraryWhenTableIsEditModel{
    [self releaseSearchCoreManage];
}

- (void)initSearchLibraryWhenTableIsEditModel:(NSArray *)contactIds{
    contactDic = [[NSMutableDictionary alloc]init];
    
    int index = 0;
    //NSLog(@"contactIds: %@", contactIds);
    for (SearchItem *searchItem in searchContactArray) {
      //  NSLog(@"searchItem.contactId: %d", searchItem.contactID);
        if ([contactIds containsObject:[NSNumber numberWithInt:searchItem.contactID]]) {
        //    NSLog(@"add..");
            [self addContactToSearchLibrary:searchItem localID:index];
        }
    
        ++ index;
    }
}

- (void)removeContactPeopleFromSearchLibrary:(NSArray *)contactIds{
    [[SearchCoreManager share] Reset];
    NSArray *allValues = [contactDic allValues];
    NSMutableArray *localIds = [[NSMutableArray alloc]init];
    for (NSString *contactId in contactIds) {
        for (ContactPeople *people in allValues) {
            if (people.contactId == [contactId intValue]) {
                [localIds addObject:people.localID];
                break;
            }
        }
    }
    
    for (NSString *localId in localIds) {
         [contactDic removeObjectForKey:[NSNumber numberWithInt:[localId intValue]]];
    }
    
    allValues = [contactDic allValues];
    NSInteger index = 0;
    [contactDic removeAllObjects];
    
    for (ContactPeople *people in allValues) {
        [contactDic setObject:people forKey:[NSNumber numberWithInt:index]];
        [[SearchCoreManager share] AddContact:[NSNumber numberWithInt:index]
                                         name:people.name phone:people.phoneArray];
        ++ index;
    }
}

- (void)addContactPeopleToSearchLibrary:(NSArray *)contactIds{
    NSInteger valueCount = [contactDic allKeys].count;
    for (NSString *contactId in contactIds) {
        for (SearchItem *item in searchContactArray) {
            if (item.contactID == [contactId intValue]) {
                [self addContactToSearchLibrary:item localID:[NSNumber numberWithInt:valueCount]];
                break;
            }
        }
        
        ++ valueCount;
    }
}


#pragma mark Fetch Launch Image
- (void)fetchLaunchImageFromServer{
    [FetchDynamicLaunchImgRequest fetchLaunchImg];
    [FetchDynamicLaunchImgRequest contactBgImage];
}

#pragma mark ----------------------
#pragma mark ***** Vendor SDK *****
#pragma mark ----------------------
#pragma mark YXApiDelegate
//- (void)onReceiveRequest:(YXBaseReq *)req{
//}
//
//- (void)onReceiveResponse: (YXBaseResp *)resp{
//    ZBLog(@"onReceiveResponse: %d", resp.type);
//}

#pragma mark Baidu SDK
- (void)registerBaiduMobStat{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.channelId = @"appstore";
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;//设置日志发送策略
    statTracker.logSendWifiOnly = YES;
    statTracker.sessionResumeInterval = 60;
    statTracker.enableDebugOn = NO;
    statTracker.logSendInterval = 1;
    [statTracker startWithAppId:BaiduStatistics_AppKey];
}

#pragma mark ---------------------------------------------------
#pragma mark /////////  全局设置tabBar的显示和隐藏   //////////////
#pragma mark --------------------------------------------------
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated{
    
    if (self.tabBar) {
        [self.tabBar setHidden:hidden animated:animated];
    }
}

- (void)didSelectIndex:(NSInteger)idx
{
    [self.mainViewController popOldAndpushNewByindex:idx];
}

#pragma mark --------------------------------
#pragma mark   ********* 键盘隐藏 *************
#pragma mark --------------------------------
- (void)dialKbdHide:(BOOL)hide{
    
    [self.mainViewController dialKeyBoardHide:hide];
}


#pragma mark -推送相关代理
//获取
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = deviceToken.description;
    NSLog(@"==%@",token);
    token = [[[token stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSUserDefaults * manager = [NSUserDefaults standardUserDefaults];
    NSString * TokenForLoacl = [manager objectForKey:PushDeviceToken];
    
    if (!TokenForLoacl) {
        [manager setObject:token forKey:PushDeviceToken];
        [manager setBool:NO forKey:isUploadTokenToServer];
        //用于标记 是否传给服务器过 如果没有 在设备签到后调用 PushManager中的方法上传Token。
        [manager synchronize];
        
    }
    
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //注册推送失败
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
    
    
    NSUserDefaults * manager = [NSUserDefaults standardUserDefaults];
    if ([manager objectForKey:PushDeviceToken])
    {
        [manager removeObjectForKey:PushDeviceToken];
    }
}

//处理收到的消息推送
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //这个方法是iOS7新出的方法，block用于应用之间的通信推送，与下面方法同时存在的情况下，会自动调用该方法
    NSLog(@"iOS7新出的接收推送消息的方法，与旧方法同时存在的时候，旧方法自动无效--%@",userInfo);
    
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"active");
        //程序当前正处于前台
        //CTPass认证推送消息结果处理
        if ([[userInfo allKeys] containsObject:@"resultCode"])
        {
            
            if (self.setViewInstance) {
                int code = [userInfo[@"resultCode"] intValue];
                //Ctpass暂时不开放
                [self.setViewInstance CTPassResult:code andResultInfo:userInfo];
            }
        }
        
    }
    else if(application.applicationState == UIApplicationStateInactive)
    {
        //程序处于后台或者未启动  这里设置了一个延迟2秒跳转 否者在app未启动时，由消息进入无法跳转（可能是由于mainViewController 为实例化造成的）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PushManager * manager = [PushManager shareManager];
            [manager getMessgerforServer];
            [manager pushToViewControllver:[userInfo[@"jobId"] intValue] andMainVc:mainViewController];
        });
        
    }
    
    
}



- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //旧方法
    //在此处理接收到的消息。
    NSLog(@"Receive remote notification : %@",userInfo);
}

#pragma mark iOS10 推送中心
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    //在前台
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if ([[userInfo allKeys] containsObject:@"resultCode"])
    {
        
        if (self.setViewInstance) {
            int code = [userInfo[@"resultCode"] intValue];
            //Ctpass暂时不开放
            [self.setViewInstance CTPassResult:code andResultInfo:userInfo];
        }
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler
{
    //后台点击进入
    NSDictionary * userInfo = response.notification.request.content.userInfo;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PushManager * manager = [PushManager shareManager];
        [manager getMessgerforServer];
        [manager pushToViewControllver:[userInfo[@"jobId"] intValue] andMainVc:mainViewController];
    });
}
//pragma mark iOS10 推送相关↑

#pragma mark - 2015.5.11
-(void)blockCopy:(void (^)(void))block{
    _block=[block copy];
}

#pragma mark 验证登录信息
-(void)provingAccoutInfo
{
    if ([SettingInfo getAccountState]) {
        NSString * name = [[ConfigMgr getInstance] getValueForKey:@"user_name" forDomain:nil];
        
        NSString *psd =  [[ConfigMgr getInstance] getValueForKey:@"user_psw" forDomain:nil];
        
        if (name.length == 0||psd.length == 0) {
            [SettingInfo setAccountState:NO];
        }
    }
}

@end
