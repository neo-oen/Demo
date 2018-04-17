//
//  HB_HeaderIconView.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/8.
//
//

#define ICON_Height 264
#import <UIKit/UIKit.h>
#import "HB_ContactModel.h"
@class HB_HeaderIconView;
/**
 *  HB_HeaderIconView协议
 */
@protocol HB_HeaderIconViewDelegate <NSObject>
/** 打开相机 */
-(void)headerIconViewDidOpenCamera:(HB_HeaderIconView*)headerView;
/** 打开相册 */
-(void)headerIconViewDidOpenLibrary:(HB_HeaderIconView *)headerView;
/** 删除头像 */
-(void)headerIconViewDeleteIcon:(HB_HeaderIconView *)headerView;

/*详情按钮回调*/
-(void)headerIconViewbInfoBtnClick:(HB_HeaderIconView *)headerview;


@end

@interface HB_HeaderIconView : UIView<UIActionSheetDelegate>

/** HB_HeaderIconView的代理 */
@property(nonatomic,assign)id<HB_HeaderIconViewDelegate> delegate;

@property (retain, nonatomic) UIButton *editIconBtn;
/** 头像图片 */
@property (retain, nonatomic) UIImageView *iconImageView;
/** 背景 */
@property (retain, nonatomic) UIImageView *bgImageView;
/** 名字 */
@property (retain, nonatomic) UILabel *nameLabel;
/** 职位 */
@property (retain, nonatomic) UILabel *jobLabel;
/** 公司 */
@property (retain, nonatomic) UILabel *companyLabel;




/** 联系人模型 */
@property(nonatomic,retain)HB_ContactModel *contactModel;

/** 背景图编号*/
@property(nonatomic,assign)NSInteger bgimageindex;
/** 编辑头像点击事件 */
- (void)editBtnClick:(UIButton *)sender;

@end
