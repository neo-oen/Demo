//
//  HB_NewFeedBackVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/6.
//
//

#import "HB_NewFeedBackVC.h"
#import "Public.h"

@interface HB_NewFeedBackVC ()<UITextViewDelegate>
/**
 *  系统版本
 */
@property(nonatomic,retain)UILabel *deviceSystem;
/**
 *  设备型号
 */
@property(nonatomic,retain)UILabel *deviceName;
/**
 *  客户端版本
 */
@property(nonatomic,retain)UILabel *appVersion;
/**
 *  输入框
 */
@property(nonatomic,retain)UITextView *contentTextView;
/**
 *  字符计数
 */
@property(nonatomic,retain)UILabel *countOfCharacter;
/**
 *  导航栏右侧提交item
 */
@property(nonatomic,retain)UIBarButtonItem *submitItem;
/**
 *  导航栏右侧提交按钮
 */
@property(nonatomic,retain)UIButton *submitBtn;

@end

@implementation HB_NewFeedBackVC

#pragma mark -  life cycle
-(void)dealloc{
    //去除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    //释放对象
    [_deviceSystem release];
    [_deviceName release];
    [_appVersion release];
    [_contentTextView release];
    [_countOfCharacter release];
    [_submitItem release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"撰写意见";
    //注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //添加子控件
    [self.view addSubview:self.deviceSystem];
    [self.view addSubview:self.deviceName];
    [self.view addSubview:self.appVersion];
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.countOfCharacter];
    self.navigationItem.rightBarButtonItem=self.submitItem;
    //初始化子控件的frame
    [self initSubviewFrame];
}
#pragma mark - event response
-(void)submitBtnClick:(UIButton *)btn{
#warning 提交反馈代码
}
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/**
 *  键盘frame改变的监听事件
 */
-(void)keyboardFrameWillChange:(NSNotification *)notification{
    NSDictionary *infoDict = notification.userInfo;
    
    CGRect frameBegin = [infoDict[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [infoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (frameBegin.origin.y > frameEnd.origin.y) {
        //判断键盘是否遮挡了textView，如果遮挡了，就要缩短textView
        if (CGRectGetMaxY(self.countOfCharacter.frame) + 15 +64 > frameEnd.origin.y) {//遮挡了
            CGRect originalFrame = self.contentTextView.frame;
            self.contentTextView.frame=CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, frameEnd.origin.y - 15 -64 - originalFrame.origin.y );
            self.countOfCharacter.frame=CGRectMake(originalFrame.origin.x, CGRectGetMaxY(self.contentTextView.frame)+5, originalFrame.size.width, 10);
        }
    }else{
        CGRect originalFrame = self.contentTextView.frame;
        self.contentTextView.frame=CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, 280);
        self.countOfCharacter.frame=CGRectMake(originalFrame.origin.x, CGRectGetMaxY(self.contentTextView.frame)+5, originalFrame.size.width, 10);
    }
}
#pragma mark - uitextView delegate
-(void)textViewDidChange:(UITextView *)textView{
    //根据输入的字数，改边右下角字数统计
    self.countOfCharacter.text=[NSString stringWithFormat:@"%d/200",textView.text.length];
    if (textView.text.length > 200) {
        self.countOfCharacter.textColor=[UIColor redColor];
    }else{
        self.countOfCharacter.textColor=COLOR_F;
    }
    //改变完成按钮的状态
    self.submitItem.enabled = textView.text.length>0?YES:NO ;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //无论何时，都允许删除
    if (text.length == 0) {
        return YES;
    }
    //超出200不允许添加
    return textView.text.length <= 200 ;
}
#pragma mark - private methods
/**
 *  初始化子控件的frame
 */
-(void)initSubviewFrame{
    CGFloat deviceSystem_X=15;
    CGFloat deviceSystem_W=SCREEN_WIDTH-2*deviceSystem_X;
    CGFloat deviceSystem_H=20;
    CGFloat deviceSystem_Y=10;
    //设备系统
    self.deviceSystem.frame=CGRectMake(deviceSystem_X, deviceSystem_Y, deviceSystem_W, deviceSystem_H);
    //设备型号
    self.deviceName.frame=CGRectMake(deviceSystem_X, CGRectGetMaxY(self.deviceSystem.frame), deviceSystem_W, deviceSystem_H);
    //客户端版本
    self.appVersion.frame=CGRectMake(deviceSystem_X, CGRectGetMaxY(self.deviceName.frame), deviceSystem_W, deviceSystem_H);
    //输入框
    self.contentTextView.frame=CGRectMake(deviceSystem_X, CGRectGetMaxY(self.appVersion.frame)+15, deviceSystem_W, 280);
    //字数统计
    self.countOfCharacter.frame=CGRectMake(deviceSystem_X, CGRectGetMaxY(self.contentTextView.frame)+5, deviceSystem_W, 10);
}
#pragma mark - setter and getter
-(UILabel *)deviceSystem{
    if (!_deviceSystem) {
        _deviceSystem=[[UILabel alloc]init];
        _deviceSystem.textColor=COLOR_D;
        _deviceSystem.font=[UIFont systemFontOfSize:13];
        _deviceSystem.text=[NSString stringWithFormat:@"手机系统：iOS %@",[Public getSysVersion]];
    }
    return _deviceSystem;
}
-(UILabel *)deviceName{
    if (!_deviceName) {
        _deviceName=[[UILabel alloc]init];
        _deviceName.textColor=COLOR_D;
        _deviceName.font=[UIFont systemFontOfSize:13];
        _deviceName.text=[NSString stringWithFormat:@"手机型号：%@",[Public getDeviceVersion]];
    }
    return _deviceName;
}
-(UILabel *)appVersion{
    if (!_appVersion) {
        _appVersion=[[UILabel alloc]init];
        _appVersion.textColor=COLOR_D;
        _appVersion.font=[UIFont systemFontOfSize:13];
        //项目信息字典
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _appVersion.text=[NSString stringWithFormat:@"客户端版本号：%@",app_Version];
    }
    return _appVersion;
}
-(UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView=[[UITextView alloc]init];
        _contentTextView.backgroundColor=[UIColor clearColor];
        _contentTextView.layer.borderWidth=1;
        _contentTextView.font=[UIFont systemFontOfSize:13];
        _contentTextView.textColor=COLOR_D;
        _contentTextView.layer.borderColor=[COLOR_H CGColor];
        _contentTextView.layer.cornerRadius=5;
        _contentTextView.delegate=self;
    }
    return _contentTextView;
}
-(UILabel *)countOfCharacter{
    if (!_countOfCharacter) {
        _countOfCharacter=[[UILabel alloc]init];
        _countOfCharacter.textColor=COLOR_F;
        _countOfCharacter.font=[UIFont systemFontOfSize:10];
        _countOfCharacter.textAlignment=NSTextAlignmentRight;
        _countOfCharacter.text=@"0/200";
    }
    return _countOfCharacter;
}
-(UIBarButtonItem *)submitItem{
    if (!_submitItem) {
        _submitItem=[[UIBarButtonItem alloc]initWithCustomView:self.submitBtn];
        _submitItem.enabled=NO;
    }
    return _submitItem;
}
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.bounds=CGRectMake(0, 0, 30, 44);
        _submitBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_submitBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
