//
//  HB_hotActivityVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/20.
//
//

#import "HB_hotActivityVc.h"
#import "HB_HotActivityCell.h"
#import "HB_WebviewCtr.h"
@interface HB_hotActivityVc ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HB_hotActivityVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"热门活动";
    [self stepInterface];
}
-(void)dealloc
{
    [_tableView release];
    [super dealloc];
}

-(void)stepInterface
{
    //tableView
    CGFloat tableView_W=Device_Width;
    CGFloat tableView_H=Device_Height-64;
    CGFloat tableView_X=0;
    CGFloat tableView_Y=0;
    CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    self.tableView =[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HB_HotActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HotActivityCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HB_HotActivityCell" owner:nil options:nil] lastObject];;
    }
    [cell setdata:self.dataArr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HB_WebviewCtr * vc = [[HB_WebviewCtr alloc] init];
    SysMsg * msg = [self.dataArr objectAtIndex:indexPath.row];
    vc.url = [NSURL URLWithString:msg.urlDetail];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


#pragma mark tableView delegate And dataSource

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
