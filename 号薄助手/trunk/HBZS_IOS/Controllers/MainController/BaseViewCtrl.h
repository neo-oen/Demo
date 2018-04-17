//
//  BaseViewCtrl.h
//  HBZS_IOS
//
//  Created by yingxin on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewCtrl : UIViewController{
    
    UIButton * rightBtn;
    UIButton * leftBtn;
    
    UIBarButtonItem *leftBtnItem;
    UIBarButtonItem *rightBtnItem;
    UIBarButtonItem *leftBtnBackItem;
    
//    UIWebView *_phoneCallWebView;//用于拨号
    BOOL willMakeAIPCall;//用于判断是否需要ip拨号

}

@property(nonatomic,retain)UIBarButtonItem *leftBtnItem;
@property(nonatomic,retain)UIBarButtonItem *rightBtnItem;
@property(nonatomic,retain)UIBarButtonItem *leftBtnBackItem;


/**  导航左侧是否是返回按钮（BaseViewCtrl父类方法） */
@property(nonatomic, assign) BOOL leftBtnIsBack;

@property (nonatomic, retain)UILabel *titleLabel;

@property (nonatomic, retain)NSString *pageviewStartWithName;

@property (nonatomic, retain) NSMutableArray *dialItemsArray;//通话记录数据
@property (nonatomic, copy)void(^CalledBlock)();
/** 拨打电话 */
- (void)dialPhone:(NSString*)phoneStr contactID:(NSInteger)contactID Called:(void(^)())CalledBlock;
/** 发送短信 */
- (void)doSendMessage:(NSArray *)phoneArr;
/** 发送邮件 */
-(void)sendEmailWithEmailArr:(NSArray *)emailArr;

- (void)initLeftButton:(NSString*)imgNormal imgHighlight:(NSString*)imgHlight;

- (void)initRightButton:(NSString*)imgNormal imgHighlight:(NSString*)imgHlight;

- (void)initBackBtn;

- (void)setLeftButton:(NSString*)imgNormal imgHighlight:(NSString*)imgHlight;

- (void)setRightButton:(NSString*)imgNormal imgHighlight:(NSString*)imgHlight;

- (void)titleLeftBtnDo:(UIButton *)btn;

- (void)titleLeftBackBtnDo:(UIButton *)btn;

- (void)titleRightBtnDo:(UIButton *)btn;

- (void)setTitleLeftBtnHidden:(BOOL)bhidden;

- (void)setTitleRightBtnHidden:(BOOL)bhidden;

- (void)setTitleBackLeftBtnHidden:(BOOL)bhidden;

//显示、隐藏TabBar
- (void)showTabBar;
- (void)hiddenTabBar;

- (void)alertViewWithMessage:(NSString *)message;
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message;

@end
