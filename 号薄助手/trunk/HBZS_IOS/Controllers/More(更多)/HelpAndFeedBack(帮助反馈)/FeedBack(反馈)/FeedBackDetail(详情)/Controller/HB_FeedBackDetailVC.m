//
//  HB_FeedBackDetailVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/6.
//
//

#import "HB_FeedBackDetailVC.h"
#import "HB_FeedBackDetailFooterView.h"
#import "HB_FeedBackDetailCell.h"
#import "HB_FeedBackDetailFrameModel.h"
#import "HB_FeedBackDetailStore.h"

/**
 满意度评价按钮tag值
 */
typedef enum {
    KEvaluateBtnTypeVeryGood = 100,//非常满意
    KEvaluateBtnTypeGoog ,//满意
    KEvaluateBtnTypeNormal ,//一般
    KEvaluateBtnTypeShit//不满意
}EvaluateBtnType;

@interface HB_FeedBackDetailVC () < HB_FeedBackDetailStoreDelegate,
                                    UITableViewDataSource,
                                    UITableViewDelegate
                                    >
/**  列表 */
@property(nonatomic,retain)UITableView *tableView;
/**  数据源数组 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**  分组footerView */
@property(nonatomic,retain)HB_FeedBackDetailFooterView *footerView;
/**  数据仓库 */
@property(nonatomic,retain)HB_FeedBackDetailStore *store;
/**  键盘最终的frame */
@property(nonatomic,assign)CGRect keyboardEndFrame;
/**  右侧‘完成’barButtonItem */
@property(nonatomic,retain)UIBarButtonItem *finishBarButtonItem;
/**  右侧‘完成’button */
@property(nonatomic,retain)UIButton *finishBtn;

@end

@implementation HB_FeedBackDetailVC
#pragma mark - life cycle
-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    [_footerView release];
    [_store release];
    [_finishBarButtonItem release];
    //移出监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"意见反馈";
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem=self.finishBarButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //发送网络请求
    [self.store sendRequestAndResumeTask];
}
#pragma mark - event response 
/**
 *  键盘frame改变
 */
-(void)keyboardFrameChanged:(NSNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
    self.keyboardEndFrame=[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame=[userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //根据键盘的高度来改变tableView的frame
    CGRect frame = self.tableView.frame;
    self.tableView.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.keyboardEndFrame.origin.y - frame.origin.y -64 );
    //键盘弹出的时候，使tableView滚动到最底部
    if (keyboardBeginFrame.origin.y > self.keyboardEndFrame.origin.y) {
        //tableView滚动到最底部
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //针对4s的3.5寸屏幕做计算;如果弹出以后输入框被导航条遮挡，则需要向下滚动一部分（40px）
        if (SCREEN_HEIGHT <= 480) {
            CGPoint contentOffset = self.tableView.contentOffset;
            self.tableView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y -40);
        }
    }
}
-(void)finishBtnClick:(UIButton*)btn{
    if (self.footerView.textViewIsNull) {
        NSLog(@"没有输入值");
    }
}
#pragma mark - scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger numberOfTouches = scrollView.panGestureRecognizer.numberOfTouches;
    if (numberOfTouches > 0) {
        //是手指引起的滚动
        CGPoint touchPoint = [scrollView.panGestureRecognizer locationInView:self.view];
        if (touchPoint.y >= self.keyboardEndFrame.origin.y-64) {
            CGRect frame = self.tableView.frame;
            self.tableView.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, touchPoint.y);
        }
    }
}
#pragma mark - TableView Delegate
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataArr.count) {
        return self.footerView;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.footerView.bounds.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_FeedBackDetailFrameModel *frameModel = self.dataArr[indexPath.row];
    return frameModel.cellHight;
}
#pragma mark - TableView datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_FeedBackDetailCell *cell=[HB_FeedBackDetailCell cellWithTableView:tableView];
    cell.frameModel=self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
#pragma mark - HB_FeedBackDetailDelegate
-(void)feedBackDetailStore:(HB_FeedBackDetailStore *)store didFinishReceiveData:(NSArray *)frameModelArr{
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:frameModelArr];
    [self.tableView reloadData];
}
#pragma mark - setter and getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:({
            CGFloat tableView_W=SCREEN_WIDTH;
            CGFloat tableView_H=SCREEN_HEIGHT-64;
            CGFloat tableView_X=0;
            CGFloat tableView_Y=0;
            CGRect frame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
            frame;
        }) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeInteractive;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(HB_FeedBackDetailStore *)store{
    if (!_store) {
        _store=[[HB_FeedBackDetailStore alloc]init];
        _store.delegate=self;
    }
    return _store;
}
-(HB_FeedBackDetailFooterView *)footerView{
    if (!_footerView) {
        _footerView=[[HB_FeedBackDetailFooterView alloc]init];
        _footerView.backgroundColor=[UIColor whiteColor];
        _footerView.bounds=CGRectMake(0, 0, SCREEN_WIDTH, 350);
    }
    return _footerView;
}
-(CGRect)keyboardEndFrame{
    if (CGRectEqualToRect(_keyboardEndFrame, CGRectZero)) {
        _keyboardEndFrame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }
    return _keyboardEndFrame;
}
-(UIBarButtonItem *)finishBarButtonItem{
    if (!_finishBarButtonItem) {
        _finishBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.finishBtn];
    }
    return _finishBarButtonItem;
}
-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.bounds=CGRectMake(0, 0, 30, 44);
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}
@end
