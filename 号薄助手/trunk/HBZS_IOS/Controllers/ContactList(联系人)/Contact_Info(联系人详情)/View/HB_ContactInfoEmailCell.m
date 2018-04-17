//
//  HB_ContactInfoEmailCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//
#define Padding 15  //间距
#define Font 13  //字体大小

#import "HB_ContactInfoEmailCell.h"

@interface HB_ContactInfoEmailCell ()
/**
 *  邮箱名字
 */
@property(nonatomic,retain)UILabel * emailAddress;
/**
 *  邮箱类型
 */
@property(nonatomic,retain)UILabel * eMailType;
/**
 *  发送邮件的透明按钮浮层
 */
@property(nonatomic,retain)UIButton *sendEmailBtn;

/**
 *  图标显示
 */
@property(nonatomic,retain)UIImageView *iconImageView;

/**
 *  底部细线right
 */
@property(nonatomic,retain)UILabel *lineLabel_right;


@end


@implementation HB_ContactInfoEmailCell

-(void)dealloc{
    [_emailAddress release];
    [_eMailType release];
    [_iconImageView release];
    [_lineLabel_right release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_ContactInfoEmailCell";
    HB_ContactInfoEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[HB_ContactInfoEmailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setupSubViews];
    }
    return cell;
}
-(void)setupSubViews{
    //1.图标
    _iconImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_iconImageView];
    //2.邮箱名字
    _emailAddress=[[UILabel alloc]init];
    _emailAddress.textColor=COLOR_A;
    _emailAddress.font=[UIFont systemFontOfSize:Font];
    [self.contentView addSubview:_emailAddress];
    //3.邮箱类型
    _eMailType=[[UILabel alloc]init];
    _eMailType.textColor=COLOR_F;
    _eMailType.font=[UIFont systemFontOfSize:Font];
    [_eMailType sizeToFit];
    [self.contentView addSubview:_eMailType];
    //4.发送邮件的透明按钮浮层
    _sendEmailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_sendEmailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_sendEmailBtn];
    //5.右侧底部细线
    _lineLabel_right=[[UILabel alloc]init];
    _lineLabel_right.textColor=[UIColor clearColor];
    _lineLabel_right.backgroundColor=COLOR_H;
    [self.contentView addSubview:_lineLabel_right];
}
-(void)setModel:(HB_ContactInfoEmailCellModel *)model{
    _model=model;
    //1.图标
    self.iconImageView.image=model.icon;
    //2.邮箱地址
    self.emailAddress.text=model.emailModel.emailAddress;
    //3.类型
    self.eMailType.text=model.emailModel.emailType;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //1.图标
    CGFloat iconImageView_W=20;
    CGFloat iconImageView_H=iconImageView_W;
    CGFloat iconImageView_X=Padding;
    CGFloat iconImageView_Y=self.bounds.size.height * 0.5 - iconImageView_H*0.5;
    _iconImageView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
    //2.邮箱名字按钮
    CGFloat emailAddress_W=Font * 20;
    CGFloat emailAddress_H=14;
    CGFloat emailAddress_X=CGRectGetMaxX(_iconImageView.frame)+Padding;
    CGFloat emailAddress_Y=self.bounds.size.height * 0.5 - emailAddress_H -2;
    _emailAddress.frame=CGRectMake(emailAddress_X, emailAddress_Y, emailAddress_W, emailAddress_H);
    //3.邮箱类型
    CGFloat eMailType_W= Font * 5;//5个字
    CGFloat eMailType_H=emailAddress_H;
    CGFloat eMailType_X=emailAddress_X;
    CGFloat eMailType_Y=CGRectGetMaxY(_emailAddress.frame)+5;
    _eMailType.frame=CGRectMake(eMailType_X, eMailType_Y, eMailType_W, eMailType_H);
    //4.发送邮件的按钮的浮层
    CGFloat sendEmailBtn_X=eMailType_X;
    CGFloat sendEmailBtn_Y=0;
    CGFloat sendEmailBtn_W=SCREEN_WIDTH-sendEmailBtn_X;
    CGFloat sendEmailBtn_H=self.bounds.size.height;
    _sendEmailBtn.frame=CGRectMake(sendEmailBtn_X, sendEmailBtn_Y, sendEmailBtn_W, sendEmailBtn_H);
    //5.右侧底部细线
    CGFloat lineLabel_right_H=0.5;
    CGFloat lineLabel_right_X=emailAddress_X;
    CGFloat lineLabel_right_Y=self.bounds.size.height-lineLabel_right_H;
    CGFloat lineLabel_right_W=self.bounds.size.width-Padding-lineLabel_right_X;
    _lineLabel_right.frame=CGRectMake(lineLabel_right_X, lineLabel_right_Y, lineLabel_right_W, lineLabel_right_H);
}
/**
 *  发送邮件按钮点击
 */
-(void)btnClick:(UIButton *)btn{
    NSLog(@"点击了");
    if ([self.delegate respondsToSelector:@selector(contactInfoEmailCellDidSendEmail:)]) {
        [self.delegate contactInfoEmailCellDidSendEmail:self];
    }
}

@end
