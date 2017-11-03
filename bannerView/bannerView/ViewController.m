//
//  ViewController.m
//  bannerView
//
//  Created by neo on 2017/10/10.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"
#import "BannerModel.h"
#import "Public.h"

@interface ViewController ()
@property(nonatomic,strong)BannerView * bannerView;
@property(nonatomic,strong)NSArray * bannerModels ;
@end

@implementation ViewController

#pragma mark - ============== 懒加载 ==============
-(BannerView *)bannerView
{
    if(!_bannerView) {
        _bannerView = [BannerView bannerWithFrame:CGRectMake(0, 0,screen_width , 200) updateWithModels:self.bannerModels andTime:3] ;
        [self.view addSubview:_bannerView];
    }
    return _bannerView;
}

-(NSArray *)bannerModels
{
    if(!_bannerModels) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"BannerImage.plist" ofType:nil];
        _bannerModels = [BannerModel BannersWithPath:path];
        //
    }
    return _bannerModels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
