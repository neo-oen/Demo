//
//  HB_HeaderIconView.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/8.
//
//

#import "HB_HeaderIconView.h"
#import "HB_ContactDataTool.h"//联系人工具类
#import <AssetsLibrary/AssetsLibrary.h>//判断相册权限
#import "HB_ContactInfoVC.h"
#import "HB_ContactDetailController.h"

#import "GetContactAdProto.pb.h"//联系人背景模型解析proto类


#import "SettingInfo.h"
#import "UIImageView+WebCache.h"


@implementation HB_HeaderIconView

- (void)dealloc {
    [_iconImageView release];
    [_editIconBtn release];
    [_contactModel release];
    [super dealloc];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpInterface];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //bgimageView
    _bgImageView.frame = self.bounds;
    //1.imageView
    _iconImageView.frame=CGRectMake(SCREEN_WIDTH/2-41, 64+20, 82, 82);
    //2.编辑按钮
//    _editIconBtn.center=CGPointMake(self.bounds.size.width*0.5, 64+(self.bounds.size.height-64)*0.5);
    _editIconBtn.center = _iconImageView.center;
    //名字
    CGFloat IconBottom_Y = _iconImageView.frame.origin.y+_iconImageView.frame.size.height;
    _nameLabel.frame = CGRectMake(0, IconBottom_Y+14, SCREEN_WIDTH, 20);
    
    //职务
    CGFloat nameBottom_Y = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
    _jobLabel.frame = CGRectMake(0, nameBottom_Y + 14, SCREEN_WIDTH, 13);
    
    //公司
    CGFloat jobBottom_Y = _jobLabel.frame.origin.y + _jobLabel.frame.size.height;
    _companyLabel.frame = CGRectMake(0, jobBottom_Y + 7, SCREEN_WIDTH, 13);
    
    
}
-(void)setContactModel:(HB_ContactModel *)contactModel{
    if (_contactModel != contactModel) {
        [_contactModel release];
        _contactModel=[contactModel retain];
    }
    
    
    
    
    //设置头像图片
    NSData *iconImageData = _contactModel.iconData_original;
    UIImage *iconImage=nil;
    if (iconImageData) {//如果有头像就显示，没有就显示其它
        iconImage=[UIImage imageWithData:iconImageData];
        _iconImageView.image=iconImage;
        if ([self.delegate isKindOfClass:[HB_ContactInfoVC class]]) {
            _editIconBtn.hidden = YES;
        }
    }else{
#warning 无头像时候需要显示其它
        _iconImageView.image=[UIImage imageNamed:@"默认联系人头像"];
        
    }
    
    if ([self.delegate isKindOfClass:[HB_ContactDetailController class]]) {
        self.nameLabel.hidden = YES;
        self.jobLabel.hidden = YES;
        self.companyLabel.hidden = YES;
        
        return;
    }
    
    //名字
    NSString * lastname = _contactModel.lastName;
    NSString * firstname = _contactModel.firstName;
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@",lastname.length?lastname:@"",firstname.length?firstname:@""];
    //职位
    self.jobLabel.text = _contactModel.jobTitle;
    //公司
    self.companyLabel.text = _contactModel.organization;
    
    //联系人背景广告图设置
    BOOL isShowContactBg;
    if ([SettingInfo getIsShowContactBg]) {
        if ([SettingInfo getIsShowPicInWifiContactSetting]) {
            Reachability *wifi = [Reachability reachabilityForLocalWiFi];
            
            isShowContactBg = ([wifi currentReachabilityStatus] != NotReachable)?YES:NO;
            
        }
        else isShowContactBg = YES;
    }
    else
    {
        isShowContactBg = NO;
    }
    
    if (isShowContactBg == NO) {
        return ; //当设置为不显示联系人背景的时候直接return 下列不执行
    }
    
    ConfigMgr * mgr = [ConfigMgr getInstance];
    GetContactAdResponse * LocalContactAd = [GetContactAdResponse parseFromData:[mgr getValueForKey:@"ContactAdResponsedata" forDomain:nil]];
    if (LocalContactAd.jobServerId!=0)
    {
        [self.bgImageView setImageWithURL:[NSURL URLWithString:LocalContactAd.contactAd.imgUrl] placeholderImage:[UIImage imageNamed:@"nav_bg"]];
        
    }
    
    
    
}

-(void)setBgimageindex:(NSInteger)bgimageindex
{
    _bgimageindex = bgimageindex;
    //背景图
    self.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg%ld",bgimageindex]];
}
/**
 *  初始化界面
 */
-(void)setUpInterface{
    
    _bgImageView=[[UIImageView alloc]init];
    _bgImageView.userInteractionEnabled=YES;
    _bgImageView.clipsToBounds=YES;
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_bgImageView];
    
    //1.添加imageview
    _iconImageView=[[UIImageView alloc]init];
    _iconImageView.userInteractionEnabled=YES;
    _iconImageView.clipsToBounds=YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    /*圆角*/
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 41;
    /*边框*/
    _iconImageView.layer.borderWidth = 2;
    _iconImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    /*默认头像*/
    _iconImageView.image = [UIImage imageNamed:@"默认联系人头像"];
    [self addSubview:_iconImageView];
    
    
    //2.添加编辑按钮
    _editIconBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_editIconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editIconBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _editIconBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [_editIconBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat editBtn_W=60;
    CGFloat editBtn_H=30;
    _editIconBtn.bounds=CGRectMake(0, 0,editBtn_W, editBtn_H);
    [self addSubview:_editIconBtn];
    
    //名字
    _nameLabel  = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_nameLabel];
    
    //职务;
    _jobLabel = [[UILabel alloc] init];
    _jobLabel.textAlignment = NSTextAlignmentCenter;
    _jobLabel.textColor = [UIColor whiteColor];
    [self addSubview:_jobLabel];
    
    //公司
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textAlignment = NSTextAlignmentCenter;
    _companyLabel.textColor = [UIColor whiteColor];
    [self addSubview:_companyLabel];

}
/**
 *  编辑头像按钮点击
 */
- (void)editBtnClick:(UIButton *)sender {
    if ([self.delegate isKindOfClass:[HB_ContactInfoVC class]]) {
        [self.delegate headerIconViewbInfoBtnClick:self];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(headerIconViewbInfoBtnClick:)]) {
            [self.delegate headerIconViewbInfoBtnClick:self];
        }
        
        UIActionSheet * sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取",@"删除头像", nil];
        [sheet showInView:self];
        [sheet release];
    }
}
#pragma mark - actionSheet的协议方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//拍照
        //请求权限
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {//允许
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self openCamera];
                });
            }else{
                
            }
        }];
        //判断相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus==AVAuthorizationStatusDenied){
            //弹框提示
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"授权提示" message:@"因权限限制,需要进入\"系统设置->隐私->相机\"开启号簿助手的权限许可后才能使用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }else if (buttonIndex==1){//相册选取
        //获取相册权限
        ALAssetsLibrary * assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                [self openPhotoLibrary];
            }
            *stop=YES;
        } failureBlock:^(NSError *error) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"授权提示" message:@"因权限限制,需要进入\"系统设置->隐私->照片\"开启号簿助手的权限许可后才能使用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }];
        [assetsLibrary release];
    }
    else if (buttonIndex == 2)
    {
        _iconImageView.image = [UIImage imageNamed:@"默认联系人头像"];
        [self.delegate headerIconViewDeleteIcon:self];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self openPhotoLibrary];
    }
}
#pragma mark - 打开相机、相册
-(void)openCamera{
    if ([self.delegate respondsToSelector:@selector(headerIconViewDidOpenCamera:)]) {
        [self.delegate headerIconViewDidOpenCamera:self];
    }
}
-(void)openPhotoLibrary{
    if ([self.delegate respondsToSelector:@selector(headerIconViewDidOpenLibrary:)]) {
        [self.delegate headerIconViewDidOpenLibrary:self];
    }
}
#pragma mark -


@end
