//
//  HB_MoreTopMemberView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/5.
//
//

#import "HB_MoreTopMemberView.h"
#import "SVProgressHUD.h"
#import "SettingInfo.h"
#import "HB_cardsDealtool.h"
#import "HB_PhoneNumModel.h"
@implementation HB_MoreTopMemberView


-(void)setdataWith:(MemberInfoResponse *)memberInfo
{
    self.contactmodel = [[HB_cardsDealtool getCardsdata] firstObject];
    if (memberInfo.memberLevel ==2) {
        self.memberLevel.image = [UIImage imageNamed:@"VIP会员"];
    }
    else if (memberInfo.memberLevel == 1)
    {
        self.memberLevel.image = [UIImage imageNamed:@"普通会员"];
    }
    
    self.nameLabel.text = [self getCloudShareName];
    self.useridLabel.text = [self getUserIdString];
    self.headerImageView.image = [self getHearderImage];
    
}
-(NSString *)getUserIdString
{
    if (!self.contactmodel) {
       return [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"];
    }
    else if (self.contactmodel.phoneArr.count>0) {
        HB_PhoneNumModel * phonemodel = self.contactmodel.phoneArr.firstObject;
        return phonemodel.phoneNum;
    }
    else
    {
        return @"";
    }
}
-(UIImage *)getHearderImage
{
    
    NSData * data = self.contactmodel.iconData_original;
    UIImage * image;
    image =[UIImage imageWithData:data];
    
    if (!image) {
        image= [UIImage resizedImageWithName:@"member默认头像"];
    }
    
    
    return image;
}
-(NSString *)getCloudShareName
{
    NSString * lastname = self.contactmodel.lastName?self.contactmodel.lastName:@"";
    NSString * firstname = self.contactmodel.firstName?self.contactmodel.firstName:@"";
    NSString * name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    if (!name.length) {
        name = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"];
    }
    
    return name;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




-(void)layoutSubviews
{
    [super layoutSubviews];
    self.registerBtn.layer.borderColor = COLOR_A.CGColor;
    if (Device_Width <= 320) {
        self.registerLeft.constant = 10;
        self.loginLeft.constant = 15;
    }
    
    
    CGRect rect = self.MycardBtn.imageView.frame;
    CGFloat btn_wi =self.MycardBtn.frame.size.width;
    CGFloat left = btn_wi - rect.origin.x-rect.size.width+5;
    if (left != 0) {
        self.MycardBtn.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, -left);
    }
    
}
- (IBAction)BtnClick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    MoreTopClickType type = (int32_t)btn.tag ;
    
    if ([self.delegate respondsToSelector:@selector(TopMemberView:BtnClick:)]) {
        [self.delegate TopMemberView:self BtnClick:type];
    }
}

-(void)updateAlertViewWithType:(moreTopGetMebInfoStatu)statu
{
    
    switch (statu) {
        case moreTopGetMebInfo_getting:
        {
            
            self.userInteractionEnabled = NO;
            self.Regetbtn.hidden = YES;
            [self ShowActivityIndicator];
            
            
        }
            break;
        case moreTopGetMebInfo_Suc:
        {
            self.userInteractionEnabled = YES;
            self.Regetbtn.hidden = YES;
            [self.activityIndicator stopAnimating];
            
        }
            break;
        case moreTopGetMebInfo_Error:
        {
            self.userInteractionEnabled = YES;
            [self.activityIndicator stopAnimating];
            [self showErrorBtn];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)ShowActivityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:_activityIndicator];
    }
    
    
    
    [_activityIndicator startAnimating];
    
}
-(void)showErrorBtn
{
    CGFloat base_w=self.frame.size.width;
    CGFloat base_h=self.frame.size.height-16;
    if (!_Regetbtn) {
        _Regetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _Regetbtn.frame = CGRectMake(0, 0, base_w, base_h);
        [_Regetbtn setTitle:@"信息获取失败,点击重试" forState:UIControlStateNormal];
        [_Regetbtn setImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
        
        _Regetbtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_Regetbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _Regetbtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        CGFloat left = _Regetbtn.frame.size.width/2-_Regetbtn.imageView.frame.origin.x-_Regetbtn.imageView.frame.size.width/2;
        _Regetbtn.imageEdgeInsets = UIEdgeInsetsMake(-16, left, 0, -left);
        
        _Regetbtn.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, _Regetbtn.imageView.frame.size.width/2);
        _Regetbtn.tag = MoreTopClick_RegetInfo;
        _Regetbtn.hidden = NO;
        [self addSubview:_Regetbtn];
        [_Regetbtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        self.Regetbtn.hidden = NO;
    }
    
}

-(void)reStepInterFaceWithloginStatu:(BOOL)loginStatu
{
    if (loginStatu) {
        self.LoginAndRegView.hidden = YES;
        self.memberLevel.hidden = NO;
        self.MycardBtn.hidden = NO;
    }
    else
    {
        self.LoginAndRegView.hidden = NO;
        self.memberLevel.hidden = YES;
        self.nameLabel.text = @"Hi,你好!";
        self.useridLabel.text = @"登录享受更多服务";
        self.headerImageView.image = [UIImage resizedImageWithName:@"member默认头像"];
        self.MycardBtn.hidden = YES;
    }
//    self.LoginAndRegView.hidden = YES;

}

- (void)dealloc {
    [_headerImageView release];
    [_nameLabel release];
    [_useridLabel release];
    [_memberLevel release];
    [_LoginAndRegView release];
    [_registerBtn release];
    [_registerBtn release];
    [_registerLeft release];
    [_loginLeft release];
    [_MycardBtn release];
    [_registerBtn release];
    [super dealloc];
}
@end
