//
//  HB_BackupMoreView.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/13.
//
//
#define Padding 12 //间隙
#import "HB_BackupMoreView.h"
#import "HB_ContactInfoMoreViewCell.h"

@interface HB_BackupMoreView ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  tableView
 */
@property(nonatomic,retain)UITableView * tableView;
/**
 *  数据源
 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**
 *  背景图片
 */
@property(nonatomic,retain)UIImageView *bgImageView;

@end

@implementation HB_BackupMoreView

-(void)dealloc{
    [_tableView release];
    [_dataArr release];
    [_bgImageView release];
    [super dealloc];
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self setupInterface];
    }
    return self;
}
/**
 *  创建界面
 */
-(void)setupInterface{
    //1.背景图片
    _bgImageView=[[UIImageView alloc]init];
    _bgImageView.userInteractionEnabled=YES;
    _bgImageView.image=[UIImage resizedImageWithName:@"下拉框1"];
    [self addSubview:_bgImageView];
    //2.tableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=50;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_bgImageView addSubview:_tableView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //1.背景图
    _bgImageView.frame=self.bounds;
    //2.tableview
    CGFloat tableView_W=_bgImageView.bounds.size.width - Padding;
    CGFloat tableView_H=_bgImageView.bounds.size.height-Padding-6;
    CGFloat tableView_X=Padding * 0.5;
    CGFloat tableView_Y=Padding ;
    _tableView.frame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
}

#pragma mark - 数据源方法
-(NSMutableArray *)dataArr{
    if (_dataArr ==nil) {
        _dataArr=[[NSMutableArray alloc]init];
        [self initDataArrWithArr:@[@"备份日志",@"设置",@"无限时光机"]];
    }
    return _dataArr;
}
/**
 *  初始化数据源
 */
-(void)initDataArrWithArr:(NSArray *)arr{
    [_dataArr removeAllObjects];
    [_dataArr addObjectsFromArray:arr];
}
#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_ContactInfoMoreViewCell * cell=[HB_ContactInfoMoreViewCell cellWithTableView:tableView];
    cell.nameLabel.text=self.dataArr[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(backupMoreView:WithIndexPath:)]) {
            [self.delegate backupMoreView:self WithIndexPath:indexPath];
    }
    
}

@end
