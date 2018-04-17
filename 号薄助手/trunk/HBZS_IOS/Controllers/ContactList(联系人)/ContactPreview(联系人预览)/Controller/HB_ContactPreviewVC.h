//
//  HB_ContactPreviewVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/15.
//
//这个控制器，主要用来从拨号界面添加新号码到现有联系人。这里展示的是联系人列表

#import "BaseViewCtrl.h"
#import "HB_ContactCell.h"//联系人cell
#import "HB_ContactSimpleModel.h"//简易的联系人模型
#import "HB_ContactDataTool.h"//联系人管理类
#import "HB_ContactDetailController.h"//编辑联系人
#import "pinyin.h"
@interface HB_ContactPreviewVC : BaseViewCtrl<UITableViewDataSource,UITableViewDelegate>
/**
 *  准备添加的电话号码
 */
@property(nonatomic,copy)NSString * phoneNumStr;

/** tableView */
@property(nonatomic,assign)UITableView * tableView;
/** 数据源 */
@property(nonatomic,retain)NSMutableArray * dataArr;

@property(nonatomic,strong)id tempdelegate;

- (NSString *)chineseToPinYin:(NSString*)chineseString;

//两个子类条用
-(UIView *)toobarLineView;
@end
