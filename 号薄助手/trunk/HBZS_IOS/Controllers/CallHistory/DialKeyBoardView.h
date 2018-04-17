//  拨号键盘
//  DialKeyBoardView.h
//  HBZS_IOS
//
//  Created by yingxin on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _keyBoardType //用于标记键盘功能按键
{
    
    keyBoardDelete=1000,  //删除按钮
    keyBoardAddressBook,  //号码本按钮
    keyBoardDial,         //拨号
    keyBoardToNumber,     //切换到数字键盘
    keyBoardToabc         //切换到字母键盘
    
}keyBoardType;
@protocol DialKeyBoardDelegate;

@interface DialKeyBoardView : UIView{
    
    CGRect showFrame;
    
    CGRect hideFrame;
    
    
    NSArray* btnImagesNormal;
    
    NSArray* btnImagesHighlight;
    
    NSMutableString * dialNumberString;
    
    
    UIView * numberKeyBoardView;
    
    UIView * abcKeyBoardView;
    
    id<DialKeyBoardDelegate> _delegate;
    
    BOOL m_hidden;
}

@property (nonatomic, retain) NSMutableString * dialNumberString;

@property (nonatomic, assign) id<DialKeyBoardDelegate> delegate;

@property (nonatomic, assign) BOOL m_hidden;

@property(nonatomic,assign)CGRect showFrame;

@property (nonatomic, assign)CGRect hideFrame;

- (id)initWithShowFrame:(CGRect)sframe hideFrame:(CGRect)hframe;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)createKeyboardView;


@end

//协议实现
@protocol DialKeyBoardDelegate <NSObject>

- (void)dialButtonIndex:(keyBoardType)idx;

- (void)dialingClick;

- (void)pushToaddressVc;

- (void)dialKeyBoardHided:(BOOL)bhided;

- (void)OneKeyDailIndex:(NSInteger)OnekeyIndex;

@end
