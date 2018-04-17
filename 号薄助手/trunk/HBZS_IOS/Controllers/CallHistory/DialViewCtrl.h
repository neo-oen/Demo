//
//  DialViewCtrl.h
//  HBZS_IOS
//
//  Created by yingxin on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewCtrl.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "MyString.h"
#import "SettingInfo.h"
#import "DialKeyBoardView.h"
#import "DialListCell.h"
#import "ContactItems.h"
#import "HBZSAppDelegate.h"
#import "GobalSettings.h"
//#import "ContactDetailViewCtrl.h"
#import "DialDetailViewCtrl.h"

@class DialListCell;

@interface DialViewCtrl : BaseViewCtrl<UITableViewDelegate,UITableViewDataSource,DialKeyBoardDelegate,ABNewPersonViewControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,ABPeoplePickerNavigationControllerDelegate,UIWebViewDelegate,DialDetailViewDelegate>
{
    
    BOOL bSound;
    
    BOOL bShake;
    
    BOOL bShowArea;
    
    BOOL isEditModel;
}

@property (nonatomic, retain) UITableView *dialTableView;

@property (nonatomic, retain) NSMutableArray *tableDataArray;

@property (nonatomic, retain) NSMutableArray *dialItemsArray;

@property (nonatomic, retain) DialKeyBoardView *dialKeyBoardView;

- (void)initData;

- (void)allocTableview;

- (void)searchByPhoneNumber;

- (NSString*)getSystemTime:(NSDate*)date;

- (void)addNewPerson:(NSString*)strPhone;

- (void)dialActionMenu:(NSMutableArray*)phoneNumbers dataIndex:(NSInteger)conId;

- (BOOL)twoDateIsSameDay:(NSDate *)fist second:(NSDate *)second;

- (void)presentABNewPersonViewController:(NSString *)strPhone;

@end
