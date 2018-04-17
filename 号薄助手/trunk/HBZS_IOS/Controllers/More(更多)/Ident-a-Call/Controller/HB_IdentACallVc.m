//
//  HB_IdentACallVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/12/7.
//
//

#import "HB_IdentACallVc.h"
#import "HB_SettingPushCell.h"
#import "HB_SettingPushCellModel.h"
#import "HB_SettingSwitchCell.h"
#import "HB_SettingSwitchCellModel.h"
#import "HB_IdentACall.h"
#import "SVProgressHUD.h"
#import "SyncProgressView.h"
#import "HB_packageDownloadModel.h"
#import "HB_PackageVersionModel.h"
#import "HB_identCallHelpVC.h"
@interface HB_IdentACallVc ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,HB_SettingSwitchCellDelegate>

/**
 *  主tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**  数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;

/**  带下在数据模型数组 */
@property(nonatomic,retain)NSMutableArray * downloadPackages;

/**  下载条*/
@property(nonatomic,retain)SyncProgressView * progress;

@end

@implementation HB_IdentACallVc

-(void)dealloc
{
    [_tableView release];
    [super dealloc];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataArr];
    [self setupInterface];
    [self setupNavigationBar];
//    [HB_IdentACall registerDhb];
}
//#pragma mark - 数据源
//-(NSMutableArray *)dataArr{
//    if (_dataArr==nil) {
//        _dataArr=[[NSMutableArray alloc]init];
//        [self initDataArr];
//    }
//    return _dataArr;
//}

-(void)viewWillAppear:(BOOL)animated
{
    [self hiddenTabBar];
    BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:hadShowedHeop];
    if (!isShowed) {
        [self pustTohelp];
    }
    else{
        [self checkCallExtensionStuts];
    }
}

-(void)initDataArr{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    
    HB_SettingPushCellModel * model1=[HB_SettingPushCellModel modelWithName:[NSString stringWithFormat:@"更新数据"] andViewController:nil];
   
    HB_SettingPushCellModel * model2=[HB_SettingPushCellModel modelWithName:[NSString stringWithFormat:@"导入数据"] andViewController:nil];
    HB_SettingPushCellModel * model3=[HB_SettingPushCellModel modelWithName:[NSString stringWithFormat:@"使用帮助"] andViewController:[HB_identCallHelpVC class]];
    [_dataArr addObjectsFromArray:@[model1,model2,model3]];
}



#pragma mark - 界面
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //标题
    self.title=@"陌生来电识别";
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
    UITableView * tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.rowHeight=50;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
    
    self.progress = [[SyncProgressView alloc] init];
}

#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_SettingCellModel * model=self.dataArr[indexPath.row];
    if ([model isKindOfClass:[HB_SettingPushCellModel class]]) {
        HB_SettingPushCell * cell=[HB_SettingPushCell cellWithTableView:tableView];
        cell.model=(HB_SettingPushCellModel *)model;
        
        return cell;
    }else if ([model isKindOfClass:[HB_SettingSwitchCellModel class]]){
        HB_SettingSwitchCell * cell=[HB_SettingSwitchCell cellWithTableView:tableView];
        cell.model=(HB_SettingSwitchCellModel *)model;
        cell.delegate=self;
        return cell;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj=self.dataArr[indexPath.row];
    if ([obj isKindOfClass:[HB_SettingPushCellModel class]]) {
        if (indexPath.row==0) {
            [self updateData];
            return;
        }
        else if (indexPath.row == 1)
        {
            [self reloadExtension];
            return;
        }
        else if (indexPath.row == 2)
        {
            [self pustTohelp];
        }
        else
        {
            HB_SettingPushCellModel * model=(HB_SettingPushCellModel *)obj;
            UIViewController * vc=[[model.viewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }

    }
}

-(void)pustTohelp
{
    HB_identCallHelpVC * vc=[[HB_identCallHelpVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
#pragma mark - switch的代理方法
-(void)settingSwitchCell:(HB_SettingSwitchCell *)cell switchValueChanged:(UISwitch *)switcher{
    
}

-(void)reloadExtension{
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:extensionIdentf completionHandler:^(CXCallDirectoryEnabledStatus status,NSError *error)
     {
         if(status==CXCallDirectoryEnabledStatusEnabled){
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
             [SVProgressHUD showWithStatus:@"导入中.."];
             NSLog(@"CX Call Directory Manager 导入中");
             [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:extensionIdentf completionHandler:^(NSError *error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (error==CXErrorCodeCallDirectoryManagerErrorUnknown) {
                          
                          [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                          [SVProgressHUD showSuccessWithStatus:@"导入成功"];
                          NSLog(@"CX Call Directory Manager 导入成功");
                      }
                      else {
                          [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                          [SVProgressHUD showErrorWithStatus:@"导入出错,可以稍后手动点击导入"];
                          NSLog(@"CX Call Directory Manager 导入出错 %@",[error description]);
                      }
                  });
                 
              }];
         } else {
             [self allowCallExtensionAlert];
             NSLog(@"CX Call Directory Manager 导入失败 未开启来电识别");
         }
     }];
}

-(void)updateData
{
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:extensionIdentf completionHandler:^(CXCallDirectoryEnabledStatus status,NSError *error)
     {
         if(status==CXCallDirectoryEnabledStatusEnabled){
             NSLog(@"已授权，准备开始下载");
             [self downloadAction];
             
         }
         else {
             
             [self allowCallExtensionAlert];
             NSLog(@"CX Call Directory Manager 导入失败 未开启来电识别");
         }
     }];
}

-(void)checkCallExtensionStuts
{
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:extensionIdentf completionHandler:^(CXCallDirectoryEnabledStatus status,NSError *error)
     {
         if(status==CXCallDirectoryEnabledStatusEnabled){
             
         }
         else {
             
             [self allowCallExtensionAlert];
             NSLog(@"CX Call Directory Manager 导入失败 未开启来电识别");
         }
     }];
}

-(void)downloadAction{
    
    [[DHBSDKApiManager shareManager] setDownloadNetworkType:DHBSDKDownloadNetworkTypeAllAllow];
    [DHBSDKApiManager dataInfoFetcherMultiCompletionHandler:^(NSMutableArray<DHBSDKUpdateItem *> *updateItems, NSError *error) {
        /*
         记得修改要下载的数据类型
         DHBDownloadPackageTypeDelta,
         DHBDownloadPackageTypeFull
         */
        
        //                                      updateItem.fullMD5 = @"a19a05255a33b5384641e9dd740524be";
        //                                      updateItem.fullDownloadPath = @"http://s3.dianhua.cn/chk/flag/1_mtyF_flag_86_61.zip";
        //                                      updateItem.fullSize = 2698755;
        //                                      updateItem.fullVersion = 61;
        
        NSInteger Downloadtotalsize = [self getAllPackageSizeWiht:updateItems];
        
        if (Downloadtotalsize<=0) {
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有需要更新的数据包" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [al release];
            return;
        }
        
        NSString * sizestring = [NSByteCountFormatter stringFromByteCount:Downloadtotalsize countStyle:NSByteCountFormatterCountStyleFile];
        NSString * content = [NSString stringWithFormat:@"有可用更新包:%@",sizestring];
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"下载更新", nil];
        [al show];
        [al release];
        
    }];
}

-(void)beginDownWith:(NSMutableArray<HB_packageDownloadModel *> *)downloadModels
{
    [self.progress setProTitleWithString:@"已完成"];
    [self.progress show];
    [self.progress setProgressMin];
    
    dispatch_queue_t q = dispatch_queue_create("com.yulore.yellowpage.download", 0);
    dispatch_async(q, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        __block double downCount = downloadModels.count;
        __block double i = 0;
        
        for (HB_packageDownloadModel * model in downloadModels) {
            
            double x = i/downCount;
            double y = 1/downCount;
            [DHBSDKApiManager downloadDataWithUpdateItem:model.item dataType:model.downLoadType progressBlock:^(double progress) {
                NSLog(@"进度:%f",progress);
                if ([NSThread isMainThread]) {
                    [self.progress setSyncProgress:x + (y *progress) animated:YES];
                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.progress setSyncProgress:x + (y *progress) animated:YES];
                        NSLog(@"---------");
                    });
                    
                   
                }
                
            } completionHandler:^(NSError *error) {
                NSLog(@"完成 error:%@",error);
                HB_PackageVersionModel * PVmodel = [[HB_PackageVersionModel alloc] init];
                PVmodel.deltaVersion = model.item.deltaVersion;
                PVmodel.fullVersion = model.item.fullVersion;
                
                [dic setObject:PVmodel forKey:[self packageTypeToString:model.item.packageType]];
                
                [PVmodel release];
                dispatch_semaphore_signal(semaphore);
                i++;
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        }
        
        NSLog(@"下载最终完成");
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.progress setSyncProgress:1.0 animated:YES];
           
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.progress dismiss];
            [self reloadExtension];
        });
        [self saveVersionInfo:dic];
        
        
    });
    
}



-(NSInteger)getAllPackageSizeWiht:(NSMutableArray<DHBSDKUpdateItem *> *)updateItems
{
    NSInteger packagesize = 0;
    
    NSDictionary * localVersionInfo = [self getVersionInfo];
    self.downloadPackages = [NSMutableArray arrayWithCapacity:0];
    
    for (DHBSDKUpdateItem * item in updateItems) {
        HB_packageDownloadModel * downloadmodel = [[HB_packageDownloadModel alloc] init];
        downloadmodel.item = item;
        
        HB_PackageVersionModel * model = [localVersionInfo objectForKey:[self packageTypeToString:item.packageType]];
        if (!model) {
            downloadmodel.downLoadType = DHBDownloadPackageTypeFull;
            packagesize += item.fullSize;
        }
        else if (item.deltaVersion == model.deltaVersion &&item.deltaVersion>0)
        {
            downloadmodel.downLoadType = DHBDownloadPackageTypeNoNeed;
        }
        else if (item.fullVersion == model.fullVersion &&item.fullVersion>0)
        {
            downloadmodel.downLoadType = DHBDownloadPackageTypeNoNeed;
        }
        else if (item.deltaSize)
        {
            downloadmodel.downLoadType = DHBDownloadPackageTypeDelta;
            packagesize += item.deltaSize;
        }
        else if (item.fullSize)
        {
            downloadmodel.downLoadType = DHBDownloadPackageTypeFull;
            packagesize +=item.fullSize;
        }
        
        [self.downloadPackages addObject:downloadmodel];
        [downloadmodel release];
    }
    
    return packagesize;
}
-(NSMutableDictionary *)getVersionInfo
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPackageInfo"];
    
    NSMutableDictionary * localversion = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return localversion;
}
-(void)saveVersionInfo:(NSDictionary *)newVersion
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:newVersion];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"localPackageInfo"];
}
-(void)allowCallExtensionAlert
{
    dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到\"设置-电话-来电阻止与身份识别\"中开启号簿助手" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [al show];
    [al release];
    });
}


-(NSString *)packageTypeToString:(DHBSDKPackageType)type
{
    NSString * str = nil;
    switch (type) {
        case DHBSDKPackageTypeUndefined:
        {
            str = [NSString stringWithFormat:@"DHBSDKPackageTypeUndefined"];
        }
            break;
            
        case DHBSDKPackageTypeFlag:
        {
            str = [NSString stringWithFormat:@"DHBSDKPackageTypeFlag"];
        }
            break;
        case DHBSDKPackageTypeBkwd:
        {
            str = [NSString stringWithFormat:@"DHBSDKPackageTypeBkwd"];
        }
            break;
        default:
            break;
    }
    return str;
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex== 1) {
        [self beginDownWith:self.downloadPackages];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
