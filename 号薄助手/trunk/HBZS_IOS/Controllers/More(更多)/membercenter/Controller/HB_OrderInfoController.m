//
//  HB_OrderInfoController.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/14.
//
//

#import "HB_OrderInfoController.h"
#import "GetMemberInfoProto.pb.h"
#import "HBZSAppDelegate.h"
#import "HB_WebviewCtr.h"
@interface HB_OrderInfoController ()

@end

@implementation HB_OrderInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title= @"成功开通号簿助手VIP会员";
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setData];
}
-(void)setData
{
    self.startTimeLabel.text = [self startTime];
    self.priceLabel.text = [self price];
    self.OrderType.text  = [self memberType];
    self.memberLevelLabel.text = [self memberlevel];
    self.cycleLabel.text = [self getcycle];
    
}

-(NSString *)getcycle
{
    NSString * str = nil;
    
    if (self.model.period == MemberPeriodOnemonth) {
        str = [NSString stringWithFormat:@"一个月"];
    }
    else if (self.model.period == MemberPeriodMonthly)
    {
        str = [NSString stringWithFormat:@"包月"];
    }
    return str;
}

-(NSString *)memberType
{
    NSString * str = nil;
    if (self.model.type == MemberTypeFree) {
        str = [NSString stringWithFormat:@"免费体验"];
    }
    else if(self.model.type == MemberTypeBuy)
    {
        str = [NSString stringWithFormat:@"购买"];
    }
    return str;
}


-(NSString *)memberlevel
{
    NSString * str = nil;
    if (self.model.mlevel == MemberLevelVip)
    {
        str = [NSString stringWithFormat:@"VIP会员"];
    
    }
    else if(self.model.mlevel == MemberLevelCommon)
    {
        str = [NSString stringWithFormat:@"普通会员"];
    }
    return str;
}

-(NSString *)startTime
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.model.starttime/1000];
    NSString * dateString = [formatter stringFromDate:date];
    
    return dateString;
    
}
-(NSString *)price
{
    NSString * priceString;
    if (self.model.price>0) {
        priceString = [NSString stringWithFormat:@"%.2f",self.model.price];
        
    }
    else
    {
        priceString = [NSString stringWithFormat:@"%@",@"免费"];
    }
    return priceString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(id)sender {
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

- (void)dealloc {
    [_startTimeLabel release];
    [_startTimeLabel release];
    [_OrderType release];
    [_cycleLabel release];
    [_memberLevelLabel release];
    [_priceLabel release];
    [super dealloc];
}
@end
