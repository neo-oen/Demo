//
//  MainViewCtrl.h
//  HBZS_IOS
//
//  Created by yingxin on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DialKeyBoardView.h"
#import "DialViewCtrl.h"

#import "HB_ContactListVC.h"
#import "HB_LifeViewController.h"
#import "HB_MoreViewController.h"

@interface MainViewCtrl : UIViewController
{
    CGPoint touchBeganPoint;
    
    BOOL mainViewIsOutOfStage;
    
    DialViewCtrl *nextViewController1;

//2015.7.14 yangXiong
//此处改动，改为新版的联系人界面      // 旧版 ContactViewCtrl *nextViewController2;
    HB_ContactListVC *nextViewController2;
//2015.8.11 yangXiong
    HB_MoreViewController *moreVC;
    HB_LifeViewController *lifeChannelVC;
    
    
    NSInteger curIndex;
    
    BOOL groupEditing;                 //分组管理 按钮点击标志
}

@property(nonatomic,retain)DialViewCtrl *nextViewController1;

@property(nonatomic,retain) HB_ContactListVC *nextViewController2;

@property (nonatomic, assign)BOOL disableTouch;


/**  标记联系人变化数量 主要用于自动同步标记*/
@property (nonatomic,assign) NSInteger ContactChangers;

@property(nonatomic,retain)UIViewController * currentVc;


+(MainViewCtrl *)shareManager;

- (void)popOldAndpushNewByindex:(int)idx;

- (void)SaveLastPageNum;

- (void)dialKeyBoardHide:(BOOL)bhide;

- (void)restoreViewLocation;

- (void)moveToLeftSide;

- (void)moveToRightSide;

- (void)moveToGroupEdit;

- (void)animateMainViewToSide:(CGRect)newViewRect;

- (void)groupSelectedIndex:(NSInteger)idx groupName:(NSString*)gname;

- (void)groupDeleteGroupId:(NSInteger)gid;

//- (void)noticeBySyncEvent:(id)event;

- (void)reBuildData;  

- (void)reBuildViewAndData;

- (void)reChildBuildViewByDetialAdd;

- (void)initGroupContactTableData; //Added by July,6

//静默同步联系人时调用
-(void)starAutoSync:(NSInteger)AutosyncType;

- (void)noticeBySyncEvent:(id)event;

//刷新联系人变化数量
-(void)UpdataContactChanges;

//登录检测
-(BOOL)isAccount:(id)currentVc;


@end
