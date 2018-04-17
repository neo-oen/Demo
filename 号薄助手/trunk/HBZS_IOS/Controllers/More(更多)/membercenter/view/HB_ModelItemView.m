//
//  HB_ModelItemView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/27.
//
//

#import "HB_ModelItemView.h"

@implementation HB_ModelItemView

-(void)dealloc
{
    [super dealloc];
}

- (instancetype)initwithModel:(HB_MemberModel*)model andItemIndex:(NSInteger)i andmemberLevel:(MemberLevel)MyMemberLevel
{
    self = [super init];
    if (self) {
        self.model = model;
        self.MyMemberLevel = MyMemberLevel;
        _index = i;
       
        [self stepInterface];
        
    }
    return self;
}

-(void)stepInterface
{
    CGFloat w=Device_Width/4;
    self.frame = CGRectMake(_index%4*w, 10+_index/4*80, w, 80);
    
    CGFloat Centerx = self.frame.size.width/2;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.center = CGPointMake(Centerx, 30);
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.MyMemberLevel>=self.model.memberlevel) {
       /*新版全部显示为可点状态*/
        [btn setImageWithURL:[NSURL URLWithString:self.model.moduleimgon]];
        self.userInteractionEnabled = YES;
    }
    else
    {
        [btn setImageWithURL:[NSURL URLWithString:self.model.moduleimgoff]];
//        self.userInteractionEnabled = NO;
    }
    
    NSLog(@"%@",self.model.moduleimgon);
    [self addSubview:btn];
    
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, self.frame.size.width,14)];
    titleLabel.text = self.model.moduletext;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor grayColor];
    [self addSubview:titleLabel];
    [titleLabel release];
    
}

-(void)btnClick
{
    if ([self.delegate respondsToSelector:@selector(itemClickWithIndex:)]) {
        [self.delegate itemClickWithIndex:_index];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
