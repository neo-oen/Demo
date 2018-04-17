//
//  MyTabBar.h
//  HBZS_IOS
//
//  Created by yingxin on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
  DIAL_BTN_TYPE = 100,
  CONTACT_BTN_TYPE,
  LIFE_BTN_TYPE,
  MORE_BTN_TYPE
}BOTTOM_BUTTON_TYPE;

#define MAXBTNNUM 4

@protocol MyTabBarItemDelegate;

@interface MyTabBar : UIView{
  CGRect showFrame;
  CGRect hideFrame;
  CGRect btnFrames[MAXBTNNUM];
    
  NSArray* btnImagesNormal;
  NSArray* btnImagesHighlight;
    
  BOOL firstBoot;
  BOOL dialKbdHide;
  
  id<MyTabBarItemDelegate> _delegate;
}

@property (nonatomic, assign) BOTTOM_BUTTON_TYPE currentType;

@property (nonatomic, assign) id<MyTabBarItemDelegate> delegate;

@property (nonatomic, assign) BOOL dialKbdHide;

+(MyTabBar *)shareManger;

- (id)initWithShowFrame:(CGRect)sframe hideFrame:(CGRect)hframe;

- (void)createTabViewandShowSelected;

- (void)setButtonSelected:(id)sender;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setDialKbdHide:(BOOL)bhide;

@end

//协议实现
@protocol MyTabBarItemDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)idx;

- (void)dialKbdHide:(BOOL)hide;

@end
