//
//  HB_MemberOrderRecordCtr.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/18.
//
//

#import "HB_MemberOrderRecordCtr.h"

@interface HB_MemberOrderRecordCtr ()

@end

@implementation HB_MemberOrderRecordCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)loadWeb
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *cookie = [NSString stringWithFormat:@"Token=%@;UserID=%lld",[user objectForKey:@"Authtoken"] ,[[user objectForKey:@"userID"] longLongValue]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];

    [self.webView loadRequest:request];
    
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
