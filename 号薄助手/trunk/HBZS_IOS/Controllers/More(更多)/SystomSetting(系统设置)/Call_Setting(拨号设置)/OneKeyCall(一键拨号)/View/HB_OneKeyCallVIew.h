//
//  HB_OneKeyCallVIew.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/31.
//
//

#import <UIKit/UIKit.h>
#import "HB_OneKeyCallModel.h"
@class HB_OneKeyCallVIew;

@protocol HB_OneKeyCallVIewDelegate <NSObject>
/**
 *  添加一键拨号的按钮点击了
 */
-(void)oneKeyCallView:(HB_OneKeyCallVIew *)view addContactBtnClick:(UIButton *)
btn;
/**
 *  删除该一键拨号的按钮点击了
 */
-(void)oneKeyCallView:(HB_OneKeyCallVIew *)view deleteContactBtnClick:(UIButton *)btn;

@end

@interface HB_OneKeyCallVIew : UIView
/**
 *  代理
 */
@property(nonatomic,assign)id<HB_OneKeyCallVIewDelegate> delegate;

/**
 *  一键拨号的联系人模型HB_OneKeyCallModel
 */
@property(nonatomic,retain)HB_OneKeyCallModel * model;
/**
 *  第几个按键对应的按钮
 */
@property(nonatomic,assign)NSInteger keyNumber;
/**
 *  是否进入编辑状态
 */
@property(nonatomic,assign,getter=isEditStatus)BOOL editStatus;

@end
