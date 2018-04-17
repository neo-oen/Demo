//
//  UnlimitedBpStartView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/7/27.
//
//

#import "UnlimitedBpStartView.h"

@implementation UnlimitedBpStartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [_headerImageview release];
    [_bottomBtn release];
    [_titleLabel release];
    [_ContentTextView release];
    [super dealloc];
}
- (IBAction)OpenNowClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(OpenNow)]) {
        [self.delegate OpenNow];
    }
}
@end
