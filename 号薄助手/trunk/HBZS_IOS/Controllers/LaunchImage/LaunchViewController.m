//
//  LaunchViewController.m
//  HBZS_IOS
//
//  Created by zimbean on 14-6-17.
//
//

#import "LaunchViewController.h"

@interface LaunchViewController ()
@property(nonatomic,strong)UIButton * skipBtn;
@end

@implementation LaunchViewController


@synthesize lanuchImgData;


- (void)dealloc{
    if (launchImgView) {
        [launchImgView release];
    }
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLauchImgData:(NSData *)data{
    self = [super init];
    if (self) {
        self.lanuchImgData = data;
    }
    
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skipBtn.frame = CGRectMake(Device_Width-80, Device_Height-110, 60, 25);
    _skipBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_skipBtn setTitle:[NSString stringWithFormat:@"跳过%ds",self.playCountdouw] forState:UIControlStateNormal];
    _skipBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _skipBtn.layer.cornerRadius = 8;
    [_skipBtn addTarget:self action:@selector(skipClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skipBtn];
    
    NSTimer *  Countdown = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CountdownClick:) userInfo:nil repeats:YES];
    
    
}
-(void)CountdownClick:(NSTimer *)timer
{
    self.playCountdouw --;
    [_skipBtn setTitle:[NSString stringWithFormat:@"跳过 %ds",self.playCountdouw] forState:UIControlStateNormal];
    if (self.playCountdouw<=0) {
        [timer invalidate];
        
    }

}
-(void)skipClick:(UIButton *)button
{
    if (self.playtimer) {
        [self.playtimer invalidate];
    }
    if (self.skipBlock) {
        self.skipBlock();
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    launchImgView = [[UIImageView alloc]initWithFrame:self.view.frame];    launchImgView.backgroundColor = [UIColor redColor];
    launchImgView.image = [UIImage imageWithData:lanuchImgData];
    [self.view addSubview:launchImgView];
    
    
	// Do any additional setup after loading the view.
    
}
+(BOOL)isInEndDate
{
    NSInteger now = [[NSDate date] timeIntervalSince1970];
    
    NSInteger endDate = [[[ConfigMgr getInstance] getValueForKey:@"launchImageEndTime" forDomain:nil] longLongValue];
    if (now>endDate) {
        
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
