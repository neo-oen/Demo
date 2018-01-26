//
//  BascViewController.m
//  Navgation使用
//
//  Created by neo on 2018/1/16.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "BascViewController.h"
#import "TableViewController.h"



@interface BascViewController ()

@property(nonatomic,strong)UITextField * nameTextF;
@property(nonatomic,strong)UITextField * passWordTextF;
@property(nonatomic,strong)UILabel * rememberPassWordLabel;
@property(nonatomic,strong)UILabel * autoLoginLabel;
@property(nonatomic,strong)UISwitch * rememberPassWordSwitch;
@property(nonatomic,strong)UISwitch * autoLoginSwitch;
@property(nonatomic,strong)UIButton * loginButton;


@end

@implementation BascViewController

#pragma mark - ============== 懒加载 ==============
-(UITextField *)nameTextF
{
    if(!_nameTextF) {
        _nameTextF = [[UITextField alloc] init];
        [_nameTextF setBorderStyle:UITextBorderStyleRoundedRect];
        [_nameTextF setPlaceholder:@"请输入用户名"];
        [self.view addSubview:_nameTextF];
    }
    return _nameTextF;
}
-(UITextField *)passWordTextF
{
    if(!_passWordTextF) {
        _passWordTextF = [[UITextField alloc] init];
        [_passWordTextF setBorderStyle:UITextBorderStyleRoundedRect];
        [_passWordTextF setPlaceholder:@"请输入密码"];
        [_passWordTextF setSecureTextEntry:YES];
        
        [self.view addSubview:_passWordTextF];
    }
    return _passWordTextF;
}
-(UILabel *)rememberPassWordLabel
{
    if(!_rememberPassWordLabel) {
        _rememberPassWordLabel = [[UILabel alloc] init];
        [_rememberPassWordLabel setText:@"记住密码"];
        [self.view addSubview:_rememberPassWordLabel];
    }
    return _rememberPassWordLabel;
}
-(UILabel *)autoLoginLabel
{
    if(!_autoLoginLabel) {
        _autoLoginLabel = [[UILabel alloc] init];
        [_autoLoginLabel setText:@"自动登录"];

        [self.view addSubview:_autoLoginLabel];
    }
    return _autoLoginLabel;
}
-(UISwitch *)rememberPassWordSwitch
{
    if(!_rememberPassWordSwitch) {
        _rememberPassWordSwitch = [[UISwitch alloc] init];
        [_rememberPassWordSwitch setOn:YES];
        [_rememberPassWordSwitch addTarget:self action:@selector(rememberPassWordSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_rememberPassWordSwitch];
    }
    return _rememberPassWordSwitch;
}
-(UISwitch *)autoLoginSwitch
{
    if(!_autoLoginSwitch) {
        _autoLoginSwitch = [[UISwitch alloc] init];
        [_autoLoginSwitch setOn:YES];
        [_autoLoginSwitch addTarget:self action:@selector(autoLoginSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_autoLoginSwitch];
    }
    return _autoLoginSwitch;
}
-(UIButton *)loginButton
{
    if(!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setEnabled:NO];
        [self.view addSubview:_loginButton];
    }
    return _loginButton;
}
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============

/**
 更新布局
 */
-(void)updateView{
    
    [self.nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_offset(30);
        make.height.mas_offset(40);
    }];
    
    [self.passWordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.nameTextF);
        make.top.mas_equalTo(self.nameTextF.mas_bottom).mas_offset(20);
    }];
    
    [self.rememberPassWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.nameTextF);
        make.top.mas_equalTo(self.passWordTextF.mas_bottom).mas_offset(20);
        make.width.mas_offset(80);
        
    }];
    
    [self.rememberPassWordSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rememberPassWordLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.rememberPassWordLabel);
    }];
    
    [self.autoLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.rememberPassWordLabel);
        make.right.mas_equalTo(self.autoLoginSwitch.mas_left).mas_equalTo(-10);
    }];
    
    [self.autoLoginSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.mas_equalTo(self.rememberPassWordSwitch);
        make.right.mas_equalTo(self.passWordTextF);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        make.size.mas_offset(CGSizeMake(200, 50));
    }];
}

-(void)loginButtonClick{
//    self.loginButton.isFirstResponder;
    
    [self.passWordTextF endEditing:YES];
    [DKProgressHUD showLoadingWithStatus:@"正在加载中" toView:self.navigationController.view]  ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [DKProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        if ([self nameAndPassWordsIsTure]) {
         
            TableViewController * viewControll = [[TableViewController alloc]init];
            [viewControll setName:self.nameTextF.text];
            [self.navigationController pushViewController:viewControll animated:YES];
            [self setUserDefaultsTFData];
        }else{
            [DKProgressHUD showInfoWithStatus:@"对不起,您输入的应户名或密码有误!" toView:self.navigationController.view];
        }
        
    });
   
   
}
-(BOOL)nameAndPassWordsIsTure{
    
    
    return [self.nameTextF.text isEqualToString:@"123"]&&[self.passWordTextF.text isEqualToString:@"123"]?YES:NO;
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange) name:UITextFieldTextDidChangeNotification object:self.nameTextF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange) name:UITextFieldTextDidChangeNotification object:self.passWordTextF];
    
}

-(void)valueChange{
    [self updateButtonState];
}

-(void)updateButtonState{
    
    [self.loginButton setEnabled:(self.nameTextF.text.length>0&&self.passWordTextF.text.length>0?YES:NO)];
    
}
-(void)rememberPassWordSwitchClick:(UISwitch *)uiSwitch{
    if (self.rememberPassWordSwitch.isOn == NO) {
        [self.autoLoginSwitch setOn:NO animated:YES];
        [self deletePassWordUserDefaults];
    }
    [self setUserDefaultsSwitch];
}

-(void)autoLoginSwitchClick:(UISwitch *)uiSwitch{
    if (self.autoLoginSwitch.isOn) {
        [self.rememberPassWordSwitch setOn:YES animated:YES];
    }
    
    [self setUserDefaultsSwitch];

}

/**
 1.获取userDefaults
 2.加载数据。
    2.1判断是不是第一次进入
    2.2第一次时某些属性不被设置，变更第一次状态，
    2.3第二次的就加载某些属性
 */
-(void)getUserDefaultsAndSetView{

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.nameTextF setText:[userDefaults stringForKey:@"name"]];
    [self.passWordTextF setText:[userDefaults stringForKey:@"passWord"]];
    
    if ([userDefaults boolForKey:@"isTwes"]) {
        [self.rememberPassWordSwitch setOn: [userDefaults boolForKey:@"isRememberPassWord"]];
        [self.autoLoginSwitch setOn:[userDefaults boolForKey:@"isAutoLogin"]];
        if (self.autoLoginSwitch.isOn) {
            [self loginButtonClick];
        }
    }else{
        [userDefaults setBool:YES forKey:@"isTwes"];
    }
    
   

}

-(void)setUserDefaultsSwitch{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.rememberPassWordSwitch.isOn forKey:@"isRememberPassWord"];
    [userDefaults setBool:self.autoLoginSwitch.isOn forKey:@"isAutoLogin"];
    
}
-(void)deletePassWordUserDefaults{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:@"passWord"];
}

-(void)setUserDefaultsTFData{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.nameTextF.text forKey:@"name"];
    [userDefaults setObject:self.passWordTextF.text forKey:@"passWord"];

}

#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

/**
 1.设置navigation
 2.布局视图。
 3.添加通知
 4.设置本地存储属性。
 5.手动调用某些状态和方法
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通讯录"];
    [self updateView];
    [self addNotification];
    [self getUserDefaultsAndSetView];
    [self updateButtonState];
    [self setUserDefaultsSwitch];
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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

