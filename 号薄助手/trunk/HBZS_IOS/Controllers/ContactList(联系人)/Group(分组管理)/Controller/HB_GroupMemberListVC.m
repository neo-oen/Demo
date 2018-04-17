//
//  HB_GroupMemberListVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
// cell共用 HB_ContactCell
typedef NS_OPTIONS(NSUInteger, NavigationBarButtonType){
    NavigationBarEditBtn=1,//编辑按钮
    NavigationBarAddBtn,//添加按钮
    NavigationBarFinishBtn,//确认按钮
};

#import "HB_GroupMemberListVC.h"
#import "GroupData.h"//分组管理类
#import "HB_ContactCell.h"//联系人cell
#import "HB_ContactSimpleModel.h"//简易的联系人模型
#import "HB_ContactSendTopTool.h"//置顶联系人相关操作
#import "HB_ContactDataTool.h"//联系人管理类
#import "pinyin.h"
#import "HB_GroupAddMemberVC.h"//群组添加联系人vc
#import "HB_ContactInfoVC.h"//联系人详情页
#import "HB_GroupMoveOrCopyVC.h"//联系人复制或者剪切 的类
#import "NSString+Extension.h"

@interface HB_GroupMemberListVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
/** 导航栏 编辑按钮 */
@property(nonatomic,retain)UIButton *navEditBtn;
/** 导航栏 编辑按钮barButtonItem */
@property(nonatomic,retain)UIBarButtonItem *navEditBtnItem;
/** 导航栏 添加按钮 */
@property(nonatomic,retain)UIButton *navAddBtn;
/** 导航栏 添加按钮barButtonItem */
@property(nonatomic,retain)UIBarButtonItem *navAddBtnItem;
/** 导航栏 确认按钮 */
@property(nonatomic,retain)UIButton *navFinishBtn;
/** 导航栏 添加按钮barButtonItem */
@property(nonatomic,retain)UIBarButtonItem *navFinishBtnItem;
/** 导航栏 UIBarButtonItem数组 */
@property(nonatomic,retain)NSMutableArray *barButtonItemsArr;
/** 导航栏上的空白占位的UIBarButtonItem */
@property(nonatomic,retain)UIBarButtonItem *navFixedSpaceBtnItem;
/** 分组成员id数组 */
@property(nonatomic,retain)NSArray *groupMemberIDArr;
/** 底部（全选）底部工具条 */
@property(nonatomic,retain)UIToolbar *bottomToolBar;
/** 底部（全选）按钮 */
@property(nonatomic,retain)UIButton * selectAllBtn;
/** tableView */
@property(nonatomic,retain)UITableView * tableView;
/** 数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/** 已经被选中的cell的HB_ContactSimpleModel数据源 */
@property(nonatomic,retain)NSMutableArray *selectedCellModelArr;

@end

@implementation HB_GroupMemberListVC
#pragma mark - life cycle
-(void)dealloc{
    [_navAddBtnItem release];
    [_navEditBtnItem release];
    [_navFinishBtnItem release];
    [_navFixedSpaceBtnItem release];
    [_groupMemberIDArr release];
    [_bottomToolBar release];
    [_tableView release];
    [_dataArr release];
    [_selectedCellModelArr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomToolBar];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次加载页面都重新获取分组联系人成员id数组
    self.groupMemberIDArr = [GroupData getGroupAllContactIDByID:_groupID];
    //刷新数据
    [self.dataArr removeAllObjects];
    [_tableView reloadData];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //bottomToolBar
    CGFloat toolBar_X = 0;
    CGFloat toolBar_Y = CGRectGetMaxY(self.tableView.frame);
    CGRect bottomToolBarFrame = {{toolBar_X,toolBar_Y},self.bottomToolBar.bounds.size};
    self.bottomToolBar.frame = bottomToolBarFrame;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.tableView.editing = NO;
    self.selectAllBtn.selected = NO;
    //改变tableView的frame，隐藏toolBar
    self.tableView.frame = self.view.bounds;
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_ContactCell *cell = [HB_ContactCell cellWithTableView:tableView];
    HB_ContactSimpleModel *model = self.dataArr[indexPath.section][indexPath.row];
    cell.contactModel = model;
    if ([self.selectedCellModelArr containsObject:model]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"sec = %lu --row=%lu",section,[self.dataArr[section] count]);
    return [self.dataArr[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView==self.tableView) {
        NSArray * sectionIndexTitles = [[NSArray alloc]initWithObjects:
                                        @"A", @"B", @"C", @"D",
                                        @"E", @"F", @"G",
                                        @"H", @"I", @"J", @"K", @"L", @"M", @"N",
                                        @"O", @"P", @"Q", @"R", @"S", @"T", @"U",
                                        @"V",@"W", @"X", @"Y", @"Z",  @"#",nil];
        tableView.sectionIndexColor=COLOR_F;
        return [sectionIndexTitles autorelease];
    }else{
        return nil;
    }
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.dataArr[section] count]==0){
        return 0.0000001;
    }else{
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.dataArr[section] count]==0){
        return 0.0000001;
    }else{
        return 0.5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.dataArr[section] count]==0){
        return nil;
    }else{
        UIView * headerView=[[[UIView alloc]init] autorelease];
        headerView.backgroundColor=[UIColor clearColor];
        headerView.frame=CGRectMake(0, 0, tableView.bounds.size.width, 30);
        CGRect labelFrame;
        if (tableView.editing) {
            labelFrame = CGRectMake(50, 0, SCREEN_WIDTH-50-15, 30);
        }else{
            labelFrame = CGRectMake(15, 0, SCREEN_WIDTH-15-15, 30);
        }
        UILabel * label=[[UILabel alloc]initWithFrame:labelFrame];
        NSString * titleStr=nil;
        if (section <= (self.dataArr.count-1)) {
            titleStr = [NSString stringWithFormat:@"%C",(unichar)(section+'A')];
        }else{
            titleStr = @"#";
        }
        label.text=titleStr;
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=COLOR_E;
        [headerView addSubview:label];
        [label release];
        return headerView;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.dataArr[section] count]==0){
        return nil;
    }else{
        UIView * footerView=[[[UIView alloc]init] autorelease];
        footerView.frame=CGRectMake(0, 0, tableView.bounds.size.width, 0.5);
        CGRect lineLabelFrame;
        if (tableView.editing) {
            lineLabelFrame = CGRectMake(50, 0, SCREEN_WIDTH-50-15, 0.5);
        }else{
            lineLabelFrame = CGRectMake(15, 0, SCREEN_WIDTH-15-15, 0.5);
        }
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:lineLabelFrame];
        lineLabel.backgroundColor=COLOR_H;
        [footerView addSubview:lineLabel];
        [lineLabel release];
        return footerView;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //当tableView处于非编辑状态的时候，才会跳转
    if (tableView.editing == NO) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HB_ContactInfoVC * infoVC=[[HB_ContactInfoVC alloc]init];
        HB_ContactSimpleModel * model =self.dataArr[indexPath.section][indexPath.row];
        infoVC.recordID=model.contactID.intValue;
        [self.navigationController pushViewController:infoVC animated:YES];
        [infoVC release];
    }else{//处于编辑状态，多选状态
        self.navFinishBtn.enabled=YES;
        HB_ContactCell *cell = (HB_ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selected = YES;
        //把选中的indexPath对应的model添加到选中的数据源
        HB_ContactSimpleModel *model = self.dataArr[indexPath.section][indexPath.row];
        [self.selectedCellModelArr addObject: model];
        if (self.selectedCellModelArr.count == self.groupMemberIDArr.count) {
            self.selectAllBtn.selected = YES;
        }
        else
        {
            self.selectAllBtn.selected = NO;
        }
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing==YES) {
        NSArray * selectedIndexPathsArr = [tableView indexPathsForSelectedRows];
        if (selectedIndexPathsArr.count == 0) {
            self.navFinishBtn.enabled = NO;
        }
        HB_ContactCell *cell = (HB_ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
        HB_ContactSimpleModel *model = self.dataArr[indexPath.section][indexPath.row];
        [self.selectedCellModelArr removeObject:model];
        self.selectAllBtn.selected = NO;
    }
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//第一个：拷贝到
        HB_GroupMoveOrCopyVC * vc=[[HB_GroupMoveOrCopyVC alloc]init];
        vc.title=@"拷贝到";
        vc.contactDataArr = self.selectedCellModelArr;
        vc.currentGroupID=_groupID;
        __unsafe_unretained HB_GroupMemberListVC * weakSelf = self;
        vc.optionBlock=^(HB_GroupModel * groupModel){
            weakSelf.groupID=groupModel.groupID;
            weakSelf.title=groupModel.groupName;
            _tableView.editing=NO;
            _bottomToolBar.hidden=YES;
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else if (buttonIndex==1){//第二个：移动到
        HB_GroupMoveOrCopyVC * vc=[[HB_GroupMoveOrCopyVC alloc]init];
        vc.title=@"移动到";
        vc.contactDataArr = self.selectedCellModelArr;
        vc.currentGroupID=_groupID;
        __unsafe_unretained HB_GroupMemberListVC * weakSelf = self;
        vc.optionBlock=^(HB_GroupModel * groupModel){
            weakSelf.groupID=groupModel.groupID;
            weakSelf.title=groupModel.groupName;
            _tableView.editing=NO;
            _bottomToolBar.hidden=YES;
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }else if (buttonIndex==2){//第三个：移出
        for (int i=0; i<self.selectedCellModelArr.count; i++) {
            HB_ContactSimpleModel * model = self.selectedCellModelArr[i];
            [GroupData removePerson:model.contactID.intValue fromGroup:(ABRecordID)_groupID];
            
            
        }
        self.groupMemberIDArr = [GroupData getGroupAllContactIDByID:_groupID];
        [self.dataArr removeAllObjects];
        [self.tableView reloadData];
    }
}
#pragma mark - event response
-(void)navigationBarButtonClick:(UIButton *)btn{
    switch (btn.tag) {
        case NavigationBarAddBtn:{
            //1.'添加'按钮
            HB_GroupAddMemberVC *addVC = [[HB_GroupAddMemberVC alloc]init];
            addVC.groupID = self.groupID;
            [self.navigationController pushViewController:addVC animated:YES];
            [addVC release];
        }break;
        case NavigationBarEditBtn:{
            if (self.tableView.editing) {
                return;
            }
            //2.'编辑'按钮
            self.tableView.editing = YES;
            //改变导航栏按钮
            self.navigationItem.rightBarButtonItems = @[self.navFinishBtnItem];
            //改变tableView的frame，露出toolBar
            CGRect tableViewFrame = self.tableView.frame;
            self.tableView.frame = (CGRect){tableViewFrame.origin,{tableViewFrame.size.width,tableViewFrame.size.height - self.bottomToolBar.bounds.size.height}};
            [self.tableView reloadData];
        }break;
        case NavigationBarFinishBtn:{
            //3.导航栏右侧‘确定’按钮
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拷贝到",@"移动到",@"移出", nil];
            [sheet showInView:self.view];
            [sheet release];
        }break;
        default:break;
    }
}
/**
 *  全选按钮点击
 */
-(void)selectAllBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.navFinishBtn.enabled = btn.selected;
    if (btn.selected) {
        //全选
        for (int i=0; i<self.dataArr.count; i++) {
            NSArray *sectionDataArr = self.dataArr[i];
            for (int j=0; j<sectionDataArr.count; j++) {
                HB_ContactSimpleModel *simpleModel = sectionDataArr[j];
                [self.selectedCellModelArr addObject:simpleModel];
            }
        }
    }else{
        //全不选
        [self.selectedCellModelArr removeAllObjects];
    }
    
    NSArray * visibleCellArr = [self.tableView indexPathsForVisibleRows];
    for (int i=0; i<visibleCellArr.count; i++) {
        NSIndexPath * indexPath = visibleCellArr[i];
        HB_ContactCell *cell = (HB_ContactCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:btn.selected];
        if (btn.selected) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark - setter and getter
-(void)setGroupMemberIDArr:(NSArray *)groupMemberIDArr{
    if (_groupMemberIDArr != groupMemberIDArr) {
        [_groupMemberIDArr release];
        _groupMemberIDArr = [groupMemberIDArr retain];
    }
    //根据有无联系人，创建导航栏按钮
    if (_groupMemberIDArr.count) {
        self.navigationItem.rightBarButtonItems = @[self.navEditBtnItem,self.navFixedSpaceBtnItem,self.navAddBtnItem];
    }else{
        self.navigationItem.rightBarButtonItems = @[self.navAddBtnItem];
        
//        //这里接着判断，是否是第一次进入这个空白分组，如果是，则需要展示引导层
//        NSString * keyStr=[NSString stringWithFormat:@"isFirstOpen_%d",_groupID];
//        NSString * isFirst = [[NSUserDefaults standardUserDefaults]objectForKey:keyStr];
//        if (isFirst==nil) {//第一次打开
//            [self showGuideView];
//            //把flage置为非空，则表示已经打开过一次了
//            isFirst=@"1";
//            NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
//            [defaults setObject:isFirst forKey:keyStr];
//            [defaults synchronize];
//        }
    }
}
-(UIBarButtonItem *)navEditBtnItem{
    if (!_navEditBtnItem) {
        _navEditBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.navEditBtn];
    }
    return _navEditBtnItem;
}
-(UIBarButtonItem *)navAddBtnItem{
    if (!_navAddBtnItem) {
        _navAddBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.navAddBtn];
    }
    return _navAddBtnItem;
}
-(UIBarButtonItem *)navFinishBtnItem{
    if (!_navFinishBtnItem) {
        _navFinishBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.navFinishBtn];
    }
    return _navFinishBtnItem;
}
-(UIBarButtonItem *)navFixedSpaceBtnItem{
    if (!_navFixedSpaceBtnItem) {
        _navFixedSpaceBtnItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        _navFixedSpaceBtnItem.width = 20;
    }
    return _navFixedSpaceBtnItem;
}
-(UIButton *)navAddBtn{
    if (!_navAddBtn) {
        _navAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
        _navAddBtn.exclusiveTouch = YES;
        [_navAddBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        _navAddBtn.tag = NavigationBarAddBtn;
        [_navAddBtn addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navAddBtn;
}
-(UIButton *)navEditBtn{
    if (!_navEditBtn) {
        _navEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navEditBtn setFrame:CGRectMake(0, 0, 20, 20)];
        _navEditBtn.exclusiveTouch = YES;
        [_navEditBtn setImage:[UIImage imageNamed:@"批量操作"] forState:UIControlStateNormal];
        _navEditBtn.tag = NavigationBarEditBtn;
        [_navEditBtn addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navEditBtn;
}
-(UIButton *)navFinishBtn{
    if (!_navFinishBtn) {
        _navFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navFinishBtn setFrame:CGRectMake(0, 0, 40, 20)];
        _navFinishBtn.exclusiveTouch = YES;
        [_navFinishBtn setTitle:@"确认" forState:UIControlStateNormal];
        _navFinishBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_navFinishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _navFinishBtn.tag = NavigationBarFinishBtn;
        _navFinishBtn.enabled = NO;
        [_navFinishBtn addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navFinishBtn;
}
-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat tableView_W = SCREEN_WIDTH;
        CGFloat tableView_H = SCREEN_HEIGHT-64;
        CGFloat tableView_X = 0;
        CGFloat tableView_Y = 0;
        CGRect tableViewFrame = CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
    }
    return _tableView;
}
-(UIToolbar *)bottomToolBar{
    if (!_bottomToolBar) {
        _bottomToolBar = [[UIToolbar alloc]init];
        CGFloat toolBar_W = SCREEN_WIDTH;
        CGFloat toolBar_H = 44;
        _bottomToolBar.bounds = CGRectMake(0, 0, toolBar_W, toolBar_H);
        //全选按钮
        [_bottomToolBar addSubview:self.selectAllBtn];
        self.selectAllBtn.frame = CGRectMake(13, 0, 100, toolBar_H);
    }
    return _bottomToolBar;
}
-(UIButton *)selectAllBtn{
    if (!_selectAllBtn) {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_selectAllBtn setImage:[UIImage imageNamed:@"选框"] forState:UIControlStateNormal];
        [_selectAllBtn setImage:[UIImage imageNamed:@"选框-选中"] forState:UIControlStateSelected];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn setTitleColor:COLOR_D forState:UIControlStateNormal];
        [_selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _selectAllBtn;
}
-(NSMutableArray *)selectedCellModelArr{
    if (!_selectedCellModelArr) {
        _selectedCellModelArr=[[NSMutableArray alloc]init];
    }
    return _selectedCellModelArr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr =[[NSMutableArray alloc]init];
    }
    if (!_dataArr.count) {
        for (int i=0; i<27; i++) {
            NSMutableArray * groupArr =[NSMutableArray array];
            [_dataArr addObject:groupArr];
        }
        for (int i=0; i<self.groupMemberIDArr.count; i++) {
            NSString *recordID = self.groupMemberIDArr[i];
            NSDictionary *propertyDict = [HB_ContactDataTool contactSimplePropertyArrWithRecordID:recordID.intValue];
            HB_ContactSimpleModel *simpleModel = [[HB_ContactSimpleModel alloc]init];
            [simpleModel setValuesForKeysWithDictionary:propertyDict];
            //根据首字母分组
            NSString *nameStr = simpleModel.name;
            NSString *nameStr_PinYin = [nameStr chineseToPinYin];
            char firstChar = [nameStr_PinYin characterAtIndex:0];
            NSMutableArray *subGroupArr = nil;
            if (firstChar>='A' && firstChar<='Z') {
                subGroupArr = [self.dataArr objectAtIndex:(int)(firstChar-'A')];
            }else{
                subGroupArr = [self.dataArr lastObject];
            }
            [subGroupArr addObject:simpleModel];
            [simpleModel release];
        }
    }
    return _dataArr;
}


@end
