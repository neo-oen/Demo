//
//  HB_MemberCenterVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/7.
//
//

#import "HB_MemberCenterVc.h"
#import "HB_httpRequestNew.h"
#import "HB_MemberModelCell.h"
#import "HB_MemberCenterHeadview.h"
#import "SettingInfo.h"
#import "memberWebViewCtr.h"
#import "PayInAppManager.h"
#import "HB_OrderInfoController.h"
#import "HBZSAppDelegate.h"

#import "HB_MemberOrderRecordCtr.h"
#import "PushManager.h"
#import "HB_TopActivityCell.h"
#import "HB_hotActivityVc.h"
#import "SDImageCache.h"
@interface HB_MemberCenterVc ()<UITableViewDelegate,UITableViewDataSource,memberModelCellDelegate,MemberCenterHearderDelegate,UIAlertViewDelegate,topActivityDelegate>
@property(nonatomic,retain)UITableView * tableView;

@property(nonatomic,retain)NSDictionary * MemberModelDic;

@property(nonatomic,retain)NSArray * SectionTitleArr;

@property(nonatomic,retain)NSMutableArray * hotActivitydataArr;

@property(nonatomic,retain)HB_MemberCenterHeadview * heardView;



@property(nonatomic,retain)MemberInfoResponse * memberinfo;
@end

@implementation HB_MemberCenterVc

-(void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
     self.SectionTitleArr = @[@"会员特权",@"热门活动"];
    [self setpNav];
    [self setupInterface];
    [self loadMemberInfo];
    [self initMemberModeldata];
    [self initHotActivitydata];

}

-(void)initHotActivitydata
{
    PushManager * manager = [PushManager shareManager];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.hotActivitydataArr = [NSMutableArray arrayWithArray:[manager getmemberHotActivityFormServer]];//请求数据
        
        for (SysMsg * msg in self.hotActivitydataArr) {
            if (msg.isTop == 1) {
                NSUInteger index = [self.hotActivitydataArr indexOfObject:msg];
                if (index != 0) {
                    [self.hotActivitydataArr removeObject:msg];
                    [self.hotActivitydataArr insertObject:msg atIndex:0];
                }
                break;
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //初始化控件
            
        });
        
    });
    
}
-(void)setpNav
{
    self.title = @"会员中心";
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 20);
    [btn setTitle:@"权益说明" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(navrigthClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rigthItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rigthItem;
    [rigthItem release];
}
-(void)loadMemberInfo
{
    self.memberinfo = [MemberInfoResponse parseFromData:[SettingInfo getMemberInfo]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hiddenTabBar];
    
    self.tableView.tableHeaderView = self.heardView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
-(HB_MemberCenterHeadview *)heardView
{
    if (!_heardView) {
         _heardView = [[[NSBundle mainBundle] loadNibNamed:@"HB_MemberCenterHeadview" owner:nil options:nil] firstObject];
        _heardView.frame = CGRectMake(0, 0, Device_Width, 552/3);
    }
    
    [_heardView setMemberViewDataWithMemberInfo:self.memberinfo];
    _heardView.delegate = self;
    return _heardView;
}

-(void)setupInterface{
    //tableView
    CGFloat tableView_W=Device_Width;
    CGFloat tableView_H=Device_Height-64;
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    self.tableView =[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
    [self.view addSubview:self.tableView];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heiht=0;
    switch (indexPath.section) {
        case 0:
        {
            heiht = 180;
        }
            break;
        case 1:
        {
            if (self.hotActivitydataArr.count>=1) {
                heiht = 126;
            }
            else
            {
                heiht = 66;
            }
        }
            break;
            
        default:
            break;
    }
    
    return heiht;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorFromHexString:@"999999"]];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.SectionTitleArr[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.SectionTitleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        HB_MemberModelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberModelCell"];
        if (!cell) {
            cell =[[HB_MemberModelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MemberModelCell"];
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell initdataWithDictionary:self.MemberModelDic];
        cell.delegate = self;
        return cell;
        
    }
    else if (indexPath.section == 1)
    {
        HB_TopActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"topActivityCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"HB_TopActivityCell" owner:self options:nil]lastObject];
        }
        
        SysMsg * msg = nil;
        if (self.hotActivitydataArr.count >=1) {
            msg = self.hotActivitydataArr.firstObject;
        }
        cell.delegate = self;
        [cell setdataWith:msg];
        
        return cell;
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        if(self.hotActivitydataArr.count >0)
        {
            HB_WebviewCtr * web = [[HB_WebviewCtr alloc] init];
            SysMsg * msg = self.hotActivitydataArr.firstObject;
            web.url = [NSURL URLWithString:msg.urlDetail];
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}

-(void)initMemberModeldata
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    [req getMemberModelResult:^(BOOL isSuccess, NSDictionary *dic) {
        if (!isSuccess) {
            NSLog(@"%@",@"失败");
            return ;
            
        }
        [[SDImageCache sharedImageCache] clearDisk];

        self.MemberModelDic = [[NSDictionary alloc] initWithDictionary:dic];
        [_tableView reloadData];
    }];
    [req release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)memberModelCell:(HB_MemberModelCell *)cell ClickModel:(HB_MemberModel *)model
{
    memberWebViewCtr * vc = [[memberWebViewCtr alloc] init];
    vc.url = [NSURL URLWithString:model.modulelink];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)memberHeaderView:(HB_MemberCenterHeadview *)headerView clickWithIndex:(NSInteger)index
{
    if (index == 0) {
        //下方会员订购按钮
         HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
        [req orderVipIsValidResult:^(BOOL isSuccess, NSDictionary *dic) {
            if (!isSuccess) {
                NSLog(@"orderVipIsValid请求失败");
                return ;
            }
            if ([[dic objectForKey:@"code"] integerValue] == 0) {
                //可以订购
                if (!self.memberinfo.isExperience && self.memberinfo.memberLevel == MemberLevelCommon) {
                    //免费体验
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"免费体验" message:@"您已成功获赠1个月的号簿助手VIP会员服务，本服务每个用户仅限1次，自开通之日起30天，详情前往会员中心查看。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"立即体验", nil];
                    [alert show];
                    [alert release];
                }
                else
                {
                    [HB_httpRequestNew buyMemberWithVc:self];
                }
            }
            else
            {
                //订购关闭
                HB_WebviewCtr * webvc = [HB_WebviewCtr new] ;
                webvc.url = [NSURL URLWithString:[dic objectForKey:@"tip_url"]];
                [self.navigationController pushViewController:webvc animated:YES];
                [webvc release];
                
            }
        }];
    }
    else if (index == 1)
    {
        //会员变更记录按钮
        HB_MemberOrderRecordCtr *vc = [[HB_MemberOrderRecordCtr alloc] init];
        GetConfigResponse * urls = [SettingInfo getConfigUrl];
        vc.url = [NSURL URLWithString:urls.memberLevelChangeUrl];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        [vc release];
    }
    

    
}
- (void)getServiceData:(NSNotification *)notification {
    
    NSLog(@"res_code: %@",[notification.object objectForKey:@"res_code"]);
    NSLog(@"res_message: %@",[notification.object objectForKey:@"res_message"]);
    NSLog(@"trade_id: %@",[notification.object objectForKey:@"trade_id"]);
    NSLog(@"%@",notification);
    
    NSDictionary * dic = notification.object;
    
    if ([[dic objectForKey:@"res_code"] integerValue] == 0&& [dic objectForKey:@"order_no"]) {
        
        [self orderMemberWithPayInfo:dic OrderType:MemberTypeBuy];
        
    }
    else
    {
        [HB_httpRequestNew PayBackInfo:[dic objectForKey:@"res_message"]];
    }
    
}

-(void)orderMemberWithPayInfo:(NSDictionary *)PayDic OrderType:(MemberType)type
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    
    HB_OrderMemberModel * model = [[HB_OrderMemberModel alloc] init];
    
    model.order_no= [PayDic objectForKey:@"order_no"];
    model.memberLevel = MemberLevelVip;
    model.memberType = type;
    if (type==MemberTypeBuy) {
        model.price = Open189_Price;
    }
    [req OrderMemberWithOrderInfo:model Result:^(BOOL isSuccess, MemberOrderResponse *MOResponse) {
        
        if (!isSuccess) {
            NSLog(@"请求失败");
            return ;
        }
        
        
        HB_OrderInfoController * vc = [[HB_OrderInfoController alloc] initWithNibName:nil bundle:nil];
        
        vc.model = MOResponse.memberOrder;
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        [self ReLoaddataAndfresh];
        
    }];
    
    
    [req release];
    [model release];

}

-(void)ReLoaddataAndfresh
{
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    [req getMemberInfoResult:^(BOOL isSuccess, MemberInfoResponse *memberInfo) {
      
        if (!isSuccess) {
            return ;
        }
        self.memberinfo = memberInfo;
        [self.heardView setMemberViewDataWithMemberInfo:self.memberinfo];
        [self.tableView reloadData];
        
    }];
    
    [req release];
}

#pragma mark TopActivitydelegate
-(void)TopActivityCell:(HB_TopActivityCell *)cell clickwithIndex:(NSInteger)index
{
    //跳转到活动页面
    HB_hotActivityVc * vc = [[HB_hotActivityVc alloc] init];
    vc.dataArr  = self.hotActivitydataArr;
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        
        
        
        [self orderMemberWithPayInfo:nil OrderType:MemberTypeFree];
    }
}

-(void)navrigthClick:(UIButton *)btn
{
    HB_WebviewCtr * vc = [[HB_WebviewCtr alloc] init];
    vc.titleName = @"会员权益说明";
    vc.url =  [NSURL URLWithString:hyqysmUrl];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
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
