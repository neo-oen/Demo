//
//  HB_GroupSelectView.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/29.
//
//

#define PADDING 7 //间距

/**
 ‘全部联系人’‘未分组’‘管理分组’对应的groupID（自己构造的）
 */
typedef enum {
    KSelectViewAllContactGroupID = -100 , //‘全部联系人’对应的groupID（自己构造的）
    KSelectViewNoGroupID = -101 , //‘未分组’对应的groupID（自己构造的）
    KSelectViewGroupManageGroupID = -102 //‘管理分组’对应的groupID（自己构造的）
}KSelectViewCustomerGroupIDType;

#import "HB_GroupSelectView.h"
#import "GroupData.h"
#import "HB_GroupNameCell.h"

@interface HB_GroupSelectView ()<UITableViewDataSource,UITableViewDelegate>

/** tableView的背景图*/
@property(nonatomic,retain)UIImageView *bgImageView;
/** tableView */
@property(nonatomic,retain)UITableView *tableView;
/** 数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;

@end

@implementation HB_GroupSelectView

#pragma mark - life cycle
-(void)dealloc{
    [_bgImageView release];
    [_dataArr release];
    [_tableView release];
    [super dealloc];
}
-(instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        //1.添加背景图
        [self addSubview:self.bgImageView];
        //2.添加tableView
        [self.bgImageView addSubview:self.tableView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //初始化数据源
    [self initDataArr];
    //1.背景图的frame
    self.bgImageView.frame=self.bounds;
    //2.tableView的frame
    CGFloat tableView_W=self.bgImageView.bounds.size.width - PADDING ;
    CGFloat tableView_H=self.bgImageView.bounds.size.height - 2 * PADDING -_tableView.rowHeight;
    CGFloat tableView_X=PADDING * 0.5;
    CGFloat tableView_Y=PADDING;
    self.tableView.frame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    
    UIButton * groupManageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    groupManageButton.frame=CGRectMake(PADDING/2+1,tableView_H+PADDING+3, tableView_W-1, _tableView.rowHeight);
    groupManageButton.backgroundColor = [UIColor black50PercentColor];
    [groupManageButton setTitle:@"管理分组" forState:UIControlStateNormal];
    groupManageButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    groupManageButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [groupManageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [groupManageButton addTarget:self action:@selector(groupManagerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImageView addSubview:groupManageButton];
    
    
}
#pragma mark - private methods
/**
 *  初始化数据源
 */
-(void)initDataArr{
    [self.dataArr removeAllObjects];
    //1.添加‘全部联系人’----构造一个groupModel模型
    HB_GroupModel * allContactItem=[[HB_GroupModel alloc]init];
    allContactItem.groupName=@"全部联系人";
    allContactItem.groupID= KSelectViewAllContactGroupID;
    [self.dataArr addObject:allContactItem];
    [allContactItem release];
    //2.添加具体每一个分组名称
    NSArray *dictArr=[GroupData getAllGroupIDAndGroupNameArray];
    for (int i=0; i<dictArr.count; i++) {
        HB_GroupModel * groupItem=[[HB_GroupModel alloc]init];
        [groupItem setValuesForKeysWithDictionary:dictArr[i]];
        [self.dataArr addObject:groupItem];
        [groupItem release];
    }
    //3.添加‘未分组’----构造一个groupModel模型
    HB_GroupModel * noGroupContactItem=[[HB_GroupModel alloc]init];
    noGroupContactItem.groupName=@"未分组";
    noGroupContactItem.groupID= KSelectViewNoGroupID;
    [self.dataArr addObject:noGroupContactItem];
    [noGroupContactItem release];
    
}
#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HB_GroupModel *groupItem = self.dataArr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(groupSelectView:didSelectGroupModel:)]) {
        [self.delegate groupSelectView:self didSelectGroupModel:groupItem];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_GroupNameCell * cell=[HB_GroupNameCell cellWithTableView:tableView];
    HB_GroupModel * model=self.dataArr[indexPath.row];
    cell.groupItem=model;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
#pragma mark - setter and getter
/**
 *  背景图片
 */
-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView=[[UIImageView alloc ]init];
        _bgImageView.layer.masksToBounds=YES;
        _bgImageView.layer.cornerRadius=5;
        _bgImageView.clipsToBounds=YES;
        _bgImageView.backgroundColor=[UIColor clearColor];
        _bgImageView.userInteractionEnabled=YES;
        UIImage * image=[UIImage resizedImageWithName:@"下拉框4"];
        _bgImageView.image=image;
    }
    return _bgImageView;
}
/**
 *  列表
 */
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight=44;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.bounces=YES;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
/**
 *  数据源
 */
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr =[[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(void)groupManagerClick:(UIButton *)sender
{
    //4.添加‘管理分组’----构造一个groupModel模型
    HB_GroupModel * manageGroupItem=[[HB_GroupModel alloc]init];
    manageGroupItem.groupName=@"管理分组";
    manageGroupItem.groupID= KSelectViewGroupManageGroupID;
    
    if ([self.delegate respondsToSelector:@selector(groupSelectView:didSelectGroupModel:)]) {
        [self.delegate groupSelectView:self didSelectGroupModel:manageGroupItem];
    }
    [manageGroupItem release];
}

@end
