//
//  PIMBaseVC.h
//  HBZS_IOS
//
//  Created by zimbean on 14-8-6.
//
//

#import <UIKit/UIKit.h>

@interface PIMBaseVC : UIViewController{
    
}

@property (nonatomic, retain)UIImageView *navigationBarBgView;

@property (nonatomic, retain)UILabel *navigationTitleLabel;

@property (nonatomic, retain)UIButton *leftBtn;
@property (nonatomic, retain)UIButton *rightBtn;

@property (nonatomic, assign)BOOL leftBtnIsBack;

- (void)leftBtnAction:(UIButton *)btn;
- (void)rightBtnAction:(UIButton *)btn;

@end
