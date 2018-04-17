//
//  HB_addContactView.h
//  HBZS_iOS
//
//  Created by zimbean on 15/7/13.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//


#import <UIKit/UIKit.h>
@class HB_addContactView;

typedef enum {
    CREATE_NEW_CONTACT=1000,//新建联系人
    SWEEP_CODE_ADD_CONTACT, // 扫码添加
    CONTACT_SHARE_BY_CLOUD,  //联系人云分享
    BATCH_DELETE //批量删除
    
}ADD_ContactView_Button_TYPE;

@protocol HB_addContactViewDelegate <NSObject>

/**
 *  表示“新建联系人”页面被点击
 */
-(void)addContactViewDidClick:(HB_addContactView *)addContactView withButtonTag:(NSInteger)tag;

@end


@interface HB_addContactView : UIView<UIWebViewDelegate>

@property(nonatomic,assign)id<HB_addContactViewDelegate> delegate;

@end
