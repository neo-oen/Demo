//
//  HB_ContactDetailGroupManagerVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/9/17.
//
//

#import "HB_ContactDetailGroupManagerVC.h"
#import "HB_ContactDetailGroupManageCell.h"
#import "GroupData.h"
#import "HB_GroupModel.h"
#import "SVProgressHUD.h"

@interface HB_ContactDetailGroupManagerVC ()<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
/**
 *  数据源（分组列表）
 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**
 *  联系人当前所在的群组
 */
@property(nonatomic,retain)NSMutableArray * currentGroupArr;

@property(nonatomic,retain)NSMutableArray * groupsArrforNewcontact;


@end

@implementation HB_ContactDetailGroupManagerVC
- (void)dealloc {
    [_dataArr release];
    [_currentGroupArr release];
//    [_tableView release];
    [_arrowCellModel release];
    [_groupsArrforNewcontact release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"分组管理";
    self.tableView.editing=YES;
    self.tableView.allowsMultipleSelectionDuringEditing=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.recordID) {
        return ;
    }
    if ([self.delegate respondsToSelector:@selector(GroupIdsforNewContact:)]) {
        [self.delegate GroupIdsforNewContact:self.groupsArrforNewcontact];
    }
    
}

-(NSMutableArray *)groupsArrforNewcontact
{
    if (_groupsArrforNewcontact == nil) {
        _groupsArrforNewcontact = [[NSMutableArray alloc] init];
    }
    return _groupsArrforNewcontact;
}

#pragma mark - 获取所有分组列表(数据源)
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
        [self initDataArr];
    }
    return _dataArr;
}
/**
 *  初始化数据源
 */
-(void)initDataArr{
    [_dataArr removeAllObjects];
    //获取所有群组信息,插入数据源
    NSArray * groupInfoArr=[GroupData getAllGroupIDAndGroupNameArray];
    for (NSDictionary * dict in groupInfoArr) {
        HB_GroupModel * groupModel=[[HB_GroupModel alloc]init];
        [groupModel setValuesForKeysWithDictionary:dict];
        [_dataArr addObject:groupModel];
        [groupModel release];
    }
}
/**
 *  当前联系人所在的群组
 */
-(NSMutableArray *)currentGroupArr{
    if (_currentGroupArr==nil) {
        _currentGroupArr=[[NSMutableArray alloc]init];
        [self initCurrentGroupArr];
    }
    return _currentGroupArr;
}
/**
 *  初始化currentGroupArr
 */
-(void)initCurrentGroupArr{
    [_currentGroupArr removeAllObjects];
    //添加数据(群组id数组)
    NSArray * groupIDArr = [GroupData getAllGroupsIDByContactID:self.recordID];
    [_currentGroupArr addObjectsFromArray:groupIDArr];
}

#pragma mark - tableView协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_ContactDetailGroupManageCell * cell=[HB_ContactDetailGroupManageCell cellWithTableView:tableView];
    HB_GroupModel * groupModel=self.dataArr[indexPath.row];
    cell.groupNameLabel.text=groupModel.groupName;
    int i=0;
    for (NSNumber * tempGroupIDNum in self.currentGroupArr) {
        if (groupModel.groupID == tempGroupIDNum.integerValue) {
            break;
        }
        i++;
    }
    if (i<self.currentGroupArr.count) {//证明找到相等的了
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中某一行
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    //使得该cell选中
    HB_ContactDetailGroupManageCell * cell=(HB_ContactDetailGroupManageCell *)[tableView cellForRowAtIndexPath:indexPath];

    
    cell.selected=YES;
    //将当前联系人加入到当前分组
    HB_GroupModel * groupModel = self.dataArr[indexPath.row];
    if (self.recordID) {
        [GroupData addPerson:self.recordID toGroup:groupModel.groupID];
        [self initCurrentGroupArr];
        //获取当前所在的分组信息
        [self getCurrentGroupsName];
    }
    else //新建联系人时
    {
        [self addGroupTogroupsArrforNewcontact:groupModel];
    }
    
    
//    [_tableView reloadData];

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中某一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //使得改cell取消选中
    HB_ContactDetailGroupManageCell * cell=(HB_ContactDetailGroupManageCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected=NO;
    HB_GroupModel * groupModel = self.dataArr[indexPath.row];

    if (self.recordID) {
        //将当前联系人从当前分组移出
        [GroupData removePerson:self.recordID fromGroup:groupModel.groupID];
        [self initCurrentGroupArr];
        //获取当前所在的分组信息
        [self getCurrentGroupsName];
    }
    else //新建联系人时
    {
        [self deleteGroupTogroupsArrforNewcontact:groupModel.groupID];
    }
    
    
    
//    [_tableView reloadData];

}
#pragma mark - 获取当前所在的分组信息
/**
 *  获取当前所在的分组信息
 */
-(void)getCurrentGroupsName{
    //当前所在的所有分组名字
    NSMutableString * groupsNameStr=[[NSMutableString alloc]init];
    NSArray * groupIDArr = [GroupData getAllGroupsIDByContactID:_recordID];
    for (int i=0; i<groupIDArr.count ; i++) {
        NSNumber * groupID = groupIDArr[i];
        NSString * groupName = [GroupData getGroupNameByGroupID:groupID.integerValue];
        if (i == groupIDArr.count-1) {//最后一个
            [groupsNameStr appendFormat:@"%@",groupName];
        }else{
            [groupsNameStr appendFormat:@"%@,",groupName];
        }
    }
    self.arrowCellModel.listModel.groupsName=groupsNameStr;
    [groupsNameStr release];
}


-(void)addGroupTogroupsArrforNewcontact:(HB_GroupModel *)groupModel
{
    [self.groupsArrforNewcontact addObject:groupModel];
}
-(void)deleteGroupTogroupsArrforNewcontact:(NSInteger)groupid
{
    for (HB_GroupModel * model in self.groupsArrforNewcontact) {
        if (model.groupID == groupid) {
            [self.groupsArrforNewcontact removeObject:model];
        }
    }
}


@end
