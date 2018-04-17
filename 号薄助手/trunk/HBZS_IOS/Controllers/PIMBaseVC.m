//
//  PIMBaseVC.m
//  HBZS_IOS
//
//  Created by zimbean on 14-8-6.
//
//

#import "PIMBaseVC.h"

@interface PIMBaseVC ()

@end

@implementation PIMBaseVC

@synthesize navigationBarBgView;
@synthesize navigationTitleLabel;

@synthesize leftBtn;
@synthesize rightBtn;

@synthesize leftBtnIsBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawControls];
    // Do any additional setup after loading the view.
}

- (void)drawControls{
    [self drawNavigationBarBgView];
    [self drawNavigationTitleLabel];
 
    [self drawLeftBtn];
    [self drawRightBtn];
}

#pragma mark Drawing
- (void)drawNavigationBarBgView{
    CGRect viewFrame = CGRectMake(0, 0, 320, 44);
    navigationBarBgView = [[UIImageView alloc]initWithFrame:viewFrame];
    navigationBarBgView.userInteractionEnabled = YES;
    [self.view addSubview:navigationBarBgView];
}

- (void)drawNavigationTitleLabel{
    CGRect labelFrame = CGRectMake(80, 0, 160, 44);
    navigationTitleLabel = [[UILabel alloc]initWithFrame:labelFrame];
    navigationTitleLabel.backgroundColor = [UIColor clearColor];
    navigationTitleLabel.font = [UIFont systemFontOfSize:20.0f];
    navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    navigationTitleLabel.textColor = [UIColor whiteColor];
    [navigationBarBgView addSubview:navigationTitleLabel];
}

- (void)drawLeftBtn{
    CGRect btnFrame = CGRectMake(10, 0, 60, 44);
    leftBtn = [[UIButton alloc]initWithFrame:btnFrame];
    leftBtn.frame = btnFrame;
    leftBtn.exclusiveTouch = YES;
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBgView addSubview:leftBtn];
}

- (void)drawRightBtn{
    CGRect btnFrame = CGRectMake(250, 0, 60, 44);
    rightBtn = [[UIButton alloc]initWithFrame:btnFrame];
    rightBtn.frame = btnFrame;
    rightBtn.exclusiveTouch = YES;
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBgView addSubview:rightBtn];
}

#pragma mark Action
- (void)leftBtnAction:(UIButton *)btn{
    
}

- (void)rightBtnAction:(UIButton *)btn{
    
}

- (void)midBtnAction:(UIButton *)btn{


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
