//
//  HB_ShareByQRcodeMoreView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/20.
//
//

#import "HB_ShareByQRcodeMoreView.h"

@implementation HB_ShareByQRcodeMoreView

-(void)dealloc
{
    [super dealloc];
}

-(instancetype)initWithNames:(NSArray *)nameArr andStyle:(MoreView_Style)style
{
    self = [super init];
    if (self) {
        [self setupSubViews:nameArr Style:style];
        self.hidden = YES;
    }
    return self;
}
-(void)setupSubViews:(NSArray *)nameArr Style:(MoreView_Style)style
{
    //计算高度
    CGFloat topPadding = 10;
    CGFloat bottomPadding = 8;
    
    CGFloat view_W = 120;
    CGFloat view_H = topPadding+44*nameArr.count+bottomPadding;
    CGFloat View_X = Device_Width-10-view_W;
    CGFloat View_Y = -3;
    self.frame = CGRectMake(View_X, View_Y, view_W, view_H);

    //1.背景图
    UIImageView* bgImageView=[[UIImageView alloc]init];
    bgImageView.frame = self.bounds;
    bgImageView.userInteractionEnabled=YES;
    NSString * bgimageName = [NSString stringWithFormat:@"下拉框%d",style];
    bgImageView.image=[UIImage imageNamed:bgimageName];
    
    [self addSubview:bgImageView];
    
    for (NSInteger i = 0;i<nameArr.count ; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, topPadding+44*i, view_W, 44);
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn setTitleColor:COLOR_D forState:UIControlStateNormal];
        [btn setTitle:[nameArr objectAtIndex:i] forState:UIControlStateNormal];
        btn.tag = i;

        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:btn];
        
        if (i<nameArr.count-1) {
            UIView * lineview=[[UIView alloc]init];
            lineview.backgroundColor=COLOR_H;
            lineview.frame=CGRectMake(5, CGRectGetMaxY(btn.bounds)-0.5, btn.frame.size.width-10, 0.5);
            [btn addSubview:lineview];
            [lineview release];
        }
        
    }
    
    
    if (style == More_View_Style_Right2) {
        //设置阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 2;
    }
    
}

-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shareByQRcodeMoreView:WithselectIndex:)]) {
        [self.delegate shareByQRcodeMoreView:self WithselectIndex:btn.tag];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
