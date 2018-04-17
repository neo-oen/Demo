//
//  UIViewController+TitleView.h
//  HBZS_IOS
//
//  Created by zimbean on 13-10-27.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (TitleView)

- (void)allocSyncButton;
- (void)setVCTitle:(NSString *)title;

- (void)setVCTitle:(NSString *)title backupButtonIsHidden:(BOOL)isHidden;

- (NSString *)vcTitle;

/**
 *  给导航栏标题设置选择分组按钮
 *
 *  @param title 标题
 */
-(void)setVCTitleButtonWithTitle:(NSString *)title;

@end
