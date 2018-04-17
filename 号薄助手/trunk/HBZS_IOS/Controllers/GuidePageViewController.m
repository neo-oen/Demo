//
//  GuidePageViewController.m
//  HBZS_IOS
//
//  Created by zimbean on 14-7-18.
//
//

#import "GuidePageViewController.h"
#import "HB_WebviewCtr.h"
@interface GuidePageViewController ()<UIScrollViewDelegate,UITextViewDelegate>

@property(nonatomic,retain)UIPageControl * guidePageCtrl;

@property(nonatomic,retain)NSTimer * timerShow;

@property(nonatomic,retain)UIButton * beginbtn;

@end

@implementation GuidePageViewController

@synthesize guideScrollView;



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
    
    if (kScreenHeight > 480.0) {
        guideImgNames = [NSArray arrayWithObjects:
                @"开机流程-1",
                @"开机流程-2",
                @"开机流程-3",@"开机流程-4",nil];
    }
    else{
        guideImgNames = [NSArray arrayWithObjects:
                @"开机流程480-1",
                @"开机流程480-2",
                @"开机流程480-3",@"开机流程480-4",nil];
    }
    
    guideScrollView.bounces = NO;
    
    [self setGuidePage];
    [self creatPageContrl];
    
}



- (void)setGuidePage{
    CGFloat originX = 0.0;
    
    for (int i = 0; i < guideImgNames.count; i++) {
        CGRect imgFrame = CGRectMake(originX, 0, kScreenWidth, kScreenHeight);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:imgFrame];
//        NSString *imgPath = [[NSBundle mainBundle]pathForResource:[guideImgNames objectAtIndex:i] ofType:@"jpg"];
        imgView.exclusiveTouch = YES;
        imgView.image = [UIImage imageNamed:[guideImgNames objectAtIndex:i]];
        [guideScrollView addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        
        if (i == guideImgNames.count-1) {
            self.beginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.beginbtn.frame = CGRectMake(20, imgView.height-150, imgView.width-40, 40);
            self.beginbtn.backgroundColor = COLOR_A;
            [self.beginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.beginbtn setTitle:@"立即体验" forState:UIControlStateNormal];
            self.beginbtn.layer.cornerRadius = 8;
            [self setBeginUserInterface:YES];
            [self.beginbtn addTarget:self action:@selector(displayGuidePageFinshAction) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:self.beginbtn];
            
            [imgView addSubview: [self AgreeNoticeViewWithFrame:CGRectMake((imgView.width-310)/2, self.beginbtn.bottom + 10, 310, 56)]];
            
        }
        
        [imgView release];
        originX = originX + kScreenWidth;
    }
    
    guideScrollView.contentSize = CGSizeMake(kScreenWidth*guideImgNames.count, kScreenHeight);
    
}

-(void)creatPageContrl
{
    self.guidePageCtrl = [[UIPageControl alloc] init];
    self.guidePageCtrl.bounds = CGRectMake(0, 0, 40, 20);
    self.guidePageCtrl.center = CGPointMake(SCREEN_WIDTH/2, self.view.height-40);
    self.guidePageCtrl.numberOfPages = guideImgNames.count;
    self.guidePageCtrl.currentPage = 0;
    
    self.guidePageCtrl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.guidePageCtrl.currentPageIndicatorTintColor =COLOR_B;
    
    [self.view addSubview:self.guidePageCtrl];
}

-(UIView *)AgreeNoticeViewWithFrame:(CGRect)rect
{
    //size = 310,56
    UIView * agnview = [[[UIView alloc] initWithFrame:rect] autorelease];
    
    UIButton * agreebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreebtn.tag = 1;
    agreebtn.bounds = CGRectMake(0,0,24, 24);
    agreebtn.center = CGPointMake(12, agnview.height/2);
    [agreebtn setBackgroundImage:[UIImage imageNamed:@"声明选择框"] forState:UIControlStateNormal];
    [agreebtn setBackgroundImage:[UIImage imageNamed:@"声明同意勾选"] forState:UIControlStateSelected];
    agreebtn.selected = YES;
    [agreebtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UITextView * noticetextview = [[UITextView alloc] init];
    noticetextview.delegate = self;
    noticetextview.frame = CGRectMake(agreebtn.right, 12, 285, 36);
    noticetextview.editable = NO;
    NSString * noticyName= @"《号簿助手用户服务协议》";
    NSString * str = [NSString stringWithFormat:@"我已阅读并同意%@",noticyName];
    //attr样式
    NSMutableParagraphStyle * paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphstyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary * dic =@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphstyle};
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str] attributes:dic];
    
    [attrStr addAttributes:@{NSLinkAttributeName: @"protocol://",NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:[str rangeOfString:noticyName]];
    
    noticetextview.attributedText = attrStr;
    
    
    [agnview addSubview:agreebtn];
    [agnview addSubview:noticetextview];
    
    [noticetextview release];
    [paragraphstyle release];
    [attrStr release];
    return agnview;
}

-(void)setBeginUserInterface:(BOOL)Enabled
{
    self.beginbtn.userInteractionEnabled = Enabled;
    if (Enabled) {
        self.beginbtn.backgroundColor = COLOR_A;
    }else{
        self.beginbtn.backgroundColor = [UIColor lightGrayColor];
    }
}

-(void)btnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self setBeginUserInterface:btn.selected];
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffsetX/scrollView.width;
    self.guidePageCtrl.currentPage = page;
    
    if (page >= 3) {
        self.guidePageCtrl.hidden = YES;
    }
    else{
        self.guidePageCtrl.hidden = NO;
    }
}


- (void)displayGuidePageFinshAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidePageIsDisplayFinsh"
                                                        object:nil];
}



#pragma textviewdelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [self showUserAgreement];
    return NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


//协议说明
-(void)showUserAgreement
{

    HB_PrivacyNoticeVC * vc = [[HB_PrivacyNoticeVC alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
