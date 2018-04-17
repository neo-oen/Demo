//
//  HB_ContactDetailPhoneEmailTypeManageVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/14.
//
//

#import "HB_ContactDetailPhoneEmailTypeManageVC.h"
#import "HB_ContactDetailPhoneEmailTypeCell.h"

@interface HB_ContactDetailPhoneEmailTypeManageVC ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  主界面列表
 */
@property (retain, nonatomic) IBOutlet UITableView *tableView;
/**
 *  数据源(当前可以选择的剩余标签类型)
 */
@property(nonatomic,retain)NSMutableArray *dataArr;

//@property(nonatomic,retain);

@property(nonatomic,strong)NSString * typeString;

//@property(nonatomic,strong)

@end

@implementation HB_ContactDetailPhoneEmailTypeManageVC
- (void)dealloc {
//    [_tableView release];
    [_phoneCellModel release];
    [_dataArr release];
    [_typeArr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"标签管理";
}
#pragma mark - 数据源

-(NSMutableArray *)dataArr{
    
//    if (self.typeArr) {
//        return self.typeArr;
//    }
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
        if (self.phoneCellModel.phoneModel) {
            [_dataArr addObjectsFromArray:@[@"住宅",@"iPhone",@"工作",@"手机",@"住宅传真",@"主要",@"工作传真",@"传呼",@"其他"]];
        }
        else
        {
            [_dataArr addObjectsFromArray:@[@"常用邮箱",@"商务邮箱",@"个人邮箱",@"其他邮箱1",@"其他邮箱2"]];
        }
    }
    return _dataArr;
}
#pragma mark - tableView协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HB_ContactDetailPhoneEmailTypeCell * cell=[HB_ContactDetailPhoneEmailTypeCell cellWithTableView:tableView];
    
    NSString * typeStr=self.dataArr[indexPath.row];
    if ([typeStr isEqualToString:self.phoneCellModel.phoneModel.phoneType] || [typeStr isEqualToString:self.phoneCellModel.emailModel.emailType]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    cell.typeNameLabel.text=typeStr;
    NSLog(@"---%d",cell.selected);
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //使得该cell选中
    HB_ContactDetailPhoneEmailTypeCell * cell=(HB_ContactDetailPhoneEmailTypeCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected=YES;
    //将当前phoneCellModel中的phoneModel/emailModel的类型做更改
    NSString * typeStr = self.dataArr[indexPath.row];
    if (self.phoneCellModel.phoneModel) {
        [self.typeArr insertObject:self.phoneCellModel.phoneModel.phoneType atIndex:0];
        self.phoneCellModel.phoneModel.phoneType=typeStr;
    }else if (self.phoneCellModel.emailModel){
        [self.typeArr insertObject:self.phoneCellModel.emailModel.emailType atIndex:0];
        self.phoneCellModel.emailModel.emailType=typeStr;
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中某一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //使得改cell取消选中
    HB_ContactDetailPhoneEmailTypeCell * cell=(HB_ContactDetailPhoneEmailTypeCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected=NO;
}
#pragma mark -


@end
