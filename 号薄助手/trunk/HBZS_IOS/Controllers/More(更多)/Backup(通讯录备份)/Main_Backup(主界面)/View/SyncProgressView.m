//
//  SyncProgressView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/7.
//
//

#import "SyncProgressView.h"
#import "Colours.h"
@implementation SyncProgressView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self createAlertview];
        self.backgroundColor  = [UIColor colorWithWhite:0 alpha:0.6];
        
        self.frame = [UIScreen mainScreen].bounds;

        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    if (self.precentlabel) {
        self.precentlabel = nil;
        [self.precentlabel release];
    }
    if (self.progressView) {
        self.progressView = nil;
        [self.progressView release];
    }
    if (self.titlelabel) {
        self.titlelabel = nil;
        [self.titlelabel release];
    }
    if (self.alertv) {
        self.alertv = nil;
        [self.alertv release];
    }

}

-(void)createAlertview
{
    _alertv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 80)];
    _alertv.backgroundColor = [UIColor lightGrayColor];
    _alertv.center = [UIApplication sharedApplication].keyWindow.center;
    _alertv.layer.cornerRadius = 7;
    _alertv.layer.masksToBounds = YES;
    _alertv.image = [[UIImage imageNamed:@"alertbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    [self addSubview:_alertv];
    [_alertv release];
    
    [self allocTitlelabel];
    [self allocPrecentlabel];
    [self allocProgressView];
}

-(void)allocTitlelabel
{
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 120, 20)];
    [_alertv addSubview:self.titlelabel];
    self.titlelabel.font = [UIFont systemFontOfSize:15];
    self.titlelabel.text = @"ggg";
    self.titlelabel.textAlignment = NSTextAlignmentRight;
    [self.titlelabel release];
}
-(void)allocPrecentlabel
{
    self.precentlabel  = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 80, 20)];
    [_alertv addSubview:self.precentlabel];
//    self.precentlabel.text = @"1233";
    self.precentlabel.font = [UIFont systemFontOfSize:15];
    [self.precentlabel release];
}
-(void)allocProgressView
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(5, 55, 250, 5)];
    self.progressView.transform = CGAffineTransformMakeScale(0.8,6);
    [_alertv addSubview:self.progressView];
    self.progressView.progressTintColor = [UIColor orangeColor];
    self.progressView.trackTintColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self.progressView release];
}

- (void)setProgressMin {
    [self.progressView setProgress:0.02 animated:YES];
    self.precentlabel.text = @"0.01%";
}

-(void)setProgressMax
{
    [self.progressView setProgress:1 animated:NO];
}

-(void)setProTitleWithString:(NSString *)str
{
    self.titlelabel.text = [NSString stringWithFormat:@"%@:",str];
    
}


-(void)setSyncProgress:(float)progress animated:(BOOL)animate
{
    [self.progressView setProgress:progress animated:animate];
    self.precentlabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //  从群里面学习到的
    
}
-(void)showInView:(UIViewController *)vc
{
    [vc.view addSubview:self];
}

-(void)dismiss
{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alertv.alpha = 0;
        self.alertv.bounds = CGRectMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
