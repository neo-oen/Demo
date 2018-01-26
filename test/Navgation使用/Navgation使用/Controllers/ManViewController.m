//
//  ManViewController.m
//  Navgation使用
//
//  Created by neo on 2018/1/17.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "ManViewController.h"
#import "TableViewController.h"
#import "CellModel.h"

@interface ManViewController ()

@property(nonatomic,strong)UITextField * nameTextF;
@property(nonatomic,strong)UITextField * phoneTextF;
@property(nonatomic,strong)UIButton * addButton;

@end

@implementation ManViewController

#pragma mark - ============== 懒加载 ==============
-(UITextField *)nameTextF
{
    if(!_nameTextF) {
        _nameTextF = [[UITextField alloc] init];
        [_nameTextF setBorderStyle:UITextBorderStyleRoundedRect];
        [_nameTextF setPlaceholder:@"请输入姓名"];
        [_nameTextF setText:@"王雅强"];
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
        [_phoneTextF setText:@"1234567890"];

        
        [self.view addSubview:_phoneTextF];
    }
    return _phoneTextF;
}
-(UIButton *)addButton
{
    if(!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addButton setTitle:@"添  加" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setEnabled:NO];
        [self.view addSubview:_addButton];
    }
    return _addButton;
}
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
-(void)setNavigationItem{
    

    [self.navigationItem setTitle:@"联系人"];
    
    
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
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(self.phoneTextF.mas_bottom).mas_offset(80);
        make.size.mas_offset(CGSizeMake(200, 50));
    }];
}


-(void)addButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    TableViewController * tableViewControl = self.navigationController.viewControllers.lastObject;
    CellModel * cellModel = [[CellModel alloc]initWithName:_nameTextF.text andPhone:_phoneTextF.text];
    if (_indexPath) {
        [tableViewControl addManWithModel:cellModel andIndexPath:_indexPath];
    }else{
    [tableViewControl addManWithModel:cellModel];
    }
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange) name:UITextFieldTextDidChangeNotification object:self.nameTextF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextF];
    
}

-(void)valueChange{
    [self updateButtonState];
}

-(void)updateButtonState{
    
    [self.addButton setEnabled:(self.nameTextF.text.length>0&&self.phoneTextF.text.length>0?YES:NO)];
    
}

#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self updateView];
    [self addNotification];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self valueChange];

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
