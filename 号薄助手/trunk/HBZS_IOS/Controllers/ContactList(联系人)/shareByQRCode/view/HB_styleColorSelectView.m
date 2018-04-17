//
//  HB_styleColorSelectView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/22.
//
//

#import "HB_styleColorSelectView.h"

@implementation HB_styleColorSelectView

-(instancetype)init
{
    self  = [super init];
    if (self) {
        self.colorsArr = @[@"FF0000",@"FE8828",@"FFEF00",@"159846",@"1BA1E6",@"0F69B2",@"911482",@"000000"];
        [self setepInterface];
    }
    return self;
}

-(void)setepInterface
{
    self.frame = CGRectMake(0, 0, 220, 30+(_colorsArr.count/4 +1)*60);
    self.center =CGPointMake(Device_Width/2, Device_Height/2-64);
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 5.0;

    self.layer.cornerRadius = 5;
    
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.99];
    
    
    
    
    CGFloat btn_w = 30;
    CGFloat btn_h = 30;
    CGFloat spacing = 27.5;
    for (NSInteger i = 0; i<self.colorsArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+i%4*btn_w +i%4*spacing, 30+i/4*btn_h + i/4*spacing, 30, 30);
        btn.backgroundColor = [UIColor colorFromHexString:[self.colorsArr objectAtIndex:i]];
        btn.tag = i;
        [btn addTarget:self action:@selector(colorSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 2;
        [self addSubview:btn];
    }
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, 16)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"请点击选择样式:";
    [self addSubview:label];
}

-(void)colorSelectClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(styleColorSelectView:selectedColorHex:)]) {
        [self.delegate styleColorSelectView:self selectedColorHex:[self.colorsArr objectAtIndex:btn.tag]];
    }
    [self remove];
}

-(void)remove
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
