//
//  HB_OneKeyCallVIew.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/31.
//
//

#import "HB_OneKeyCallVIew.h"

@interface HB_OneKeyCallVIew ()
/**
 *  头像按钮
 */
@property(nonatomic,retain)UIButton * iconBtn;
/**
 *  姓名label
 */
@property(nonatomic,retain)UILabel *nameLabel;
/**
 *  电话号码label
 */
@property(nonatomic,retain)UILabel *phoneNumLabel;
/**
 *  右上角删除小按钮
 */
@property(nonatomic,retain)UIButton *deleteBtn;

@end

@implementation HB_OneKeyCallVIew

-(void)dealloc{
    [_nameLabel release];
    [_phoneNumLabel release];
    [_model release];
    [super dealloc];
}
-(instancetype)init{
    if (self=[super init]) {
        [self setupSubViews];
    }
    return self;
}
/**
 *  添加子控件
 */
-(void)setupSubViews{
    //头像
    UIButton * iconBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.layer.masksToBounds=YES;
    iconBtn.backgroundColor=COLOR_H;
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"添加icon"] forState:UIControlStateNormal];
    [iconBtn setTitleColor:COLOR_B forState:UIControlStateNormal];
    iconBtn.adjustsImageWhenHighlighted=NO;
    [iconBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.iconBtn=iconBtn;
    [self addSubview:iconBtn];
    //名字
    UILabel * nameLabel=[[UILabel alloc]init];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=[UIFont systemFontOfSize:12];
    nameLabel.textColor=COLOR_D;
    self.nameLabel=nameLabel;
    [self addSubview:nameLabel];
    [nameLabel release];
    //电话
    UILabel * phoneNumLabel=[[UILabel alloc]init];
    phoneNumLabel.textAlignment=NSTextAlignmentCenter;
    phoneNumLabel.font=[UIFont systemFontOfSize:12];
    phoneNumLabel.textColor=COLOR_D;
    self.phoneNumLabel=phoneNumLabel;
    [self addSubview:phoneNumLabel];
    [phoneNumLabel release];
    //删除按钮
    UIButton * deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn=deleteBtn;
    [self addSubview:deleteBtn];
}
-(void)setModel:(HB_OneKeyCallModel *)model{
    _model=[model retain];
    //头像
    if (model==nil) {
        [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"添加icon"] forState:UIControlStateNormal];
        [self.iconBtn setTitle:nil forState:UIControlStateNormal];
        self.phoneNumLabel.text=nil;
        return;
    }
    [self.iconBtn setTitle:[NSString stringWithFormat:@"%d",model.keyNumber] forState:UIControlStateNormal];
    if (model.keyNumber==1) {
        [self.iconBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        if (model.iconData_thumbnail) {
            [self.iconBtn setBackgroundImage:[UIImage imageWithData:model.iconData_thumbnail] forState:UIControlStateNormal];
        }else{
            [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"默认联系人头像"] forState:UIControlStateNormal];
        }
    }
    //名字
    if (model.name) {
        self.nameLabel.text=model.name;
    }
    //电话
    if (model.phoneNum) {
        self.phoneNumLabel.text=model.phoneNum;
    }
}
/**
 *  设置对应的数字
 */
-(void)setKeyNumber:(NSInteger)keyNumber{
    _keyNumber=keyNumber;
    self.nameLabel.text=[NSString stringWithFormat:@"%d",keyNumber];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //头像
    CGFloat iconBtn_W=50;
    CGFloat iconBtn_H=iconBtn_W;
    CGFloat iconBtn_X=(self.bounds.size.width-iconBtn_W)*0.5;
    CGFloat iconBtn_Y=20;
    self.iconBtn.frame=CGRectMake(iconBtn_X, iconBtn_Y, iconBtn_W, iconBtn_H);
    self.iconBtn.layer.cornerRadius=iconBtn_W*0.5;
    //名字
    CGFloat nameLabel_W=self.bounds.size.width;
    CGFloat nameLabel_H=15;
    CGFloat nameLabel_X=0;
    CGFloat nameLabel_Y=CGRectGetMaxY(self.iconBtn.frame);
    self.nameLabel.frame=CGRectMake(nameLabel_X, nameLabel_Y, nameLabel_W, nameLabel_H);
    if (self.model) {
        //1.当有模型的时候
        if (self.model.name) {
            //1-1.有名字则nameLabel显示
        }else{
            //1-2.没有名字，则不显示
            self.nameLabel.frame=CGRectZero;
        }
    }else{
        //2.没有模型对象，则需要显示：按键数字
    }
    //电话
    CGFloat phoneLabel_W=self.bounds.size.width;
    CGFloat phoneLabel_H=15;
    CGFloat phoneLabel_X=0;
    CGFloat phoneLabel_Y;
    if (self.nameLabel.frame.origin.y>0) {
        phoneLabel_Y=CGRectGetMaxY(self.nameLabel.frame);
    }else{
        phoneLabel_Y=CGRectGetMaxY(self.iconBtn.frame);
    }
    self.phoneNumLabel.frame=CGRectMake(phoneLabel_X, phoneLabel_Y, phoneLabel_W, phoneLabel_H);
    //删除按钮
    if (self.isEditStatus) {
        CGFloat deleBtn_W=20;
        CGFloat deleBtn_H=deleBtn_W;
        CGFloat deleBtn_X=CGRectGetMaxX(self.iconBtn.frame)-deleBtn_W*0.5;
        CGFloat deleBtn_Y=iconBtn_Y-deleBtn_H*0.5;
        self.deleteBtn.frame=CGRectMake(deleBtn_X, deleBtn_Y, deleBtn_W, deleBtn_H);
    }else{
        self.deleteBtn.frame=CGRectZero;
    }
}
#pragma mark - 点击事件
-(void)btnClick:(UIButton *)btn{
    if (btn==self.iconBtn) {
        if ([self.delegate respondsToSelector:@selector(oneKeyCallView:addContactBtnClick:)]) {
            [self.delegate oneKeyCallView:self addContactBtnClick:btn];
        }
    }else if(btn==self.deleteBtn){
        if ([self.delegate respondsToSelector:@selector(oneKeyCallView:deleteContactBtnClick:)]) {
            [self.delegate oneKeyCallView:self deleteContactBtnClick:btn];
        }
    }
}


@end
