//
//  HB_TimeMachineContactPreviewVc.h
//  HBZS_IOS
//
//  Created by chengfei on 16/1/27.
//
//

#import "BaseViewCtrl.h"
#import "HB_MachineDataModel.h"
#import "HB_ContactCell.h"//联系人cell
//#import "HB_ContactSimpleModel.h"//简易的联系人模型
//#import "HB_ContactDataTool.h"//联系人管理类
#import "HB_ContactInfoVC.h"//联系人详情
#import "pinyin.h"
#import "SyncProgressView.h"
@interface HB_TimeMachineContactPreviewVc : BaseViewCtrl

@property(nonatomic,retain)HB_MachineDataModel * Mmodel;

/** tableView */
@property(nonatomic,retain)UITableView *tableView;
/** 数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;

@property(nonatomic,strong)SyncProgressView * TimeMachineProgressView;

@end
