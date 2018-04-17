//
//  HB_TimeMachineContactPreviewVc.m
//  HBZS_IOS
//
//  Created by chengfei on 16/1/27.
//
//

#import "HB_TimeMachineContactPreviewVc.h"
#import "HB_ContactModel.h"
#import "NSString+Extension.h"
#import "HB_ContactDataTool.h"
#import "HB_TimeMachineDetailvc.h"
#import "MemAddressBook.h"
#import "HB_ContactSendTopTool.h"
#import "HB_timeMachineSucessView.h"
@interface HB_TimeMachineContactPreviewVc ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation HB_TimeMachineContactPreviewVc

-(void)dealloc
{
    [_dataArr release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenTabBar];
    self.title=[NSString stringWithFormat:@"%ld条联系人",self.Mmodel.contactsCount];
    [self allocRightNavItem];
    [self.view addSubview:self.tableView];
    
}
-(void)allocRightNavItem
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitle:@"恢复" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeMachineContactCell"];
    if (cell==nil) {
        cell=[[[HB_ContactCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TimeMachineContactCell"] autorelease];
        [cell setupIconAndName];
        
    }
    NSLog(@"-sec --%ld,_sec---%ld",indexPath.section,indexPath.row);
    HB_ContactModel * model=self.dataArr[indexPath.section][indexPath.row];
    
    NSMutableString * str = [NSMutableString stringWithCapacity:0];

    if (model.lastName) {
        [str appendString:model.lastName];
    }
    if (model.firstName) {
        [str appendString:model.firstName];
    }

    if (str) {
        cell.nameLabel.text = str;
    }
    else
    {
        str = [NSMutableString stringWithFormat:@"未命名"];
    }
    cell.nameLabel.text = str;
    
    if (model.iconData_thumbnail) {
        cell.iconIv.image=[UIImage imageWithData:model.iconData_thumbnail];
    }else{
        cell.iconIv.image=[UIImage imageNamed:@"默认联系人头像"];
    }
 
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
    }
    else if (section == 26)
    {
        titleStr = [NSString stringWithFormat:@"#"];
    }
    else{
        unichar a = section+'A' ;
        titleStr = [NSString stringWithFormat:@"%C",a];
        if (section == self.dataArr.count-1) {
            titleStr = @"#";
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
    //进入联系人详情界面
    HB_ContactModel * model=self.dataArr[indexPath.section][indexPath.row];
    HB_TimeMachineDetailvc * infoVc=[[HB_TimeMachineDetailvc alloc]initWithModel:model];
    
    [self.navigationController pushViewController:infoVc animated:YES];
    [infoVc release];
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

#pragma mark - getter
-(UITableView *)tableView{
    if (!_tableView) {
        //tableView创建
        CGFloat tableView_W=SCREEN_WIDTH;
        CGFloat tableView_H=SCREEN_HEIGHT-64;
        CGFloat tableView_X=0;
        CGFloat tableView_Y=0;
        CGRect tableViewFrame = CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
        _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr =[[NSMutableArray alloc]init];
    }
    if (_dataArr.count == 0) {
        //建27个小数组,最后一个是“#”
        for (int i=0; i<27; i++) {
            NSMutableArray * groupArr =[NSMutableArray array];
            [_dataArr addObject:groupArr];
        }
        //获取所有联系人的头像、姓名、ID
        NSArray *contactPreportyArr = [NSKeyedUnarchiver unarchiveObjectWithData:self.Mmodel.contactsData];
        //分别按组装入数据源
        for (int i=0; i<contactPreportyArr.count; i++) {
            //1.取模型
            HB_ContactModel *model = [contactPreportyArr objectAtIndex:i];
            //2.根据首字母分组
            NSString *nameStr = [HB_ContactDataTool contactGetFullNameWithModel:model];
            NSString *nameStr_PinYin=[nameStr chineseToPinYin];
            
            NSMutableArray *subGroupArr = nil;
            if (!nameStr_PinYin || nameStr_PinYin.length==0) {
                subGroupArr = [_dataArr lastObject];
            }else{
                char firstChar=[nameStr_PinYin characterAtIndex:0];
                if (firstChar>='A' && firstChar<='Z') {
                    subGroupArr = [_dataArr objectAtIndex:(int)(firstChar-'A')];
                }else{
                    subGroupArr = [_dataArr lastObject];
                }
            }
            [subGroupArr addObject:model];
        }
    }
    return _dataArr;
}

-(void)Click
{
    
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:[self AlertString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"恢复", nil] ;
    [al show];
    [al release];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
        {
            [self timeMachineGoBack];
        }
            break;
        default:
            break;
    }
}


-(void)timeMachineGoBack
{
    MemAddressBook * manager = [MemAddressBook getInstance];
    self.TimeMachineProgressView = [[SyncProgressView alloc] init];
    [self.TimeMachineProgressView setProTitleWithString:@"已恢复"];
    [self.TimeMachineProgressView show];
    [self.TimeMachineProgressView setProgressMin];
    [self moveProgress];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [manager removeAllContactFromDb];
            [manager removeAllContactMappingInfo];
            //设置版本号为-1 下次同步是讲进行慢同步
            [[ConfigMgr getInstance] setValue:[NSString stringWithFormat:@"%d", -1]
                                       forKey:[NSString stringWithFormat:@"contactListVersion"]
                                    forDomain:[NSString stringWithFormat:@"SyncServerInfo"]];
            
            NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:self.Mmodel.contactsData];
            
            for (int i = 0; i<arr.count; i++) {
                HB_ContactModel * model = arr[i];
                [HB_ContactDataTool contactAddPeopleWhileTimeMachineByModel:model];
//                if (i%2==0) {
//#pragma mark ****主线程
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        float progress = (i/arr.count)*(1-self.TimeMachineProgressView.progressView.progress);
//                        [self.TimeMachineProgressView.progressView setProgress:progress animated:YES];
//
//                    });
//#pragma mark ****************************
//                }
                
            }
            
            ABAddressBookRef book =[HB_ContactDataTool getAddressBook];
            
            
            if (ABAddressBookHasUnsavedChanges(book))
            {
                BOOL ret = ABAddressBookSave(book, NULL);
                
            }
#pragma mark ****主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self moveProgressTomax];
                

            });
#pragma mark ****************************

//
            
        });
        
        
    });
    
    
}


-(void)moveProgressTomax
{
    float progress = self.TimeMachineProgressView.progressView.progress;
    if (progress >= 1.0) {
        self.TimeMachineProgressView.precentlabel.text = [NSString stringWithFormat:@"100.00%%"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.TimeMachineProgressView dismiss];
            
            [self.view addSubview:[[[HB_timeMachineSucessView alloc] init] autorelease]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        });
        return;
    }
    [self.TimeMachineProgressView.progressView setProgress:(progress+0.0205) animated:YES];
    self.TimeMachineProgressView.precentlabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
    [self performSelector:@selector(moveProgressTomax) withObject:nil afterDelay:0.05];
}

-(void)moveProgress
{
    float progress =self.TimeMachineProgressView.progressView.progress;
    if (progress<0.3) {
        [self.TimeMachineProgressView.progressView setProgress:(progress + 0.02) animated:YES];
        self.TimeMachineProgressView.precentlabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];

    }
    else if(progress < 0.8)
    {
        [self.TimeMachineProgressView.progressView setProgress:(progress + 0.005) animated:YES];
        self.TimeMachineProgressView.precentlabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];

    }
    else if (progress < 0.95)
    {
        [self.TimeMachineProgressView.progressView setProgress:(progress + 0.001) animated:YES];
        self.TimeMachineProgressView.precentlabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
    }
    else
    {
        return ;
    }
    [self performSelector:@selector(moveProgress) withObject:nil afterDelay:0.05];
}

-(NSString* )AlertString
{
    return [NSString stringWithFormat:@"您将恢复到%@ 联系人%ld人状态。",[self timeFormatterWith:self.Mmodel.syncTime],self.Mmodel.contactsCount];
}

-(NSString * )timeFormatterWith:(NSInteger)timestanp
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timestanp];
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy/MM/dd  HH:MM:ss"];
    
    
    return [formatter stringFromDate:date];
}



@end
