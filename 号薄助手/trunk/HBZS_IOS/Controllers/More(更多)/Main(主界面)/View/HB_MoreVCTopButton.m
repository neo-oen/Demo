//
//  HB_MoreVCTopButton.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_MoreVCTopButton.h"

@implementation HB_MoreVCTopButton
-(void)dealloc
{
    [_redTip release];
    [super dealloc];
}
-(instancetype)init{
    if (self=[super init]) {
        self.backgroundColor=[UIColor whiteColor];
        //设置title
        self.titleLabel.font=[UIFont systemFontOfSize:13];
        [self setTitleColor:COLOR_D forState:UIControlStateNormal];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        //设置ImageView
        self.imageView.layer.masksToBounds=YES;
        self.imageView.layer.cornerRadius=25;
        
        
        self.redTip = [[UIImageView alloc] init];
//        self.redTip.frame = CGRectMake(10+15, 10, 10, 10);

        self.redTip.layer.cornerRadius = 5;
        self.redTip.layer.masksToBounds = YES;
        self.redTip.backgroundColor = [UIColor redColor];
        [self addSubview:self.redTip];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat image_W=50;
    CGFloat image_H=image_W;
    CGFloat image_X=contentRect.size.width*0.5 - image_W * 0.5;
    CGFloat image_Y=16;
    CGRect rect=CGRectMake(image_X, image_Y, image_W, image_H);
    
    self.redTip.frame = CGRectMake(image_W+image_X+15, 10, 10, 10);
    return rect;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat title_W=contentRect.size.width;
    CGFloat title_H=18;
    CGFloat title_X=contentRect.size.width*0.5 - title_W*0.5;
    CGFloat title_Y=16 + 50 +6;
    CGRect rect=CGRectMake(title_X, title_Y , title_W, title_H);
    return rect;
}

@end
