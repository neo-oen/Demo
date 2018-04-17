//
//  HB_OneKeyCallVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/31.
//
//

#import "HB_OneKeyCallVC.h"
#import "HB_OneKeyCallVIew.h"
#import "SettingInfo.h"
#import "HB_OneKeySelectContactListVC.h"//所有联系人的列表
#import "HB_OneKeyInputNumVC.h"

@interface HB_OneKeyCallVC ()<HB_OneKeyCallVIewDelegate,UIActionSheetDelegate>
/**
 *  导航栏右侧编辑按钮
 */
@property(nonatomic,retain)UIButton * editBtn;
/**
 *  当前选中的view的tag值
 */
@property(nonatomic,assign)NSInteger currentViewTag;


@end

@implementation HB_OneKeyCallVC
-(void)dealloc{
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupInterface];
    [self hiddenTabBar];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupAllCellView];
    NSDictionary * dict = [SettingInfo getOneKeyCall];
    if (dict.allKeys.count) {
        self.editBtn.enabled=YES;
    }else{
        self.editBtn.enabled=NO;
    }
}
/**
 *  设置导航栏
 */
-(void)setupNavigationBar{
    //设置标题
    self.title=@"一键拨号设置";
    //右侧编辑按钮
    UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(0, 0, 44, 20)];
    editBtn.exclusiveTouch = YES;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [editBtn setTitleColor:COLOR_I forState:UIControlStateNormal];
    [editBtn setTitleColor:COLOR_F forState:UIControlStateSelected];
    UIBarButtonItem * editBtnItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    editBtn.tag=10;
    self.editBtn=editBtn;
    self.navigationItem.rightBarButtonItem=editBtnItem;
    [editBtnItem release];
}
-(void)editBtnClick:(UIButton *)btn{
    //状态取反
    self.editBtn.selected=!self.editBtn.selected;
    //刷新界面
    [self setupAllCellView];
}
#pragma mark - 界面
/**
 *  设置界面
 */
-(void)setupInterface{
    //制造每一个cell视图
    for (int i=0; i<9; i++) {
        HB_OneKeyCallVIew * view=[[HB_OneKeyCallVIew alloc]init];
//        if (i!=0) {
            view.delegate=self;
//        }
        CGFloat view_W=90;
        CGFloat view_H=110;
        CGFloat padding_X=(SCREEN_WIDTH-view_W*3)/4.0f;
        CGFloat view_X=(view_W+padding_X)*(i%3)+padding_X;
        CGFloat view_Y=view_H*(i/3);
        view.frame=CGRectMake(view_X, view_Y, view_W, view_H);
        view.tag=100+i;
        [self.view addSubview:view];
        [view release];
    }
}
/**
 *  设置每一个小的cell的显示内容
 */
-(void)setupAllCellView{
    NSDictionary * dict = [SettingInfo getOneKeyCall];
    for (int i=0; i<=9; i++) {
        HB_OneKeyCallVIew * view=(HB_OneKeyCallVIew *)[self.view viewWithTag:99+i];
        view.keyNumber=i;
        view.editStatus=NO;
//        if (i==1) {//按键“1”，默认语音信箱
//            HB_OneKeyCallModel * model=[[HB_OneKeyCallModel alloc]init];
//            model.keyNumber=1;
//            model.name=@"语音信箱";
//            view.model=model;
//            [model release];
//        }else{
            NSData * modelData=[dict objectForKey:[NSString stringWithFormat:@"%d",i]];
            if (modelData) {
                view.editStatus=self.editBtn.selected;
                HB_OneKeyCallModel * model=[NSKeyedUnarchiver unarchiveObjectWithData:modelData];
                view.model=model;
            }else{
                view.model=nil;
//            }
            
        }
        [view layoutSubviews];
    }
}
#pragma mark - view的代理方法
-(void)oneKeyCallView:(HB_OneKeyCallVIew *)view addContactBtnClick:(UIButton *)btn{
    _currentViewTag=btn.superview.tag;
    UIActionSheet * sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从联系人中选择",@"手动输入号码", nil];
    [sheet showInView:self.view];
    [sheet release];
}
-(void)oneKeyCallView:(HB_OneKeyCallVIew *)view deleteContactBtnClick:(UIButton *)btn{
    //获取存储的一键拨号字典
    NSDictionary * dict = [SettingInfo getOneKeyCall];
    //删除key值对应的信息
    NSString * keyStr=[NSString stringWithFormat:@"%ld",view.tag-99];
    NSMutableDictionary * mutableDict=[dict mutableCopy];
    [mutableDict removeObjectForKey:keyStr];
    //重新存储字典
    [SettingInfo setOneKeyCall:mutableDict];
    [mutableDict release];
    //刷新
    [self setupAllCellView];
}
#pragma mark - actionSheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{//从联系人中选择
            HB_OneKeySelectContactListVC * vc=[[HB_OneKeySelectContactListVC alloc]init];
            vc.keyNumber=_currentViewTag+1 - 100;//例如：按键“2”对应的tag值为“101”
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }break;
        case 1:{//手动输入号码
            HB_OneKeyInputNumVC * vc=[[HB_OneKeyInputNumVC alloc]init];
            vc.keyNumber=_currentViewTag+1 - 100;//同上
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }break;
            
        default:
        break;
    }
}

@end
