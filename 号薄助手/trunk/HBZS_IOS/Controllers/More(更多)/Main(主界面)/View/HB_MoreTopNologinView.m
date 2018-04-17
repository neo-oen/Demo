//
//  HB_MoreTopNologinView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/6.
//
//

#import "HB_MoreTopNologinView.h"

@implementation HB_MoreTopNologinView

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.registBtn.layer.borderColor = COLOR_A.CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [_registBtn release];
    [super dealloc];
}
- (IBAction)btnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(topNologinView:btnClickWithIndex:)]) {
        //注册1
        [self.delegate topNologinView:self btnClickWithIndex:1];
    }
}
- (IBAction)loginClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(topNologinView:btnClickWithIndex:)]) {
        //登录0
        [self.delegate topNologinView:self btnClickWithIndex:0];
    }
}
@end
