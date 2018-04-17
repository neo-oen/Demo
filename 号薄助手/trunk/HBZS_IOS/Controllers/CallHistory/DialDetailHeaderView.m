//
//  DialDetailHeaderView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/8/27.
//
//

#import "DialDetailHeaderView.h"

@implementation DialDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc
{
    
    if (_leftImageView) {
        [_leftImageView release];
        _leftImageView = nil;
    }
    
    if (_titlebtn) {
        [_titlebtn release];
        _titlebtn = nil;
    }
    
    if (_rightbtn) {
        [_rightbtn release];
        _rightbtn = nil;
    }
    
    if (_numberTypelab) {
        [_numberTypelab release];
        _numberTypelab = nil;
    }
    
    if (_Attributionlab) {
        [_Attributionlab release];
        _Attributionlab = nil;
    }
    
    [super dealloc];

}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 17.5, 25, 25)];
    [self addSubview:self.leftImageView];
    [self.leftImageView release];
    
    self.titlebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titlebtn.frame = CGRectMake(55, 5, 220, 50);
    self.titlebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.titlebtn];
    
    self.rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightbtn.frame = CGRectMake(Device_Width-55, 5, 50, 50);
    [self addSubview:self.rightbtn];
    
    self.numberTypelab  = [[UILabel alloc] initWithFrame:CGRectMake(55, 40, 80, 12)];
    self.numberTypelab.font = [UIFont systemFontOfSize:12];
    self.numberTypelab.textColor = [UIColor grayColor];
    [self addSubview:self.numberTypelab];
    [self.numberTypelab release];
    
    self.Attributionlab = [[UILabel alloc] initWithFrame:CGRectMake(155, 40, 80, 12)];
    self.Attributionlab.font = [UIFont systemFontOfSize:12];
    self.Attributionlab.textColor = [UIColor grayColor];
    [self addSubview: self.Attributionlab ];
    
}

@end
