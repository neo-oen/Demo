//
//  HB_ContactPreviewVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/15.
//
//

#import "HB_ContactPreviewVC.h"


@interface HB_ContactPreviewVC ()


@end

@implementation HB_ContactPreviewVC
-(void)dealloc{
    [_dataArr release];
    [_phoneNumStr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenTabBar];
    [self setupNavigationBar];
    [self setupInterface];
}
#pragma mark - 设置界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    self.title=@"选择联系人";
}
/**
 *  设置界面
 */
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
        //建27个小数组,最后一个是“#”
        for (int i=0; i<27; i++) {
            NSMutableArray * groupArr =[NSMutableArray array];
            [_dataArr addObject:groupArr];
        }
        [self initDataArr];
    }
    return _dataArr;
}
/**
 *  1.初始化数据源
 */
-(void)initDataArr{
    //获取所有联系人的头像、姓名、ID
    NSArray * contactSimplePreportyArr = [HB_ContactDataTool contactGetAllContactSimpleProperty];
    //分别按组装入数据源
    for (int i=0; i<contactSimplePreportyArr.count; i++) {
        //1.字典转模型
        NSDictionary * contactDict =contactSimplePreportyArr[i];
        HB_ContactSimpleModel * simpleModel=[[HB_ContactSimpleModel alloc]init];
        [simpleModel setValuesForKeysWithDictionary:contactDict];
        //2.根据首字母分组
        NSString * nameStr=simpleModel.name;
        NSString * nameStr_PinYin=[self chineseToPinYin:nameStr];
        char firstChar=[nameStr_PinYin characterAtIndex:0];
        NSMutableArray * subGroupArr=nil;
        if (firstChar>='A' && firstChar<='Z') {
            subGroupArr =[self.dataArr objectAtIndex:(int)(firstChar-'A')];
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
    cell.contactModel=model;
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
    }else{
        
        NSLog(@"%ld",section);
        if (section == self.dataArr.count-1) {
            titleStr = [NSString stringWithFormat:@"#"];
        }
        else
        {
            unichar a = section+'A';
            titleStr = [NSString stringWithFormat:@"%C",a];
        }
        
        
        
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
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15-15, 0.5)];
        lineLabel.backgroundColor=COLOR_H;
        [footerView addSubview:lineLabel];
        [lineLabel release];
        return footerView;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //进入联系人编辑界面
    HB_ContactDetailController * editVC=[[HB_ContactDetailController alloc]init];
    //传值
    editVC.delegate = self.tempdelegate;
    HB_ContactSimpleModel * simpleModel=self.dataArr[indexPath.section][indexPath.row];
    editVC.contactModel = [HB_ContactModel modelWithRecordID:simpleModel.contactID.integerValue];
    editVC.phoneNumFromCallHistory=self.phoneNumStr;
    [self.navigationController pushViewController:editVC animated:YES];
    [editVC release];
}
#pragma mark - 索引相关
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray * sectionIndexTitles = [[NSArray alloc]initWithObjects:
                                    @"A", @"B", @"C", @"D",
                                    @"E", @"F", @"G",
                                    @"H", @"I", @"J", @"K", @"L", @"M", @"N",
                                    @"O", @"P", @"Q", @"R", @"S", @"T", @"U",
                                    @"V",@"W", @"X", @"Y", @"Z",  @"#",nil];
    tableView.sectionIndexColor=COLOR_F;
    return [sectionIndexTitles autorelease];
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
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

-(UIView *)toobarLineView
{
    UIView * view  =  [[[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 0.5)] autorelease];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}

@end
