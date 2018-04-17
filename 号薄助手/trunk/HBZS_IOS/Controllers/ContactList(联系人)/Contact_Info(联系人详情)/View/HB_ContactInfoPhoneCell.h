//
//  HB_ContactInfoPhoneCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import <UIKit/UIKit.h>
#import "HB_ContactInfoPhoneCellModel.h"
@class HB_ContactInfoPhoneCell;
@protocol HB_ContactInfoPhoneCellDelegate <NSObject>
/** 拨打电话按钮点击 */
-(void)contactInfoPhoneCellDidPhoneCall:(HB_ContactInfoPhoneCell *)phoneCell;
/** 发送短信按钮点击 */
-(void)contactInfoPhoneCellDidSendMessage:(HB_ContactInfoPhoneCell *)phoneCell;
@end
@interface HB_ContactInfoPhoneCell : UITableViewCell
/**
 *  电话cell的模型
 */
@property(nonatomic,retain)HB_ContactInfoPhoneCellModel *model;
/**
 *  HB_ContactInfoPhoneCell的代理
 */
@property(nonatomic,assign)id<HB_ContactInfoPhoneCellDelegate> delegate;
/**
 *  快速返回一个cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  短信按钮
 */
@property(nonatomic,retain)UIButton *messageBtn;
/**
 *  透明的拨号按钮遮罩
 */
@property(nonatomic,retain)UIButton *callBtn;

/**
 *  底部细线right
 */
@property(nonatomic,retain)UILabel *lineLabel_right;
/**
 *  图标
 */
@property(nonatomic,retain)UIImageView  *iconImageView;
/**
 *  是否是最近通话
 */
@property(nonatomic,assign)BOOL isLastCall;
@end
