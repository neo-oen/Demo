//
//  newNetMsgVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/11/13.
//

#import "newNetMsgVc.h"
#import "UIButton+HB_fqBtnset.h"
#import "HB_netMsgReciModel.h"
#import <FrameAccessor/FrameAccessor.h>
#import "HB_ContactSearchResultDataSource.h"
#import "HB_netMsgSearchCell.h"
#import "HB_ContactSimpleModel.h"
#import "HB_ContactModel.h"
#import "HB_ContactDataTool.h"
#import "HB_PhoneNumModel.h"

#define SearchTableViewHeight 300
@interface newNetMsgVc ()<VENTokenFieldDelegate, VENTokenFieldDataSource,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(nonatomic,retain)NSMutableArray * names;
@property(nonatomic,retain)NSMutableDictionary * contactDic;

@property(nonatomic,retain)NSMutableArray * tableArr;

@property(nonatomic,retain)NSArray * pickerArr;

@property(nonatomic,retain)NSString * pickerName;

@property(nonatomic,retain)HB_ContactSearchResultDataSource * searchDataSource;

@end

@implementation newNetMsgVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"网络短信";
    self.names = [NSMutableArray array];
    
    [self btndeal];
    [self tokenFildsetUp];
    [self setupTextView];
    [self setupTableview];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenTabBar];
}
-(void)setupTextView
{
    self.contentTextView.delegate = self;
    
}
-(void)setupTableview
{
    CGFloat tableview_y = self.tokenfield.x + self.tokenfield.height;
    self.searchTableview  = [[UITableView alloc] initWithFrame:CGRectMake(0, tableview_y, Device_Width, SearchTableViewHeight) style:UITableViewStylePlain];
    
    //阴影设置
    self.searchTableview.layer.shadowOffset = CGSizeMake(3, 3);
    self.searchTableview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchTableview.layer.shadowOpacity = 0.8f;
    
    
    self.searchTableview.dataSource = self;
    self.searchTableview.delegate= self;
    
    self.searchTableview.hidden = YES;
    [self.view addSubview:self.searchTableview];
    
    
    
}

-(void)btndeal
{
    [self.sendBtn setWithTag:newNetMsg_send backColor:COLOR_A frame:self.sendBtn.frame Target:self action:@selector(btnClick:) title:@"立即发送" titlecolor:[UIColor whiteColor]];
    self.sendBtn.layer.cornerRadius = 8;
    
    [self.addMemberBtn setWithTag:newNetMsg_AddMemb backColor:nil frame:self.addMemberBtn.frame Target:self action:@selector(btnClick:) title:nil titlecolor:nil];
    
    [self.contactBtn setWithTag:newNetMsg_selectContact backColor:nil frame:self.contactBtn.frame Target:self action:@selector(btnClick:) title:nil titlecolor:nil];
    
}

-(void)tokenFildsetUp
{
    self.tokenfield.delegate = self;
    self.tokenfield.dataSource = self;
    self.tokenfield.placeholderText = NSLocalizedString(@"请添加收件人", nil);
    self.tokenfield.toLabelText = NSLocalizedString(@"收件人:", nil);
    [self.tokenfield setColorScheme:[UIColor colorWithRed:61/255.0f green:149/255.0f blue:206/255.0f alpha:1.0f]];
    self.tokenfield.delimiters = @[@",", @";", @"--",@"，",@"。",@"；"];
    [self.tokenfield becomeFirstResponder];
}

#pragma mark - VENTokenFieldDelegate
-(void)tokenField:(VENTokenField *)tokenField didChangeText:(nullable NSString *)text
{
    //搜索功能在此添加
    if (text.length) {
        self.searchDataSource.searchText = text;
    }
    else
    {
        [self.searchDataSource.dataArr removeAllObjects];
    }
    
    
    
    NSLog(@"---%@====%ld",text,self.searchDataSource.dataArr.count);

    [self.searchTableview reloadData];
    
}
- (void)tokenField:(VENTokenField *)tokenField didEnterText:(NSString *)text
{
    HB_netMsgReciModel * model = [[HB_netMsgReciModel alloc] init];
    model.name = text;
    model.number = text;
    [self addReciModel:model];
    [model release];
}

- (void)tokenField:(VENTokenField *)tokenField didDeleteTokenAtIndex:(NSUInteger)index
{
    [self.names removeObjectAtIndex:index];
    [self.tokenfield reloadData];
}

- (void)tokenField:(VENTokenField *)tokenField didChangeContentHeight:(CGFloat)height
{
    self.tokenHeithConstraint.constant = height;
//    [self.view layoutSubviews];
    
    
    self.searchTableview.frame = CGRectMake(0, height, Device_Width, SearchTableViewHeight);
}

#pragma mark - VENTokenFieldDataSource

- (NSString *)tokenField:(VENTokenField *)tokenField titleForTokenAtIndex:(NSUInteger)index
{
    HB_netMsgReciModel * model =self.names[index];
    return model.name;
}

- (NSUInteger)numberOfTokensInTokenField:(VENTokenField *)tokenField
{
    return [self.names count];
}

- (NSString *)tokenFieldCollapsedText:(VENTokenField *)tokenField
{
    NSString * str = @"";
    if ([self.names count]) {
        HB_netMsgReciModel * recmodel =  self.names[0];
        
        str = [NSString stringWithFormat:@"%@等%tu个收件人",recmodel.name, [self.names count]];
    }
    return str;
}

#pragma tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger searchCount = self.searchDataSource.dataArr.count;
    if (searchCount>0) {
        tableView.hidden = NO;
    }
    else
    {
        tableView.hidden = YES;
    }

    return searchCount;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HB_netMsgSearchCell * cell = [HB_netMsgSearchCell cellWithTableView:tableView];

    cell.model  = [self.searchDataSource.dataArr objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43.5;
}
#pragma tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HB_ContactSimpleModel  * Simpmodel = [self.searchDataSource.dataArr objectAtIndex:indexPath.row];
    HB_netMsgReciModel * MsgRecimodel = [[HB_netMsgReciModel alloc] init];
    MsgRecimodel.name = Simpmodel.name;
    MsgRecimodel.number = Simpmodel.showNumber;
    [self addReciModel:MsgRecimodel];
    [MsgRecimodel release];
    
    return;
    
    HB_ContactModel *contactModel=[[HB_ContactModel alloc]init];
    NSDictionary * dict = [HB_ContactDataTool contactPropertyArrWithRecordID:Simpmodel.contactID.intValue];
    [contactModel setValuesForKeysWithDictionary:dict];
    
    if (contactModel.phoneArr.count == 1)
    {
        HB_netMsgReciModel * MsgRecimodel = [[HB_netMsgReciModel alloc] init];
        MsgRecimodel.name = Simpmodel.name;
        MsgRecimodel.number = Simpmodel.showNumber;
        [self addReciModel:MsgRecimodel];
        [MsgRecimodel release];
        
    }
    else if (contactModel.phoneArr.count >= 2)
    {
        self.pickerArr = [NSArray arrayWithArray:contactModel.phoneArr];
        
        self.pickerName = Simpmodel.name;
        
        UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, Device_Width, 200)];
        pickerView.backgroundColor  = [UIColor groupTableViewBackgroundColor];
        pickerView.delegate  = self;
        pickerView.dataSource = self;
        
        [self.view addSubview:pickerView];
        
        [pickerView reloadAllComponents];
        
        
        
    }
    else
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"所选联系人无号码!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    [contactModel release];
    
}
#pragma btnClick
-(void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case newNetMsg_selectContact:
            {
                
            }
            break;
        case newNetMsg_AddMemb:
            {
                
            }
            break;
        case newNetMsg_send:
            {
                
            }
            break;
            
        default:
            break;
    }
}

#pragma -init
-(HB_ContactSearchResultDataSource *)searchDataSource{
    if (!_searchDataSource) {
        _searchDataSource=[[HB_ContactSearchResultDataSource alloc]init];
    }
    return _searchDataSource;
}

#pragma mark textViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    
}



-(void)addReciModel:(HB_netMsgReciModel *)model
{
    [self.names addObject:model];
    self.tokenfield.inputTextField.text = @"";
    self.searchTableview.hidden = YES;
    [self.tokenfield reloadData];
    
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

- (void)dealloc {
    [_tokenfield release];
    [_contentTextView release];
    [_putinLabel release];
    [_msgCountLabel release];
    [_sendBtn release];
    [_contactBtn release];
    [_addMemberBtn release];
    
    [_names release];
    [_contactDic release];
    [_tokenHeithConstraint release];
    [super dealloc];
}
@end
