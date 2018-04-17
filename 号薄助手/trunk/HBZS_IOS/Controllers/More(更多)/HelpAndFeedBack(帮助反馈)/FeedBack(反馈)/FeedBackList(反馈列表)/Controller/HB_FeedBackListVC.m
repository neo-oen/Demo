//
//  HB_FeedBackListVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/5.
//
//

#import "HB_FeedBackListVC.h"
#import "HB_FeedBackCell.h"
#import "HB_FeedBackInfoModel.h"
#import "HB_FeedBackInfoStroe.h"
#import "HB_NewFeedBackVC.h"
#import "HB_FeedBackDetailVC.h"

@interface HB_FeedBackListVC ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  列表
 */
@property(nonatomic,retain)UITableView *tableView;
/**
 *  数据源
 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**
 *  无数据时候的提示文字
 */
@property(nonatomic,retain)UILabel *alertLabel;
/**
 *  导航栏右侧的反馈item
 */
@property(nonatomic,retain)UIBarButtonItem *feedBackItem;
/**
 *  导航栏右侧的反馈按钮引用
 */
@property(nonatomic,retain)UIButton *feedBackBtn;


@end

@implementation HB_FeedBackListVC

#pragma mark - life cycle
-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    [_feedBackItem release];
    [_alertLabel release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.alertLabel];
    self.navigationItem.rightBarButtonItem=self.feedBackItem;
}

#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_FeedBackDetailVC *detailVC=[[HB_FeedBackDetailVC alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}
#pragma mark - tableView datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_FeedBackCell * cell=[HB_FeedBackCell cellWithTableView:tableView];
    cell.model=self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.alertLabel.hidden = self.dataArr.count;//控制提示语是否隐藏
    return self.dataArr.count;
}
#pragma mark - event response
-(void)feedBackBtnClick:(UIButton *)btn{
    HB_NewFeedBackVC * vc=[[HB_NewFeedBackVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
#pragma mark - setter and getter
-(UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight=60;
    }
    return _tableView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
        [_dataArr addObjectsFromArray:[HB_FeedBackInfoStroe feedBackInfoStoreModelArr]];
    }
    return _dataArr;
}
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel=[[UILabel alloc]init];
        _alertLabel.frame=CGRectMake(0, 100, SCREEN_WIDTH, 60);
        _alertLabel.textAlignment=NSTextAlignmentCenter;
        _alertLabel.font=[UIFont systemFontOfSize:14];
        _alertLabel.textColor=COLOR_F;
        _alertLabel.hidden=YES;
        _alertLabel.text=@"点击右上角的按钮来反馈意见";
    }
    return _alertLabel;
}
-(UIBarButtonItem *)feedBackItem{
    if (!_feedBackItem) {
        _feedBackItem=[[UIBarButtonItem alloc]initWithCustomView:self.feedBackBtn];
    }
    return _feedBackItem;
}
-(UIButton *)feedBackBtn{
    if (!_feedBackBtn) {
        _feedBackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_feedBackBtn addTarget:self action:@selector(feedBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _feedBackBtn.bounds=CGRectMake(0, 0, 30, 44);
        [_feedBackBtn setTitle:@"反馈" forState:UIControlStateNormal];
        [_feedBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _feedBackBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    }
    return _feedBackBtn;
}

@end
