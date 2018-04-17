//
//  HB_GroupAddMemberVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/30.
//
//

#import "HB_GroupAddMemberVC.h"
#import "GroupData.h"//分组管理类
#import "HB_ContactCell.h"//联系人cell
#import "HB_ContactSimpleModel.h"//简易的联系人模型
#import "HB_ContactSendTopTool.h"//置顶联系人相关操作
#import "HB_ContactDataTool.h"//联系人管理类
#import "pinyin.h"

@interface HB_GroupAddMemberVC ()<UITableViewDataSource,UITableViewDelegate>

/** 导航栏 确认按钮 */
@property(nonatomic,assign)UIButton * finishBtn_navigationBar;
/** tableView */
@property(nonatomic,assign)UITableView * tableView;
/** 数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;


@end

@implementation HB_GroupAddMemberVC

-(void)dealloc{
    [_dataArr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupInterface];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initDataArr];
    [self setupTopContact];
    NSArray * contactArr = [self getAllContacterFromGroupWithGroupId:_groupID];
    [self setupContactArrWithContactDictArr:contactArr];
    [_tableView reloadData];
}
#pragma mark - 设置界面
-(void)setupNavigationBar{
    self.title=@"添加";
    //1.右侧完成按钮
    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setFrame:CGRectMake(0, 0, 30, 20)];
    finishBtn.exclusiveTouch = YES;
    finishBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [finishBtn setTitle:@"确认" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(navigationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _finishBtn_navigationBar=finishBtn;
    UIBarButtonItem * finishBtnItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    self.finishBtn_navigationBar=finishBtn;
    self.finishBtn_navigationBar.enabled=NO;
    self.navigationItem.rightBarButtonItems=@[finishBtnItem];
    [finishBtnItem release];
}
-(void)navigationBarButtonClick:(UIButton *)btn{
    NSArray * selectCellArr=[_tableView indexPathsForSelectedRows];
    for (int i=0; i<selectCellArr.count; i++) {
        NSIndexPath * indexPath=selectCellArr[i];
        HB_ContactSimpleModel * model = self.dataArr[indexPath.section][indexPath.row];
        BOOL ret = [GroupData addPerson:model.contactID.intValue toGroup:_groupID];
        if (ret) {
            ZBLog(@"添加联系人到群组成功了");
        }
    }
//    [self initDataArr];
//    [self setupTopContact];
//    NSArray * contactArr = [self getAllContacterFromGroupWithGroupId:_groupID];
//    [self setupContactArrWithContactDictArr:contactArr];
//    [_tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupInterface{
    //tableView创建
    CGFloat tableView_W=SCREEN_WIDTH;
    CGFloat tableView_H=SCREEN_HEIGHT-64;
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGRect tableViewFrame = CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.rowHeight=60;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.allowsMultipleSelectionDuringEditing=YES;
    tableView.editing=YES;
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView release];
}
#pragma mark - 数据源
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr =[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
/**
 *  1.初始化数据源
 */
-(void)initDataArr{
    [self.dataArr removeAllObjects];
    //建28个小数组，其中第一个是“置顶” 最后一个是“#”
    for (int i=0; i<28; i++) {
        NSMutableArray * groupArr =[NSMutableArray array];
        [_dataArr addObject:groupArr];
    }
}
/**
 *  2.1 添加置顶联系人到数据源
 */
-(void)setupTopContact{
    //获取置顶联系人分组group
    NSMutableArray * topContactArr=self.dataArr[0];
    //查询所有置顶联系人recordID
    NSArray * recordIDArr=[HB_ContactSendTopTool contactGetAllPeopleWhoSendTop];
    //遍历字典，转化成联系人模型
    for (int i=0; i<recordIDArr.count; i++) {
        NSDictionary * modelDict = [HB_ContactDataTool contactSimplePropertyArrWithRecordID:[recordIDArr[i] integerValue]];
        HB_ContactSimpleModel * model =[[HB_ContactSimpleModel alloc]init];
        [model setValuesForKeysWithDictionary:modelDict];
        [topContactArr addObject:model];
        [model release];
    }
    //删除包含的群组成员
    //2.获取群组联系人
    NSArray * groupMemberRecordIDArr=[GroupData getGroupAllContactIDByID:_groupID];
    for (int i=0; i<groupMemberRecordIDArr.count; i++) {
        for (int j=0; j<topContactArr.count; j++) {
            HB_ContactSimpleModel * model =topContactArr[j];
            if ([model.contactID isEqualToString:groupMemberRecordIDArr[i]]) {
                [topContactArr removeObject:model];
                break;
            }
        }
    }
}
/**
 *  2.2 给数据源里面添加联系人信息，分组添加
 */
-(void)setupContactArrWithContactDictArr:(NSArray *)contactDictArr{
    //分别按组装入数据源
    for (int i=0; i<contactDictArr.count; i++) {
        //1.字典转模型
        NSDictionary * contactDict =contactDictArr[i];
        HB_ContactSimpleModel * simpleModel=[[HB_ContactSimpleModel alloc]init];
        [simpleModel setValuesForKeysWithDictionary:contactDict];
        //2.判断该联系人是否被置顶，如果被置顶，就不要加了
        BOOL isTop = [HB_ContactSendTopTool contactIsSendTopWithRecordID:simpleModel.contactID.integerValue];
        if (isTop) {
            continue;
        }
        //3.根据首字母分组
        NSString * nameStr=simpleModel.name;
        NSString * nameStr_PinYin=[self chineseToPinYin:nameStr];
        char firstChar=[nameStr_PinYin characterAtIndex:0];
        NSMutableArray * subGroupArr=nil;
        if (firstChar>='A' && firstChar<='Z') {
            subGroupArr =[self.dataArr objectAtIndex:(int)(firstChar-'A'+1)];
        }else{
            subGroupArr=[self.dataArr lastObject];
        }
        [subGroupArr addObject:simpleModel];
        [simpleModel release];
    }
}
/**
 * 根据群组ID获取 除了群组成员外 所有联系人的属性 字典 数组
 */
-(NSArray *)getAllContacterFromGroupWithGroupId:(NSInteger )groupID{
    //1.获取所有联系人
    NSArray * allContactArr=[HB_ContactDataTool contactGetAllContactSimpleProperty];
    NSMutableArray * mutableArr=[allContactArr mutableCopy];
    //2.获取群组联系人
    NSArray * groupMemberRecordIDArr=[GroupData getGroupAllContactIDByID:_groupID];
    //3.求出其余的联系人数组,返回
    for (int i=0; i<groupMemberRecordIDArr.count; i++) {
        for (int j=0; j<mutableArr.count; j++) {
            NSDictionary * dict=mutableArr[j];
            if ([[dict objectForKey:@"contactID"] isEqualToString: groupMemberRecordIDArr[i]]) {
                [mutableArr removeObject:dict];
                break;
            }
        }
    }
    return mutableArr;
}
#pragma mark - tableView代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_ContactCell * cell=[HB_ContactCell cellWithTableView:tableView];
    HB_ContactSimpleModel * model=self.dataArr[indexPath.section][indexPath.row];
    cell.contactModel=[model retain];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
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
    NSString * titleStr=nil;
    if ([self.dataArr[section] count]==0){
        return nil;
    }else if (section==0){
        titleStr = @"置顶";
    }else{
        unichar a = section-1+'A' ;
        titleStr = [NSString stringWithFormat:@"%C",a];
    }
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
    label.text=titleStr;
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=COLOR_E;
    [headerView addSubview:label];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.dataArr[section] count]==0){
        return nil;
    }else{
        UIView * footerView=[[[UIView alloc]init] autorelease];
        footerView.frame=CGRectMake(0, 0, tableView.bounds.size.width, 0.5);
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-15-15, 0.5)];
        lineLabel.backgroundColor=COLOR_H;
        [footerView addSubview:lineLabel];
        [lineLabel release];
        return footerView;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _finishBtn_navigationBar.enabled=YES;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * selectRowsArr=[tableView indexPathsForSelectedRows];
    if (selectRowsArr.count==0) {
        _finishBtn_navigationBar.enabled=NO;
    }
}

#pragma mark - 索引相关
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
    return index+1;//"置顶"没有索引
}
#pragma mark - 汉字转拼音(输入汉字，转出每个字拼音的首字母，拼成字符串)
/**
 * 汉字转拼音(输入汉字，转出每个字拼音的首字母，拼成字符串)
 */
- (NSString *)chineseToPinYin:(NSString*)chineseString {
    NSArray * sourceStringArr=[chineseString componentsSeparatedByString:@" "];
    NSString * sourceString=[sourceStringArr componentsJoinedByString:@""];
    
    NSString * str=[[[NSString alloc]init] autorelease];
    for (int i=0; i<sourceString.length; i++) {
        char c = pinyinFirstLetter([sourceString characterAtIndex:i]);
        str= [str stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
    }
    str = [str uppercaseString];
    
    return str;
}
#pragma mark -

@end
