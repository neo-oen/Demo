//
//  ViewController1.m
//  主流框架SB
//
//  Created by neo on 2018/1/26.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "ViewController1.h"
#import "TestView.h"
#import "TestView2.h"

@interface ViewController1 ()
@property (weak, nonatomic) IBOutlet TestView *textView;
@property (weak, nonatomic) IBOutlet TestView2 *textView2;

@end

@implementation ViewController1

#pragma mark - ============== 懒加载 ==============

#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
- (IBAction)buttonClick:(UIButton *)sender {
    _textView.transform = CGAffineTransformMakeScale(2, 1);
    
    
}
- (IBAction)sliderSlid:(UISlider *)sender {
    
    _textView.radian = sender.value * 2 * M_PI;
    
    _textView2.radian = sender.value * 2 * M_PI;
}
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button;
    [button sizeToFit];
    // Do any additional setup after loading the view.
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

+(void)load{
    
}
+(void)initialize{
    
}

@end
