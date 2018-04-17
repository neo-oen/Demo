//
//  HB_identCallHelpVC.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 17/1/16.
//
//

#import "HB_identCallHelpVC.h"

@interface HB_identCallHelpVC ()
@property (nonatomic,retain) NSArray * arr;
@property (nonatomic,retain)UIScrollView * scrollview ;
@end

@implementation HB_identCallHelpVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (kScreenHeight > 480.0) {
        _arr= [NSArray arrayWithObjects:
                         @"引导1",
                         @"引导2",
                         @"引导3",@"引导4",nil];
    }
    else{
        _arr = [NSArray arrayWithObjects:
                         @"引导1-480",
                         @"引导2-480",
                         @"引导3-480",@"引导4-480",nil];
    }
    [self setupView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:hadShowedHeop];
}

-(void)setupView
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _scrollview.bounces = NO;
    _scrollview.pagingEnabled = YES;
    [self.view addSubview:_scrollview];
    
    
    
    [self setGuidePage];
}

- (void)setGuidePage{
    CGFloat originX = 0.0;
    
    for (int i = 0; i < _arr.count; i++) {
        CGRect imgFrame = CGRectMake(originX, 0, kScreenWidth, kScreenHeight);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:imgFrame];
        imgView.exclusiveTouch = YES;
        imgView.image = [UIImage imageNamed:[_arr objectAtIndex:i]];
        [_scrollview addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        
        if (i == 3) {
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [imgView addGestureRecognizer:tap];
            [tap release];
            
        }
        
        [imgView release];
        originX = originX + kScreenWidth;
    }
    
    _scrollview.contentSize = CGSizeMake(kScreenWidth*_arr.count, kScreenHeight);
    
}



-(void)tapAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
