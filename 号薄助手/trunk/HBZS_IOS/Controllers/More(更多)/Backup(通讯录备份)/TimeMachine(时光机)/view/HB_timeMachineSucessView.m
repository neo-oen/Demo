//
//  HB_timeMachineSucessView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/5/16.
//
//

#import "HB_timeMachineSucessView.h"

@implementation HB_timeMachineSucessView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 90, 50);
        self.center = CGPointMake(Device_Width/2, Device_Height/2-40);
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.textColor = [UIColor colorWithWhite:1 alpha:9];
        self.textAlignment = NSTextAlignmentCenter;
        self.text = @"恢复成功";
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
