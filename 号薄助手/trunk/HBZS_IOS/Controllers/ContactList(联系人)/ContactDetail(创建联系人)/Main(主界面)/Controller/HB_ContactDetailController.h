//
//  HB_ContactDetailController.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//
/*
 逻辑解释：
     1.新建联系人；这两个参数都为nil
     2.编辑联系人：model有值，phoneStr为nil
     3.给某个联系人增加电话号码：model有值，phoneStr有值
     4.扫二维码：model有值，但是model.recordID为空，phoneStr为nil
 */

#import "BaseViewCtrl.h"
#import "HB_ContactModel.h"
#import "HB_ContactEditStore.h"
@class HB_ContactDetailController;
@protocol HB_ContactDetailDelagete <NSObject>

/*联系人保存后回调，传回保存联系人的id*/
-(void)ContactDetailController:(HB_ContactDetailController *)ContactDetailController SavedContact:(NSInteger)contactId;


@end

@interface HB_ContactDetailController : BaseViewCtrl
{
    HB_ContactEditStore * _store;

}


/** tableView */
@property(nonatomic,retain)UITableView *tableView;


/** 从拨号界面传入的一个电话号码 */
@property(nonatomic,copy)NSString *phoneNumFromCallHistory;
/** 联系人模型 */
@property(nonatomic,retain)HB_ContactModel *contactModel;
//数据
@property(nonatomic,retain)HB_ContactEditStore *store;
//当前名片index
@property(nonatomic,assign)NSInteger Cardindex;

@property(nonatomic,strong)id<HB_ContactDetailDelagete>delegate;

@end
