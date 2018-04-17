//
//  HB_OneKeySelectContactListVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/9/1.
//
//

#import "HB_OneKeySelectContactListVC.h"
#import "HB_ContactCell.h"//联系人cell
#import "HB_ContactSimpleModel.h"//简易的联系人模型
#import "HB_ContactSendTopTool.h"//置顶联系人相关操作
#import "HB_ContactDataTool.h"//联系人管理类
#import "pinyin.h"
#import "HB_OneKeyCallModel.h"//一键拨号的模型
#import "SettingInfo.h"
#import "HB_PhoneNumModel.h"

@interface HB_OneKeySelectContactListVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

/** tableView */
@property(nonatomic,assign)UITableView * tableView;
/** 数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**
 *  当前选中的cell的indexPath
 */
@property(nonatomic,retain)NSIndexPath *currentIndexPath;


@end

@implementation HB_OneKeySelectContactListVC

-(void)dealloc{
    [_dataArr release];
    [_currentIndexPath release];
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
    //查找出所有的联系人
    NSArray * contactDictArr=[HB_ContactDataTool contactGetAllContactSimpleProperty];
    //添加
    [self setupContactArrWithContactDictArr:contactDictArr];
    //刷新
    [_tableView reloadData];
}
#pragma mark - 设置界面
-(void)setupNavigationBar{
    self.title=@"添加";
    
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
    labelFrame = CGRectMake(15, 0, SCREEN_WIDTH-15-15, 30);
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
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15-15, 0.5)];
        lineLabel.backgroundColor=COLOR_H;
        [footerView addSubview:lineLabel];
        [lineLabel release];
        return footerView;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //记录当前选中的indexPath
    _currentIndexPath=[indexPath copy];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //1.获取联系人id
    HB_ContactSimpleModel * simpleModel=self.dataArr[indexPath.section][indexPath.row];
    NSString * recordIDStr=simpleModel.contactID;
    //2.根据id查出该联系人所有属性字典
    NSDictionary * modelDict=[HB_ContactDataTool contactPropertyArrWithRecordID:recordIDStr.integerValue];
    //3.创建模型，并赋值
    HB_ContactModel * model=[[HB_ContactModel alloc]init];
    [model setValuesForKeysWithDictionary:modelDict];
    //4.获取该联系人的电话数组
    NSMutableArray *phoneArr = [NSMutableArray array];
    [model.phoneArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HB_PhoneNumModel *phoneModel = (HB_PhoneNumModel *)obj;
        [phoneArr addObject:phoneModel.phoneNum];
    }];
    [model release];
    //判断，如果没有电话号码，则提示“无电话”
    if (phoneArr.count==0) {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"该用户无号码" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        [alert release];
    }else if (phoneArr.count==1){//如果有一个号码，则直接存储，并返回
        [self saveOneKeyCallModelWithIndexPath:_currentIndexPath andPhoneNumStr:phoneArr[0]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{//有多个号码，提示用户选择
        UIActionSheet * sheet=[[UIActionSheet alloc]init];
        sheet.title=@"请选择一个号码";
        sheet.delegate=self;
        for (int i=0; i<phoneArr.count; i++) {
            [sheet addButtonWithTitle:phoneArr[i]];
        }
        [sheet addButtonWithTitle:@"取消"];
        [sheet setCancelButtonIndex:[sheet numberOfButtons]-1];
        
        [sheet showInView:self.view];
        [sheet release];
    }
}
#pragma mark - actionSheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger cancelBtnIndex=actionSheet.numberOfButtons-1;
    if (buttonIndex != cancelBtnIndex) {//如果不是“取消”按钮
        NSString * phoneNumStr=[actionSheet buttonTitleAtIndex:buttonIndex];
        [self saveOneKeyCallModelWithIndexPath:_currentIndexPath andPhoneNumStr:phoneNumStr];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 构造一个HB_OneKeyCallModel，并存储起来
/**
 *  构造一个HB_OneKeyCallModel，并存储起来
 */
-(void)saveOneKeyCallModelWithIndexPath:(NSIndexPath *)indexPath andPhoneNumStr:(NSString *)phoneNumStr{
    //根据indexPath找出联系人的simpleModel
    HB_ContactSimpleModel * simpleModel=self.dataArr[indexPath.section][indexPath.row];
    //创建HB_OneKeyCallModel，并手动赋值
    HB_OneKeyCallModel * oneKeyCallModel=[[HB_OneKeyCallModel alloc]init];
    oneKeyCallModel.keyNumber=self.keyNumber;
    oneKeyCallModel.recordID=simpleModel.contactID.integerValue;
    oneKeyCallModel.iconData_thumbnail=simpleModel.iconData_thumbnail;
    oneKeyCallModel.name=simpleModel.name;
    oneKeyCallModel.phoneNum=phoneNumStr;
    //从userDefaults中取出字典
    NSDictionary * dict=[SettingInfo getOneKeyCall];
    NSMutableDictionary * mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    //把自定义对象序列化
    NSData * data=[NSKeyedArchiver archivedDataWithRootObject:oneKeyCallModel];
    [mutableDict setObject:data forKey:[NSString stringWithFormat:@"%d",self.keyNumber]];
    [oneKeyCallModel release];
    [SettingInfo setOneKeyCall:mutableDict];
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
