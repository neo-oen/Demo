//
//  MessageDetailVC.m
//  HBZS_IOS
//
//  Created by zimbean on 14-6-24.
//
//

#import "MessageDetailVC.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+TitleView.h"
#import <CoreText/CoreText.h>
#import "NSMutableAttributedString+CalculateTextSize.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "SettingInfo.h"
#import "Reachability.h"
@interface MessageDetailVC ()

@end

@implementation MessageDetailVC

@synthesize sysMsg;

- (void)dealloc{
    if (sysMsg) {
        [sysMsg release];
    }
    [titleImgView release];
    [firstImgView release];
    [secondImgView release];
    [thirdImgView release];
    [contentLabel release];
    [detailScrollView release];
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

- (id)initWithMessage:(NewMessage *)msg{
    self = [super init];
    
    if (self) {
        self.sysMsg = msg;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setVCTitle:sysMsg.title];
    
    [self drawScrollView];
    
    [self drawIconImgView];
    
    [self drawContentLabel];
    
    [self drawdetailImageViews];
   
    [self drawDetailBtn];
    
    [self setMessageToRead];
   	// Do any additional setup after loading the view.
}
-(void)drawdetailImageViews
{
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    if (([wifi currentReachabilityStatus] == NotReachable)||[SettingInfo getIsShowPicInWifi])
    {
        // == NotReachable无wifi  != NotReachable 有WiFi
        UIAlertView * al = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您已开启仅WiFi下显示图片，可以前往设置中更改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [al show];
        return;
    }
    if (sysMsg.imgContentUrl1.length == 0) {
        detailScrollView.contentSize = CGSizeMake(320, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5);
    }
    else if(sysMsg.imgContentUrl2.length == 0){
        [self drawFirstImgView];
        
        detailScrollView.contentSize = CGSizeMake(320, firstImgView.frame.origin.y + firstImgView.frame.size.height + 5);
    }
    else if(sysMsg.imgContentUrl3.length == 0){
        [self drawFirstImgView];
        [self drawSecondImgView];
        
        detailScrollView.contentSize = CGSizeMake(320, secondImgView.frame.origin.y + secondImgView.frame.size.height + 5);
    }
    else{
        [self drawFirstImgView];
        [self drawSecondImgView];
        [self drawThirdImgView];
        
        
        detailScrollView.contentSize = CGSizeMake(320.0, thirdImgView.frame.origin.y + thirdImgView.frame.size.height + 10);
    }
}
#pragma mark 修改消息已读状态
-(void)setMessageToRead
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MessageCenter.db"];
    FMDatabase * db = [[FMDatabase alloc]initWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    BOOL isSuccess = [db executeUpdate:@"update NewMessage set isRead = 1 where jobServerId=?",[NSString stringWithFormat:@"%d",self.sysMsg.jobServerId]];
    
    
    if (!isSuccess) {
        NSLog(@"upata faild");
    }
    [db close];
}

#pragma mark Drawing
- (void)drawScrollView{
    detailScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - kNavigationBarHeight - kStatuBarHeight)];
    detailScrollView.backgroundColor = [UIColor clearColor];
    detailScrollView.showsHorizontalScrollIndicator = NO;
    detailScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:detailScrollView];
}

- (void)drawIconImgView{
    if (sysMsg.imgTitleUrl.length > 0) {
        titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 300, 201)];
        [titleImgView setImageWithURL:[NSURL URLWithString:sysMsg.imgTitleUrl]];
        [detailScrollView addSubview:titleImgView];
    }
}

- (void)drawContentLabel{
    contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.numberOfLines = 0;
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc]initWithString:sysMsg.content];
    CGSize textSize =  [contentAttributedString sizeWithFontName:@"Helvetica" fontSize:16.0 constrainedToSize:CGSizeMake(300, 1000)];
    contentLabel.frame = CGRectMake(10,
                                    titleImgView.frame.origin.y + titleImgView.frame.size.height + 4,
                                    300,
                                   textSize.height);
    
    contentLabel.attributedText = contentAttributedString;
    [detailScrollView addSubview:contentLabel];
    
    [contentAttributedString release];
}

- (void)drawFirstImgView{
    firstImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5, 300, 201)];
    firstImgView.contentMode = UIViewContentModeScaleAspectFit;
    [firstImgView setImageWithURL:[NSURL URLWithString:sysMsg.imgContentUrl1] placeholderImage:UIImageWithName(@"placeholder.png")];
    [detailScrollView addSubview:firstImgView];

}

- (void)drawSecondImgView{
    secondImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, firstImgView.frame.origin.y + firstImgView.frame.size.height + 5, 300, 201)];
    secondImgView.contentMode = UIViewContentModeScaleAspectFit;
    [secondImgView setImageWithURL:[NSURL URLWithString:sysMsg.imgContentUrl2]];
    [detailScrollView addSubview:secondImgView];

}

- (void)drawThirdImgView{
    thirdImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, secondImgView.frame.origin.y + secondImgView.frame.size.height + 5, 300, 201)];
    thirdImgView.contentMode = UIViewContentModeScaleAspectFit;
    [thirdImgView setImageWithURL:[NSURL URLWithString:sysMsg.imgContentUrl3]];
    [detailScrollView addSubview:thirdImgView];
}

- (void)drawImgView{
    
    



}

- (void)drawDetailBtn{
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(20, self.view.frame.size.height - kStatuBarHeight - kNavigationBarHeight - 60, 280, 45);
    [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(detailBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn setBackgroundColor:[self colorWithHexString:@"#20B2AA"]];//#20B2AA PRESSS #1E90FF
    detailBtn.layer.cornerRadius = 3.0f;
    
    [self.view addSubview:detailBtn];
    [self.view bringSubviewToFront:detailBtn];
    if (sysMsg.urlDetail.length == 0) {
        detailBtn.hidden = YES;
    }
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark Action

- (void)detailBtnAction{
    UIApplication *app = [UIApplication sharedApplication];
    
    NSURL *url = [NSURL URLWithString:sysMsg.urlDetail];
    
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
    else
    {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"暂时没有详情" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
