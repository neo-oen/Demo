//
//  HB_MergerViewController.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/17.
//
//

#import "HB_MergerViewController.h"
#import "HB_MergerCell.h"
#import "HB_HelpRemoveRepeadVC.h"
#import "HB_MergerEditContactVC.h"//合并编辑
#import "HB_RemoveRepeadTool.h"
#import "HBZSAppDelegate.h"
#import "SVProgressHUD.h"

@interface HB_MergerViewController ()<UITableViewDataSource,
                                        UITableViewDelegate,
                                        HB_MergerCellDelegate>

/** 表格视图 */
@property (nonatomic,retain) UITableView     *tableView;
/** ‘帮助’按钮 */
@property (nonatomic,retain) UIButton        *helpBtn;
/** ‘帮助’UIBarButtonItem按钮 */
@property (nonatomic,retain) UIBarButtonItem *helpBtnItem;

@end

@implementation HB_MergerViewController
#pragma mark - life cycle
-(void)dealloc{
    [_similarGroupArr release];
    [_helpBtnItem release];
    [_tableView release];
    [[HBZSAppDelegate getAppdelegate] setIsSyncOperatingOrRemovingRepead:NO];

    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"相似联系人合并";
    self.navigationItem.rightBarButtonItem = self.helpBtnItem;
    [self.view addSubview:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[HBZSAppDelegate getAppdelegate] setIsSyncOperatingOrRemovingRepead:YES];
    //每次展示这个页面之前，都要确认一下数据源里面是否有空的数组，因为有的可能是被手工合并掉了。
    for (NSInteger i = (self.similarGroupArr.count-1); i>=0; i--) {
        NSArray *tempArr = self.similarGroupArr[i];
        if (tempArr.count == 0) {
            [self.similarGroupArr removeObject:tempArr];
        }
    }
    [_tableView reloadData];
    
    [self hiddenTabBar];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.similarGroupArr.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UITabelViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = [self.similarGroupArr[indexPath.row] count];
    return count * 60;
}
#pragma mark - UITabelViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.similarGroupArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_MergerCell * cell=[HB_MergerCell cellWithTableView:tableView];
    cell.contactArr = self.similarGroupArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark - HB_MergerCellDelegate
-(void)mergerCelldidMergerBtnClick:(HB_MergerCell *)mergerCell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:mergerCell];
    HB_MergerEditContactVC * mergerVC=[[HB_MergerEditContactVC alloc]init];
    mergerVC.contactArr = self.similarGroupArr[indexPath.row];
    [self.navigationController pushViewController:mergerVC animated:YES];
    [mergerVC release];
}
#pragma mark - event response
-(void)helpBtnClick{
    HB_HelpRemoveRepeadVC * help=[[HB_HelpRemoveRepeadVC alloc]init];
    [self.navigationController pushViewController:help animated:YES];
    [help release];
}

#pragma mark - setter and getter
-(UIBarButtonItem *)helpBtnItem{
    if (!_helpBtnItem) {
        _helpBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.helpBtn];
    }
    return _helpBtnItem;
}
-(UIButton *)helpBtn{
    if (!_helpBtn) {
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpBtn setFrame:CGRectMake(0, 0, 44, 20)];
        [_helpBtn setTitle:@"帮助" forState:UIControlStateNormal];
        _helpBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [_helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}
-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat tableView_W=SCREEN_WIDTH;
        CGFloat tableView_H=SCREEN_HEIGHT-64;
        CGFloat tableView_X=0;
        CGFloat tableView_Y=0;
        CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
