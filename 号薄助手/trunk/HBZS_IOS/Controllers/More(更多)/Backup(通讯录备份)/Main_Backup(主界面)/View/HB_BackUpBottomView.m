//
//  HB_BackUpBottomView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/2/25.
//
//

#import "HB_BackUpBottomView.h"

@implementation HB_BackUpBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initinterface];
    }
    return self;
}

-(void)initinterface
{
    self.alpha=0.9;
    self.backgroundColor = [UIColor blackColor];
    
    CGFloat localCountY = Device_Width - 130;
    CGFloat ServiceCountY = Device_Width - 70;
    CGFloat CenterY = self.frame.size.height/2;
    self.accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CenterY-7, 120, 14)];
    self.accountLabel.textColor = [UIColor whiteColor];
    self.accountLabel.text = [NSString stringWithFormat:@"---"];
    self.accountLabel.font = [UIFont systemFontOfSize:12];
    
    
    self.ServiceContctCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(ServiceCountY+20+7, CenterY-7, 40, 14)];
    self.ServiceContctCountLabel.textColor = [UIColor whiteColor];
    self.ServiceContctCountLabel.text = [NSString stringWithFormat:@"---"];
    self.ServiceContctCountLabel.font = [UIFont systemFontOfSize:12];

    
    self.LocalContactCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(localCountY+20, CenterY-7, 40, 14)];
    self.LocalContactCountLabel.textColor = [UIColor whiteColor];
    self.LocalContactCountLabel.text = [NSString stringWithFormat:@"---"];
    self.LocalContactCountLabel.font = [UIFont systemFontOfSize:12];

    
    UIImageView * PhoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"手机"]];
    PhoneImageView.frame = CGRectMake(localCountY, CenterY-10, 14, 20);
    
    UIImageView * serviceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"云端"]];
    serviceImageView.frame = CGRectMake(ServiceCountY, CenterY-7, 20, 14);
    
    
    
    [self addSubview:self.accountLabel];
    [self addSubview:self.LocalContactCountLabel];
    [self addSubview:self.ServiceContctCountLabel];
    [self addSubview:PhoneImageView];
    [self addSubview:serviceImageView];
    
}

@end
