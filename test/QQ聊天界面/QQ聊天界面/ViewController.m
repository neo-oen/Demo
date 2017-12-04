//
//  ViewController.m
//  QQ聊天界面
//
//  Created by neo on 2017/11/9.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "ViewController.h"
#import "Public.h"
#import "TableSectionModel.h"
#import "CellModel.h"

@interface ViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)TableSectionView * tableView;
@property(nonatomic,strong)UITextField * textField;

@end

@implementation ViewController
#pragma mark - ============== 懒加载 ==============
-(TableSectionView *)tableView
{
    if(!_tableView) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
        TableSectionModel * scetionModel = [TableSectionModel cellBrandWithPath:path];
        _tableView = [TableSectionView TableSectionWithFrame:CGRectMake(0, 20, screen_width, screen_height-60) withStyle:UITableViewStylePlain andModel:@[scetionModel]];
        [self.view addSubview:_tableView];
        //
    }
    return _tableView;
}

-(UITextField *)textField
{
    if(!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), screen_width, 40)];
        _textField.delegate = self;
        [self.view addSubview:_textField];
    }
    return _textField;
}


#pragma mark - ============== 开始 ==============

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField;

    
    // 添加监听，  键盘即将隐藏的时候， 调用
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillApprear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisAppear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


#pragma mark - ============== 方法 ==============
-(void)keyboardWillApprear:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    [dic[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGFloat distance = -([dic[UIKeyboardFrameBeginUserInfoKey]CGRectValue].origin.y - [dic[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y);
    
    
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey]doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0,distance);
        
    }];
    
}

-(void)keyboardWillDisAppear:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    [dic[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey]doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0,0);
        
    }];
    
    
}

-(NSString *)getcurrentTime{
    
    NSDate * currentTime = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm";
    NSString * timeString = [dateFormatter stringFromDate:currentTime];
    return timeString;
}

-(void)addDialogWithString:(NSString *)string andType:(Type)type{
    
    NSString * timeString = [self getcurrentTime];
    NSNumber * nType = [[NSNumber alloc]initWithBool:type];
    
    NSDictionary * dic = @{@"text":string,@"time":timeString,@"type":nType };
    
    NSInteger section = _tableView.models.count-1;
    TableSectionModel * sectionModel = _tableView.models[section];
    NSInteger row = sectionModel.cells.count-1;
    
    CellModel * lastCellModel = sectionModel.cells[row];
    
    //BOOL timeHidden = [ dict[@"time"] isEqualToString:previousCellModel.time];
    NSString * lastTimeString = lastCellModel.time.length >6 ? [lastCellModel.time substringWithRange:NSMakeRange(3, 5)] : lastCellModel.time;
    BOOL hiddenTime = [lastTimeString isEqualToString:timeString];
    CellModel * cellModel = [CellModel cellWithDict:dic andHiddenTime:hiddenTime];
    
    [_tableView addTableSectionCellWithModel:cellModel];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
    [_tableView.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];

    
}
#pragma mark - ============== 代理 ==============



/**
1.取消第一相应
2.添加一条
3.自动回复
4.清空，_textField
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [self addDialogWithString:textField.text andType:1];
    [self addDialogWithString:@"你傻逼" andType:0];

    [_textField setText:@""];
    
    return YES;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
