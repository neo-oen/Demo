//
//  HB_ContactInfoVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import "BaseViewCtrl.h"
#import "HB_HeaderIconView.h"//头像视图
#import "HB_ContactInfoStore.h"
#import "HB_ContactInfoMoreView.h"//导航栏右侧“更多”按钮，浮层视图

@interface HB_ContactInfoVC : BaseViewCtrl
/**
 *  联系人id
 */
@property(nonatomic,assign)int recordID;

/** 列表 */
@property (nonatomic,retain) UITableView       * tableView;
/** “更多”按钮展示的浮层视图 */
@property(nonatomic,retain)HB_ContactInfoMoreView *moreView;
/** 联系人模型 */
@property(nonatomic,retain)HB_ContactModel *contactModel;
/** 数据源 */
@property(nonatomic,retain)HB_ContactInfoStore *store;
/** 头像 */
@property (nonatomic,retain)HB_HeaderIconView *headerIconView;

@end
