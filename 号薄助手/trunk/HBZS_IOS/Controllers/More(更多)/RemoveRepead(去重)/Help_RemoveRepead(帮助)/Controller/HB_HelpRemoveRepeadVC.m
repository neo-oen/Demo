//
//  HB_HelpRemoveRepeadVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/17.
//
//

#import "HB_HelpRemoveRepeadVC.h"
#import "HB_HelpRemoveCell.h"
#import "HB_HelpCellButton.h"
#import "HB_HelpSectionHeaderView.h"

@interface HB_HelpRemoveRepeadVC ()<UITableViewDataSource,UITableViewDelegate,HB_HelpSectionHeaderViewDelegate>
/**
 *  数据源
 */
@property(nonatomic,retain)NSMutableArray *dataArr;

/**
 *  tableView
 */
@property(nonatomic,retain)UITableView *tableView;



@end

@implementation HB_HelpRemoveRepeadVC

-(void)dealloc{
    [_dataArr release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInterface];
    [self setupNavigationBar];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenTabBar];
}
#pragma mark - 数据源
-(NSMutableArray *)dataArr{
    if (_dataArr ==nil) {
        _dataArr=[[NSMutableArray alloc]init];
        [self initDataArr];
    }
    return _dataArr;
}
-(void)initDataArr{
    [_dataArr removeAllObjects];
    NSArray * arr=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help.plist" ofType:nil]];
    for (NSDictionary * dict in arr) {
        HB_HelpGroupModel * model=[HB_HelpGroupModel modelWithDict:dict];
        [_dataArr addObject:model];
    }
}
#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"帮助";
}
/**
 *  设置界面
 */
-(void)setupInterface{
    //tableView
    CGFloat tableView_W=SCREEN_WIDTH;
    CGFloat tableView_H=SCREEN_HEIGHT-64;
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
}

#pragma mark - tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HB_HelpGroupModel * model=self.dataArr[section];
    if (model.isOpen) {
        return 1;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_HelpRemoveCell * cell=[HB_HelpRemoveCell cellWithTableView:tableView];
    cell.model=self.dataArr[indexPath.section];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_HelpGroupModel * model=self.dataArr[indexPath.section];
    NSMutableDictionary * attributeDict=[NSMutableDictionary dictionary];
    attributeDict[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    CGSize size=[model.answer boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, 100) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;

    return (size.height+20)>50?(size.height+20):50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self hightForSectionHeaderView:section];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HB_HelpSectionHeaderView * headerView=[HB_HelpSectionHeaderView headerViewWithTableView:tableView];
    headerView.tag = section;
    headerView.model=self.dataArr[section];
    headerView.delegate=self;
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
#pragma mark - 获取section的headerView的高度
-(CGFloat)hightForSectionHeaderView:(NSInteger)section{
    HB_HelpGroupModel * model=self.dataArr[section];
    NSMutableDictionary * attributeDict=[NSMutableDictionary dictionary];
    attributeDict[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    CGSize size=[model.question boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 100) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
    return (size.height)>50?(size.height):50;
}
#pragma mark - headerView中按钮的点击代理方法
-(void)helpSectionDidClickWihtHeaderView:(HB_HelpSectionHeaderView *)headerView{
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headerView.tag] withRowAnimation:UITableViewRowAnimationFade];
}
@end
