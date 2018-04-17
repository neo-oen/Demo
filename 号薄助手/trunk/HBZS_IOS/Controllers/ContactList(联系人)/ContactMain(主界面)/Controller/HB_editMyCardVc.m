//
//  HB_editMyCardVc.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/11/14.
//
//

#import "HB_editMyCardVc.h"
#import "HB_ContactDetailController.h"
#import "HB_ContactDetailCell.h"//普通的cell
#import "HB_ContactDetailPhoneCell.h"//电话号码，邮箱 cell
#import "HB_ContactDetailCellModel.h"//普通的cell模型
#import "HB_ContactDetailPhoneCellModel.h"//电话号码，邮箱 cell模型
#import "HB_ContactModel.h"//联系人完整的模型
#import "HB_ContactDetailListModel.h"//界面输入内容的Model
#import "HB_ContactDataTool.h"//联系人工具类
#import "HB_HeaderIconView.h"//用户头像视图
#import "SVProgressHUD.h"
#import "HB_ConvertPhoneNumArrTool.h"//电话号码操作类
#import "HB_ConvertEmailArrTool.h"//邮箱操作类
#import "HB_ContactDetailPhoneEmailTypeManageVC.h"//电话号码和邮箱的标签选择VC
#import "SettingInfo.h"//全局的一些设置
#import "HB_ConvertContactModelAndListModel.h"

#import "ContactProtoToContactModel.h"
#import "HB_httpRequestNew.h"
#import "HB_ContactEditStore.h"
@interface HB_editMyCardVc ()<UIAlertViewDelegate>

///**  数据源 */
//@property(nonatomic,retain)HB_ContactEditStore * store;


@end

@implementation HB_editMyCardVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)finishBtnClick:(UIButton *)btn{
    //页面停止编辑
    [self.view endEditing:YES];
    
    if (self.store.listModel.name.length == 0) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"名字为必填选项" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (!self.contactModel) {
        self.contactModel = [[HB_ContactModel alloc] init];
    }
    
    [HB_ConvertContactModelAndListModel convertListModel:self.store.listModel toContactModel:self.contactModel];
    
    //时间戳毫秒值
    self.contactModel.timestamp = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);

    btn.userInteractionEnabled = NO;
    [self UpdateMyCard];
}


-(void)UpdateMyCard
{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    HB_httpRequestNew * req = [[HB_httpRequestNew alloc] init];
    
    //名片保存时上传固定选 1-updata
    Contact * cardContact =  [[ContactProtoToContactModel shareManager] ContactModelmemMycard:self.contactModel];
    [req UpdateMyCardWithType:1 andContact:cardContact Result:^(BOOL isSucess, int32_t sid, NSInteger resultCode, NSInteger recCode, NSString *url) {
        
        if (!isSucess) {
            [SVProgressHUD dismiss];
            if (self.contactModel.cardid>0) {
                self.contactModel.cardid = -self.contactModel.cardid;
            }
            if (self.editType == Edit_AddNew) {
                [HB_cardsDealtool UpdataCardwithmodel:self.contactModel];
            }
            [self notifyfinished];
            [self errorAlertWithText:@"名片创建失败，请检查网络，本次创建名片将缓存到本地。"];
            return ;
        }
        
        if (recCode == -3) {
            [SVProgressHUD dismiss];
            [self errorAlertWithText:@"名片创建失败，云端已经存在5张名片！本次添加将不会被保存，请重新进入名片界面以更新名片数据。"];
        }
        else if (recCode == 0)
        {
            self.contactModel.cardid = sid;
            if (self.editType == Edit_AddNew) {
                [HB_cardsDealtool UpdataCardwithmodel:self.contactModel];
            }
            
            [SVProgressHUD showSuccessWithStatus:@"名片更新成功"];
            
            [req upCardPortrait:self.contactModel];
            [self notifyfinished];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        
    }];
    
    
    
    [req release];
    
}

-(void)notifyfinished
{
    if ([self.delegate respondsToSelector:@selector(editFinishWithType:)]) {
        [self.delegate editFinishWithType:self.editType];
    }
}
-(void)errorAlertWithText:(NSString *)text
{
    UIAlertView * al =  [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [al show];
    [al release];
}
#pragma mark - HB_ContactDetailPhoneCellDelegate
-(void)contactDetailPhoneCellBeginInsert:(HB_ContactDetailPhoneCell *)cell{
    //获取开始编辑的cell的indexPath
    NSIndexPath * indexPath=[self.tableView indexPathForCell:cell];
    //获取该分组一共有几行cell
    NSInteger numberOfRows=[self.tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == numberOfRows-1) {//判断是否是最后一行，只有最后一行点击才添加
        //1.得到需要插入位置的indexPath
        NSIndexPath * finalIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        
        //3.判断添加的是电话还是邮箱
        if (finalIndexPath.section==1) {//电话号码分组
            if (numberOfRows==9) {//如果等于9行的话，就不允许插入新号码了
                return;
            }
            [self.store loadMorePhoneCell];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[finalIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        }else if (finalIndexPath.section==2){//邮箱分组
            if (numberOfRows>=5) {//如果等于5行的话，就不允许插入新邮箱了
                return;
            }

            [self.store loadMoreEmailCell];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[finalIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        }
    }
}

-(void)contactDetailPhoneCellBeginClear:(HB_ContactDetailPhoneCell *)cell{
    NSIndexPath * indexPath=[self.tableView indexPathForCell:cell];
    //1.获取该组所有数据源
    NSMutableArray * groupArr=self.store.itemsArr[indexPath.section];
    //2.如果存在下一个cell的话，然后判断这个cell是不是空的，如果是空的，就删除
    if (indexPath.row < (groupArr.count-1)) {
        NSIndexPath * nextIndexPath=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        HB_ContactDetailPhoneCell * cell=(HB_ContactDetailPhoneCell*)[self.tableView cellForRowAtIndexPath:nextIndexPath];
        //        if (cell.textField.text.length==0) {
        if (indexPath.section==1) {//电话号码
            //                BOOL ret = indexPath.row == (groupArr.count-1);
            //                if (ret) {
            //                    //不作操作，不删除
            //                }else{
            
            
            
            [self.store.listModel.phoneArr removeObjectAtIndex:indexPath.row];
            [self.store.itemsArr[1] removeObjectAtIndex:indexPath.row];
            
            
            //                }
        }else if(indexPath.section==2){//邮箱
            BOOL ret = indexPath.row == (groupArr.count-1);
            if (ret) {
                //不作操作，不删除
            }else{
                
                [self.store.listModel.eMailArr removeObjectAtIndex:indexPath.row];
                [self.store.itemsArr[2] removeObjectAtIndex:indexPath.row];
            }
        }
        
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        
        //新插入
        HB_ContactDetailPhoneCellModel * model = groupArr.lastObject;
        NSInteger numberOfRows=[self.tableView numberOfRowsInSection:indexPath.section];
        NSIndexPath * finalIndexPath=[NSIndexPath indexPathForRow:numberOfRows inSection:indexPath.section];
        if (indexPath.section == 1) {
            if (model.phoneModel.phoneNum) {
                
                [self.store loadMorePhoneCell];
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[finalIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];
            }
        }
        else if (indexPath.section == 2) {
            if (model.emailModel.emailAddress) {
                [self.store loadMoreEmailCell];
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[finalIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.tableView endUpdates];
            }
        }
        
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(HB_ContactEditStore *)store{
    if (!_store) {
        _store = [[HB_ContactEditStore alloc]init];
        _store.phoneNumFromCallHistory = self.phoneNumFromCallHistory;
        _store.contactModel = self.contactModel;

        while (_store.dataGroup3.count>5) {
            [self.store.dataGroup3 removeLastObject];
        }
//        if ([_store.itemsArr[2] count]>5) {
//            NSMutableArray * groupArr=self.store.itemsArr[2];
//            NSRange top5 = NSMakeRange(0, 5);
//            while (self.store.dataGroup3.count) {
//                <#statements#>
//            }
//            self.store.dataGroup3 = [NSMutableArray arrayWithArray:[groupArr subarrayWithRange:top5]];
//
//        }
        
        while (_store.dataGroup2.count>9) {
            [_store.dataGroup2 removeLastObject];
        }
//        if ([_store.itemsArr[1] count]>9) {
//            NSRange top9 = NSMakeRange(0, 9);
//            NSMutableArray * groupArr=self.store.itemsArr[1];
////            self.store.itemsArr[1] = [NSMutableArray arrayWithArray:[groupArr subarrayWithRange:top9]];
//            self.store.dataGroup2 = [NSMutableArray arrayWithArray:[groupArr subarrayWithRange:top9]];
//        }
        [[_store.itemsArr lastObject] removeLastObject];
    }
    return _store;
}


-(void)saveCard
{
    //保存名片
    Contact * memcontact = [[ContactProtoToContactModel shareManager] ContactModelmemMycard:self.contactModel];
    
    
    //头像
    PortraitData * pordata = [[[PortraitData builder] setImageData:self.contactModel.iconData_original] build];
    [[MemAddressBook getInstance] updMyCard:memcontact];
    [[MemAddressBook getInstance] updMyPortrait:pordata];
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
