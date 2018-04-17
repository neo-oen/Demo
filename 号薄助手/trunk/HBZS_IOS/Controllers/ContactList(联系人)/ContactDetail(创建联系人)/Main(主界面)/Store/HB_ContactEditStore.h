//
//  HB_ContactEditStore.h
//  HBZS_IOS
//
//  Created by zimbean on 16/1/25.
//
//

#import <Foundation/Foundation.h>
#import "HB_ContactModel.h"
#import "HB_ContactDetailListModel.h"

@interface HB_ContactEditStore : NSObject
/** 数据源 */
@property(nonatomic,retain)NSMutableArray *itemsArr;
/** 列表需要的数据模型 */
@property(nonatomic,retain)HB_ContactDetailListModel *listModel;
/** 联系人完整模型 */
@property(nonatomic,retain)HB_ContactModel *contactModel;
/** (一定要要先传这个参数)从拨号界面传入的联系人号码。使用场景是：在拨号界面新增联系人 */
@property(nonatomic,copy)NSString *phoneNumFromCallHistory;


/** 分组1的数据 */
@property(nonatomic,retain)NSMutableArray *dataGroup1;
/** 分组2的数据 */
@property(nonatomic,retain)NSMutableArray *dataGroup2;
/** 分组3的数据 */
@property(nonatomic,retain)NSMutableArray *dataGroup3;
/** 分组4的数据 */
@property(nonatomic,retain)NSMutableArray *dataGroup4;
/** 分组5的数据 */
@property(nonatomic,retain)NSMutableArray *dataGroup5;
/**
 *  添加第5组‘更多资料’数据
 */
-(void)addDataGroup5;
/**
 *  加载多一条空白的电话号码cell
 */
-(void)loadMorePhoneCell;
/**
 *  加载多一条空白的邮箱cell
 */
-(void)loadMoreEmailCell;

@end
