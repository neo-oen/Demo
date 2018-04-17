//
//  HB_CardCollectionCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/5/16.
//
//

#import "HB_CardCollectionCell.h"


@implementation HB_CardCollectionCell


-(void)dealloc
{
    [_contactModel release];
    [_store release];
    [_headerIconView release];
    [_tableView release];
    [_CardNamelabel release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.tableView];
    }
    return self;
}

-(UILabel *)CardNamelabel
{
    if (!_CardNamelabel) {
        _CardNamelabel = [[UILabel alloc] init];

        _CardNamelabel.frame = CGRectMake(20, 64+15, 120, 20);
        _CardNamelabel.font = [UIFont boldSystemFontOfSize:18];
        _CardNamelabel.textColor = [UIColor whiteColor];
        
    }
    return _CardNamelabel;
}

-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat tableView_W=SCREEN_WIDTH;
        CGFloat tableView_H=SCREEN_HEIGHT;
        CGFloat tableView_X=0;
        CGFloat tableView_Y=0;
        CGRect tableViewFrame=CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
        _tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeInteractive;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=COLOR_I;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight=60;
        _tableView.contentInset = UIEdgeInsetsMake(ICON_Height, 0, 0, 0);
//        _tableView.tableFooterView = self.callHistoryBtn;
        //隐藏headerView
        UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
        _tableView.tableHeaderView=headerView;
        [headerView release];
        //头像
        [_tableView addSubview:self.headerIconView];
        
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.store.dataArr[indexPath.section][indexPath.row];
    if ([model isKindOfClass:[HB_ContactInfoCellModel class]]) {
        //1.如果是普通的模型
        HB_ContactInfoCell * cell = [HB_ContactInfoCell cellWithTableView:tableView];
        cell.model=(HB_ContactInfoCellModel *)model;
        return cell;
    }else if ([model isKindOfClass:[HB_ContactInfoPhoneCellModel class]]){
        //2.如果是“电话号码”模型
        HB_ContactInfoPhoneCell * cell=[HB_ContactInfoPhoneCell cellWithTableView:tableView];
        NSLog(@"%ld",indexPath.section);
        cell.model=(HB_ContactInfoPhoneCellModel *)model;
        cell.delegate=self;
        return cell;
    }else if ([model isKindOfClass:[HB_ContactInfoEmailCellModel class]]){
        //3.如果是“邮箱”模型
        HB_ContactInfoEmailCell * cell=[HB_ContactInfoEmailCell cellWithTableView:tableView];
        cell.model=(HB_ContactInfoEmailCellModel *)model;
        cell.delegate=self;
        return cell;
    }else if ([model isKindOfClass:[HB_ContactInfoCallHistoryCellModel class]]){
        //4.如果是“通话记录”模型
        HB_ContactInfoCallHistoryCell * cell=[HB_ContactInfoCallHistoryCell cellWithTableView:tableView];
        cell.model=(HB_ContactInfoCallHistoryCellModel *)model;
        return cell;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.store.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.store.dataArr[section] count];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * view=[[UIView alloc]init];
//    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
//    if (section==1 || section==2) {
//        UILabel * label=[[[UILabel alloc]init]autorelease];
//        label.backgroundColor=COLOR_H;
//        label.frame=CGRectMake(15, -0.5, 15+20, 0.5);
//        [view addSubview:label];
//    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1 || section==2) {
        return 0.5;
    }
    return 0.0000000001;
}


-(UIButton *)callHistoryBtn{
    if (!_callHistoryBtn) {
        _callHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _callHistoryBtn.frame=CGRectMake(0, 0, SCREEN_WIDTH, 60);
        [_callHistoryBtn setTitleColor:COLOR_A forState:UIControlStateNormal];
        _callHistoryBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_callHistoryBtn setTitle:@"查看通话记录" forState:UIControlStateNormal];
        [_callHistoryBtn setTitle:@"收起通话记录" forState:UIControlStateSelected];
        [_callHistoryBtn addTarget:self
                            action:@selector(callHistoryBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _callHistoryBtn;
}
-(HB_HeaderIconView *)headerIconView{
    if (!_headerIconView) {
        CGRect frame = CGRectMake(0, -ICON_Height, SCREEN_WIDTH, ICON_Height);
        _headerIconView = [[HB_HeaderIconView alloc]initWithFrame:frame];
        _headerIconView.delegate = self;
        _headerIconView.editIconBtn.hidden = YES;
        
        [_headerIconView addSubview:self.CardNamelabel];
    }
    return _headerIconView;
}

-(HB_ContactInfoStore *)store{
    if (!_store) {
        _store = [[HB_ContactInfoStore alloc]init];
        _store.contactModel = self.contactModel;
    }
    return _store;
}

-(void)setContactModel:(HB_ContactModel *)contactModel
{
    if (_contactModel != contactModel) {
        [_contactModel release];
        _contactModel=[contactModel retain];
    }
    
    
    self.store.contactModel = contactModel;
    self.headerIconView.contactModel= contactModel;
    
    self.CardNamelabel.text = contactModel.cardName;
    
    [self.tableView reloadData];
}


-(void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex = cellIndex;
    self.headerIconView.bgimageindex = cellIndex;
    
    [self dealWithCardName];
}
-(void)dealWithCardName
{
    NSArray * arr = @[@"一",@"二",@"三",@"四",@"五"];
    
    NSString * string ;
    if (self.contactModel.cardName.length) {
        string = [NSString stringWithFormat:@"%@",self.contactModel.cardName];
    }
    else
    {
        string = [NSString stringWithFormat:@"名片%@",[arr objectAtIndex:self.cellIndex]];
    }
    self.CardNamelabel.text = string;
}

#pragma mark - HB_ContactInfoPhoneCellDelegate
/**
 *  拨打电话
 */
-(void)contactInfoPhoneCellDidPhoneCall:(HB_ContactInfoPhoneCell *)phoneCell{
    //全局的拨号的方法
//    [self dialPhone:phoneCell.model.phoneModel.phoneNum contactID:self.contactModel.contactID.integerValue Called:nil];
    if ([self.delegate respondsToSelector:@selector(CardCollectionCell:contactType:NumOrAdress:)]) {
        [self.delegate CardCollectionCell:self contactType:card_collectionCell_Call NumOrAdress:phoneCell.model.phoneModel.phoneNum];
    }
}
/**
 *  发送短信
 */
-(void)contactInfoPhoneCellDidSendMessage:(HB_ContactInfoPhoneCell *)phoneCell{
    //全局的发送短信的方法
//    [self doSendMessage:@[phoneCell.model.phoneModel.phoneNum]];
    if ([self.delegate respondsToSelector:@selector(CardCollectionCell:contactType:NumOrAdress:)]) {
        [self.delegate CardCollectionCell:self contactType:card_collectionCell_Message NumOrAdress:phoneCell.model.phoneModel.phoneNum];
    }
}
#pragma mark - HB_ContactInfoEmailCellDelegate
/**
 *  发送邮件
 */
-(void)contactInfoEmailCellDidSendEmail:(HB_ContactInfoEmailCell *)emailCell{
    //全局发送邮件的方法
//    [self sendEmailWithEmailArr:@[emailCell.model.emailModel.emailAddress]];
    if ([self.delegate respondsToSelector:@selector(CardCollectionCell:contactType:NumOrAdress:)]) {
        [self.delegate CardCollectionCell:self contactType:card_collectionCell_Email NumOrAdress:emailCell.model.emailModel.emailAddress];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate CardCollectionCellDidScroll:scrollView];
}

@end
