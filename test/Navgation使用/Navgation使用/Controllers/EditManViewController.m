//
//  EditManViewController.m
//  Navgation使用
//
//  Created by neo on 2018/1/22.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "EditManViewController.h"

#import "TableViewController.h"

@interface EditManViewController ()

@property(nonatomic,strong)UITextField * nameTextF;
@property(nonatomic,strong)UITextField * phoneTextF;
@property(nonatomic,strong)UIButton * saveButton;


@end

@implementation EditManViewController

#pragma mark - ============== 懒加载 ==============
-(UITextField *)nameTextF
{
    if(!_nameTextF) {
        _nameTextF = [[UITextField alloc] init];
        [_nameTextF setBorderStyle:UITextBorderStyleRoundedRect];
        [_nameTextF setPlaceholder:@"请输入姓名"];
        [_nameTextF setEnabled:NO];

        [self.view addSubview:_nameTextF];
    }
    return _nameTextF;
}
-(UITextField *)phoneTextF
{
    if(!_phoneTextF) {
        _phoneTextF = [[UITextField alloc] init];
        [_phoneTextF setBorderStyle:UITextBorderStyleRoundedRect];
        [_phoneTextF setPlaceholder:@"请输入电话"];
        [_phoneTextF setEnabled:NO];

        [self.view addSubview:_phoneTextF];
    }
    return _phoneTextF;
}
-(UIButton *)saveButton
{
    if(!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_saveButton setTitle:@"保  存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton setEnabled:NO];
        [_saveButton setHidden:YES];
        [self.view addSubview:_saveButton];
    }
    return _saveButton;
}
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
-(void)setNavigationItem{
    
    
    [self.navigationItem setTitle:self.model.name];
    [self.nameTextF setText:self.model.name];
    [self.phoneTextF setText:self.model.phone];
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(navigationRightEditButton)]];
   ;
}


-(void)navigationRightEditButton{
    if (self.saveButton.hidden ==YES) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        [self.nameTextF setEnabled:YES];
        [self.phoneTextF setEnabled:YES];
        [self.phoneTextF becomeFirstResponder];
        [self.saveButton setHidden:NO];

    }else{
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        [self.nameTextF setEnabled:NO];
        [self.phoneTextF setEnabled:NO];
        [self.nameTextF setText:self.model.name];
        [self.phoneTextF setText:self.model.phone];
        [self.saveButton setHidden:YES];
        [self.saveButton setEnabled:NO];
    }
    
}


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
    
    [self.phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.nameTextF);
        make.top.mas_equalTo(self.nameTextF.mas_bottom).mas_offset(20);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(self.phoneTextF.mas_bottom).mas_offset(80);
        make.size.mas_offset(CGSizeMake(200, 50));
    }];
}


-(void)saveButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    TableViewController * tableViewControl = self.navigationController.viewControllers.lastObject;
    self.model = [[CellModel alloc]initWithName:_nameTextF.text andPhone:_phoneTextF.text];
    [tableViewControl editManWithModel:self.model andIndexPath:_indexPath];
    
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange) name:UITextFieldTextDidChangeNotification object:self.nameTextF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextF];
    
}

-(void)valueChange{
    [self updateButtonState];
}

-(void)updateButtonState{
    
    [self.saveButton setEnabled:(self.nameTextF.text.length>0&&self.phoneTextF.text.length>0?YES:NO)];
    
}

#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self updateView];
    [self addNotification];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
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

