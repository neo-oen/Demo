//
//  ViewController.m
//  PickerView
//
//  Created by neo on 2018/1/11.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "ViewController.h"
#import "MapShengModel.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView * pickerView;
@property(nonatomic,strong)NSArray * shengs;
@property(nonatomic,strong)MapShengModel * sheng;

@end

@implementation ViewController
#pragma mark - ============== 懒加载 ==============
-(NSArray *)shengs
{
    if(!_shengs) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"02cities.plist" ofType:nil];
        _shengs = [MapShengModel  shengsWithPath:path];
    }
    return _shengs;
}
-(UIPickerView *)pickerView
{
    if(!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self.view addSubview:_pickerView];
        [_pickerView setBackgroundColor:[UIColor redColor]];
        [_pickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSArray * arrayH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[pickerView]-10-|"
                                                                   options:NSLayoutFormatAlignAllTop
                                                                   metrics:nil
                                                                     views:@{@"pickerView":_pickerView}];
        [self.view addConstraints:arrayH];
        NSArray * arrayV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[pickerView(500)]"
                                                                   options:NSLayoutFormatAlignAllLeft
                                                                   metrics:nil
                                                                     views:@{@"pickerView":_pickerView}];
        [self.view addConstraints:arrayV];
        
    }
    return _pickerView;
}
#pragma mark - ============== 初始化 ==============


#pragma mark - ============== 接口 ==============


#pragma mark - ============== 方法 ==============


#pragma mark - ============== 代理 ==============

//dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.shengs.count;
    }else if (component ==1){
        NSInteger row = [_pickerView selectedRowInComponent:0];
        _sheng = self.shengs[row];
        return _sheng.cities.count;
    }else{
        return 0;
    }
    
}

//delegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title = @"";
    if (component ==0) {
        MapShengModel * model =  _shengs[row];
        title = model.name;
    }else if (component ==1){
//        NSInteger item = [pickerView selectedRowInComponent:0];
//        _sheng = _shengs[item];
        title = _sheng.cities[row];
    }
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component ==0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
}

#pragma mark - ============== 设置 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

