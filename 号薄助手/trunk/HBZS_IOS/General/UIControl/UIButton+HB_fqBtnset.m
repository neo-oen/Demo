//
//  UIButton+HB_fqBtnset.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/12/6.
//

#import "UIButton+HB_fqBtnset.h"

@implementation UIButton (HB_fqBtnset)


-(void)setWithTag:(NSInteger)tag backColor:(UIColor *)bColor frame:(CGRect)frame Target:(id)target action:(SEL)action title:(NSString *)title titlecolor:(UIColor *)titlecolor
{
    self.tag = tag;
    if (bColor) {
        self.backgroundColor = bColor;
    }
    
    self.frame = frame;
    if (target&&action) {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (title.length) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (titlecolor) {
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
    }
    
}

@end
