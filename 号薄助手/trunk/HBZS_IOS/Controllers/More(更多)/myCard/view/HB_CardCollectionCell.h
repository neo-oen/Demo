//
//  HB_CardCollectionCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/5/16.
//
//

#define Padding     15
#import <MessageUI/MessageUI.h>

#import <UIKit/UIKit.h>
#import "HB_HeaderIconView.h"//头像视图
#import "HB_ContactInfoStore.h"

#import "HB_ContactModel.h"//联系人model
#import "HB_ContactDetailListModel.h"//联系人所有属性的列表model
#import "HB_PhoneNumModel.h"//电话模型
#import "HB_EmailModel.h"//邮箱模型
#import "HB_ContactSendTopTool.h"
#import "HB_ContactDataTool.h"
#import "HB_ContactDetailController.h"
#import "HB_ContactInfoDialItemModel.h"//详情页的通话记录模型
#import "HB_ContactInfoDialItemTool.h"//把系统的通话记录模型转变成详情页需要的模型
//4种model
#import "HB_ContactInfoCellModel.h"
#import "HB_ContactInfoPhoneCellModel.h"
#import "HB_ContactInfoEmailCellModel.h"
#import "HB_ContactInfoCallHistoryCellModel.h"
//4种cell
#import "HB_ContactInfoCell.h"
#import "HB_ContactInfoPhoneCell.h"
#import "HB_ContactInfoEmailCell.h"
#import "HB_ContactInfoCallHistoryCell.h"

#import "UMSocial.h"//友盟

#import "SettingInfo.h"

#import "HB_ConvertPhoneNumArrTool.h"
#import "HB_ConvertEmailArrTool.h"

#import "GetContactAdProto.pb.h"

#import "UIImageView+WebCache.h"
#import "HB_WebviewCtr.h"
#import "HBZSAppDelegate.h"

#import "HB_CallSettingVC.h"

typedef enum : NSUInteger {
    card_collectionCell_Call = 0,
    card_collectionCell_Message,
    card_collectionCell_Email,
} enum_cardColCellClick;

@class HB_CardCollectionCell;
@protocol CardCollectionCelldelegate <NSObject>

-(void)CardCollectionCell:(HB_CardCollectionCell *)cell contactType:(enum_cardColCellClick)type NumOrAdress:(NSString * )NOAString;

-(void)CardCollectionCellDidScroll:(UIScrollView *)scrollView;

@end

@interface HB_CardCollectionCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource,HB_ContactInfoEmailCellDelegate,HB_ContactInfoPhoneCellDelegate,UIActionSheetDelegate,HB_HeaderIconViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>
/** 代理 */
@property(nonatomic,assign)id<CardCollectionCelldelegate>delegate;
/** 列表 */
@property (nonatomic,retain) UITableView       * tableView;
///** “更多”按钮展示的浮层视图 */
//@property(nonatomic,retain)HB_ContactInfoMoreView *moreView;
/** 联系人模型 */
@property(nonatomic,retain)HB_ContactModel *contactModel;
/** 数据源 */
@property(nonatomic,retain)HB_ContactInfoStore *store;
/** 头像 */
@property (nonatomic,retain) HB_HeaderIconView *headerIconView;

/** 通话记录按钮 */
@property (nonatomic,retain) UIButton        *callHistoryBtn;

/** 名片别名 */
@property (nonatomic,retain) UILabel * CardNamelabel;

@property(nonatomic,assign)NSInteger cellIndex;

@end
