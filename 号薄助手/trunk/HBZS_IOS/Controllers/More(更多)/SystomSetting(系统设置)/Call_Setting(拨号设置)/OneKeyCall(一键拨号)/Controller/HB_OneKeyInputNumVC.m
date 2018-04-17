//
//  HB_OneKeyInputNumVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/9/2.
//
//

#import "HB_OneKeyInputNumVC.h"
#import "SettingInfo.h"
#import "HB_OneKeyCallModel.h"

@interface HB_OneKeyInputNumVC ()<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *inputTF;
@property (retain, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation HB_OneKeyInputNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_H;
    self.title=@"手动输入号码";
    //设置textfield的左侧空白视图
    UIView * leftView=[[UIView alloc]init];
    leftView.frame=CGRectMake(0, 0, 15, self.inputTF.bounds.size.height);
    self.inputTF.leftViewMode=UITextFieldViewModeAlways;
    self.inputTF.leftView=leftView;
    [leftView release];
}
- (IBAction)btnClick:(UIButton *)sender {
    [self.inputTF resignFirstResponder];
    //点击完成的时候，构造出一个Model，然后返回
    HB_OneKeyCallModel * model=[[HB_OneKeyCallModel alloc]init];
    model.keyNumber=self.keyNumber;
    model.phoneNum=self.inputTF.text;
    NSData * modelData=[NSKeyedArchiver archivedDataWithRootObject:model];
    //取出持久化存储的字典
    NSDictionary * dict=[SettingInfo getOneKeyCall];
    NSMutableDictionary * mutableDict=[NSMutableDictionary dictionaryWithDictionary:dict];
    [mutableDict setObject:modelData forKey:[NSString stringWithFormat:@"%d",self.keyNumber]];
    //重新写入，并返回
    [SettingInfo setOneKeyCall:mutableDict];
    [model release];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.inputTF resignFirstResponder];
}
- (void)dealloc {
    [_inputTF release];
    [_finishBtn release];
    [super dealloc];
}
@end
