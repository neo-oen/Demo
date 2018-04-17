//
//  HB_ContactDetailPhoneCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

#import <UIKit/UIKit.h>
#import "HB_ContactDetailPhoneCellModel.h"
@class HB_ContactDetailPhoneCell;

@protocol HB_ContactDetailPhoneCellDelegate <NSObject>
/**
 *  phoneCell中的textfield开始插入内容了
 */
-(void)contactDetailPhoneCellBeginInsert:(HB_ContactDetailPhoneCell * )cell;
/**
 *  phoneCell中的内容清空了
 */
-(void)contactDetailPhoneCellBeginClear:(HB_ContactDetailPhoneCell * )cell;
/**
 *  phoneCell中的内容停止编辑
 */
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell * )cell didEndEditingWithText:(NSString * )text;
/**
 *  phoneCell左侧删除按钮点击了
 */
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell * )cell deleteLeftBtnClick:(UIButton * )deleteBtn;
/**
 *  phoneCell右侧删除按钮点击了
 */
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell * )cell deleteRightBtnClick:(UIButton * )deleteBtn;
/**
 *  phoneCell类型选择按钮点击了
 */
-(void)contactDetailPhoneCell:(HB_ContactDetailPhoneCell * )cell typeChooseBtnClick:(UIButton * )chooseBtn;
/**
 *  phoneCell的touchBegin事件
 */
-(void)contactDetailPhoneCellTouchBegin:(HB_ContactDetailPhoneCell * )cell;

@end

@interface HB_ContactDetailPhoneCell : UITableViewCell

/** 选项名称 */
@property(nonatomic,retain)UITextField *textField;
/** 类型选择按钮 */
@property(nonatomic,retain)UIButton *typeButton;

/**  数据模型 */
@property(nonatomic,retain)HB_ContactDetailPhoneCellModel *model;
/**  代理 */
@property(nonatomic,assign)id<HB_ContactDetailPhoneCellDelegate> delegate;
/**  快速返回一个手机号cell */
+(instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  cell复原位置
 */
-(void)recoveryCell;

@end
