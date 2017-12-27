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
        
        _bannerView = [BannerView bannerWithFrame:CGRectMake(0, 20, screen_width, 200) updateWithModels:self.bannerModels andTime:3];
//        _bannerView = [BannerView bannerAutoLayoutWithModels:self.bannerModels andTime:3] ;
        [self.view addSubview:_bannerView];
//        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.mas_equalTo(20);
//            make.right.mas_equalTo(-20);
//            make.height.mas_equalTo(200);
//        }];
        
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
    UIView *view1 = [[UIView alloc]init];
//    [view1 setFrame:CGRectMake(20, 250, 200, 50)];
    [view1 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bannerView.mas_bottom).offset(200);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
