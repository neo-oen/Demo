//
//  ViewController.m
//  DynamicConfigurationFile
//
//  Created by neo on 2018/6/14.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sdfs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.sdfs setText:BACKEND_URL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
