//
//  ViewController.m
//  UpDownRefurbishView
//
//  Created by neo on 2017/10/17.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "ViewController.h"
#import "UpDownRefurbishView.h"
#import "Public.h"

@interface ViewController ()
@property(nonatomic,strong)UpDownRefurbishView * upDownRefurbishV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 30,screen_width , 70)];
    [view setBackgroundColor:[UIColor redColor]];
    view.clipsToBounds = YES;
    [self.view addSubview:view];
    _upDownRefurbishV = [UpDownRefurbishView upDownRefurbishWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) WithStyle:UIUpDownRefurbishViewStyleButton withClickAction:^{
        NSLog(@"sdfs");
    }];
    [view addSubview:_upDownRefurbishV];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
