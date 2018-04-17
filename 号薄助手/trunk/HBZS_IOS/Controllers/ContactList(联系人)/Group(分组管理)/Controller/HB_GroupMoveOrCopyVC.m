//
//  HB_GroupMoveOrCopyVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/1.
//
//

#import "HB_GroupMoveOrCopyVC.h"
#import "HB_GroupManageCell.h"
#import "HB_GroupModel.h"
#import "GroupData.h"
#import "HB_ContactSimpleModel.h"

@interface HB_GroupMoveOrCopyVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)UITableView  *tableView;
@property(nonatomic,retain)NSMutableArray *dataArr;

@end

@implementation HB_GroupMoveOrCopyVC
-(void)dealloc{
    [_dataArr release];
    [_contactDataArr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInterface];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDataArr];
    [_tableView reloadData];
}
#pragma mark - 设置界面
/**
 *  设置界面
 */
-(void)setupInterface{
    //添加tableView
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGFloat tableView_W=SCREEN_WIDTH;
    CGFloat tableView_H=SCREEN_HEIGHT-64;
    CGRect tableFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.rowHeight=60;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    _tableView=tableView;
}
#pragma mark - 数据源
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
/** 初始化数据源 */
-(void)initDataArr{
    [self.dataArr removeAllObjects];
    //1.获取所有群组的名称以及ID
    NSArray * arr = [GroupData getAllGroupIDAndGroupNameArray];
    for (int i=0; i<arr.count; i++) {
        NSDictionary * dict=arr[i];
        HB_GroupModel * groupModel=[[HB_GroupModel alloc]init];
        [groupModel setValuesForKeysWithDictionary:dict];
        if (groupModel.groupID == _currentGroupID) {
            continue;
        }
        [self.dataArr addObject:groupModel];
        [groupModel release];
    }
}
#pragma mark - tableView的协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_GroupManageCell * cell=[HB_GroupManageCell cellWithTableView:tableView];
    //隐藏掉一些不需要用的控件
    cell.arrowImageView.hidden=YES;
    cell.editBtn.hidden=YES;
    cell.deleteBtn.hidden=YES;
    cell.shareBtn.hidden = YES;
    
    cell.model=self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HB_GroupModel * groupModle=self.dataArr[indexPath.row];
    if ([self.title isEqualToString:@"拷贝到"]) {
        //复制联系人
        for (int i=0; i<_contactDataArr.count; i++) {
            HB_ContactSimpleModel * contactModel=self.contactDataArr[i];
            [GroupData addPerson:contactModel.contactID.intValue toGroup:groupModle.groupID];
        }
    }else if ([self.title isEqualToString:@"移动到"]){
        //复制联系人
        for (int i=0; i<_contactDataArr.count; i++) {
            HB_ContactSimpleModel * contactModel=self.contactDataArr[i];
            [GroupData addPerson:contactModel.contactID.intValue toGroup:groupModle.groupID];
        }
        //删除原来分组中的联系人
        for (int i=0; i<_contactDataArr.count; i++) {
            HB_ContactSimpleModel * contactModel=self.contactDataArr[i];
            [GroupData removePerson:contactModel.contactID.intValue fromGroup:_currentGroupID];
        }
    }
    //回调
    self.optionBlock(groupModle);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -


@end
