//
//  UIButton+HB_fqBtnset.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/12/6.
//

#import <UIKit/UIKit.h>

@interface UIButton (HB_fqBtnset)
-(void)setWithTag:(NSInteger)tag backColor:(UIColor *)bColor frame:(CGRect)frame Target:(id)target action:(SEL)action title:(NSString *)title titlecolor:(UIColor *)titlecolor;

@end
