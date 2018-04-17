//
//  AppDelegate.h
//  HBZS_IOS
//
//  Created by Kevin、yingxin on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "MyTabBar.h"
#import "ContactData.h"

#import "SearchCoreManager.h"

#import "YXApi.h"

#import "PushManager.h"
#import <UserNotifications/UserNotifications.h>

//#import "ContactGroupSelectView.h"//2015.4.20

/// /////////////////
//   修改联系人信息，需重新初始化AddressBookRef,否则不能读取最新联系人信息.
 //////新增、删除联系人不需要重新初始化AddressBookRef
///
@class LeftGroupViewCtrl;

@class RightCollectViewCtrl;

@class MainViewCtrl;

@class BaseViewCtrl;

@class MyTabBar;

@class AccountVc;

@class SyncViewCtrl;

@class MessageCenterVC;

#import "FMDatabase.h"

#import "LaunchViewController.h"
@interface HBZSAppDelegate : UIResponder <UIApplicationDelegate,
                                          MyTabBarItemDelegate,
                                          YXApiDelegate,UNUserNotificationCenterDelegate>{
    LaunchViewController *launchVC;
                                              
    MainViewCtrl *mainViewController;
    
    AccountVc* setViewInstance;
    
    
    
    //联系人搜索信息
    NSMutableArray  *searchContactArray;
                                              
    
    int gapHeight;
                                              
    FMDatabase *db;
                                            
}


@property(nonatomic,assign)ABAddressBookRef addressBook;

@property (retain, nonatomic)NSData *launchImgData;

@property (retain, nonatomic) UIWindow *window;

@property (nonatomic, retain) UIView *operateWindow;  //联系人模块中的 操作
@property (nonatomic, retain) UIView *operateWindow2; //联系人详情 中的操作

@property (nonatomic,retain) NSMutableDictionary *contactDic; //搜索用 Added by Kevin on March,1 2013

@property (retain, nonatomic) UINavigationController *navController;

@property (retain, nonatomic) LeftGroupViewCtrl *leftViewController;
@property (retain, nonatomic) RightCollectViewCtrl *rightViewController;

@property (nonatomic, retain) MainViewCtrl *mainViewController;

@property (retain, nonatomic) MyTabBar *tabBar;

@property (retain, nonatomic) id setViewInstance;
@property (retain, nonatomic) UIViewController *syncViewCtrl; //修改过 原来为SyncViewCtrl



@property (nonatomic, retain) NSMutableArray *searchContactArray;

@property (nonatomic,assign)int gapHeight;

@property (nonatomic, assign)BOOL isSyncOperatingOrRemovingRepead;//用于判断是否正在进行同步操作或者去重操作

@property (nonatomic, retain)NSTimer *fetchNewMessageTimer;

@property (nonatomic, retain)MessageCenterVC *messageCenterVC;

//@property(nonatomic)BOOL isLaunchedByNotification;//该变量用于判定用户是否从

/**
 *  通话记录页面的block
 */
@property(nonatomic,copy)void(^block)(void);
/**
 *  block复制方法
 *
 *  @param block 
 */
-(void)blockCopy:(void(^)(void))block;

+(HBZSAppDelegate *)getAppdelegate;

- (void)drawContactOperateView;                  //联系人模块 操作

- (void)releaseContactOperateView;

- (void)getSearchCoreManager;                 //初始化搜索库
- (void)releaseSearchCoreManage;             //释放搜索库

- (void)addContactToSearchLibrary:(SearchItem *)searchItem localID:(NSInteger)_index;

- (ABAddressBookRef)getAddressBookRef;        //初始化 AddressBookRef

- (ABAddressBookRef)ReLoadAddressBookRef;     //重新注册AddressBookRef 删除、创建、编辑联系人的时候用，不然监听不到通讯录变化

- (void)releaseAddressBookRef;               //释放 AddressBookRef

- (void)initSearchContactData;              //初始化联系人数据

- (void)setSearchContactGroupType:(NSMutableArray*) array type:(NSInteger) type groupID:(NSInteger) groupID;

- (void)setSearchContactType:(NSInteger) type bGroupID:(BOOL) bGroupID;

- (NSString *)formatName:(NSString *)_lastname andFirstname:(NSString *)_firstname;

- (void)searchContactArrayByStr:(NSString*)searchStr type:(NSInteger)type bGroup:(BOOL)bGroup;

- (NSArray*)searchData:(NSString*) searchStr type:(NSInteger) type bGroup:(BOOL) bGroup;

- (void)delSearchContactData:(NSArray*) delContactDataArray;

- (void)addSearchContactData:(SearchItem*) addContactData;

- (void)editSearchContactData:(SearchItem*) editContactData;

- (void)makeLeftViewVisible;
//- (void)makeRightViewVisible;
- (void)makeShadowDisable;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setAccountViewInstance:(id)viewInstance;
- (void)setSyncViewController:(id)viewController;
- (void)setMessageCenterViewController:(id)viewController;


//处理SyncEngine返回的状态信息
- (void)syncStatusRefresh;

- (void)addressBookRevert;

void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void* context);

- (void)updateDialItemInfo:(SearchItem *)searchItem dialItems:(NSMutableArray *)dialItems;

- (void)updateDialItemInfo:(NSMutableArray *)deleteContactIds;

- (void)resetDialItemInfos:(NSArray *)contacts;

- (void)resetSearchLibraryWhenTableIsEditModel;
- (void)initSearchLibraryWhenTableIsEditModel:(NSArray *)contactIds;

- (void)removeContactPeopleFromSearchLibrary:(NSArray *)contactIds;
- (void)addContactPeopleToSearchLibrary:(NSArray *)contactIds;

- (void)initContactDic;

//- (void)setIsSyncOperatingOrRemovingRepead:(BOOL)isSyncOperatingOrRemovingRepead;

- (void)fetchLaunchImageFromServer;

//版本更新处理
-(void)VersionDeal;

//通讯录权限检查
+(BOOL)checkAddressBookRABC;

@end
