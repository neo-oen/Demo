//
//  HB_ContactInfoPhoneCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#define Padding 15  //间距
#define Font 13  //字体大小

typedef enum {
    KCallButton=1,//打电话按钮
    KMessageButton//发短信按钮
}ButonType;

#import "HB_ContactInfoPhoneCell.h"

@interface HB_ContactInfoPhoneCell ()
/**
 *  手机号码
 */
@property(nonatomic,retain)UILabel * phoneNumberLabel;
/**
 *  “最近”
 */
@property(nonatomic,retain)UILabel *lastCallLabel;
/**
 *  号码类型
 */
@property(nonatomic,retain)UILabel *numberTypeLabel;
/**
 *  归属地
 */
@property(nonatomic,retain)UILabel *phoneAddress;




@end

@implementation HB_ContactInfoPhoneCell

-(void)dealloc{
    [_model release];
    [_phoneNumberLabel release];
    [_phoneAddress release];
    [_lastCallLabel release];
    [_messageBtn release];
    [_numberTypeLabel release];
    [_lineLabel_right release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_ContactInfoPhoneCell";
    HB_ContactInfoPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[HB_ContactInfoPhoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setupSubViews];
    }
    return cell;
}
-(void)setupSubViews{
    //1.手机号label
    _phoneNumberLabel=[[UILabel alloc]init];
    _phoneNumberLabel.textColor=COLOR_A;
    _phoneNumberLabel.font=[UIFont systemFontOfSize:Font];
    [self.contentView addSubview:_phoneNumberLabel];
    //2.“最近”
    _lastCallLabel=[[UILabel alloc]init];
    _lastCallLabel.font=[UIFont systemFontOfSize:Font];
    _lastCallLabel.text=@"最近";
    _lastCallLabel.textColor=COLOR_E;
    [self.contentView addSubview:_lastCallLabel];
    //3.号码类型
    _numberTypeLabel=[[UILabel alloc]init];
    _numberTypeLabel.textColor=COLOR_F;
    _numberTypeLabel.font=[UIFont systemFontOfSize:Font];
    [self.contentView addSubview:_numberTypeLabel];
    //4.归属地
    _phoneAddress=[[UILabel alloc]init];
    _phoneAddress.textColor=COLOR_F;
    _phoneAddress.font=[UIFont systemFontOfSize:Font];
    [self.contentView addSubview:_phoneAddress];
    //5.图标
    _iconImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_iconImageView];
    //6.发短信按钮
    _messageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_messageBtn setImage:[UIImage imageNamed:@"短信"] forState:UIControlStateNormal];
    [_messageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _messageBtn.tag=KMessageButton;
    [self.contentView addSubview:_messageBtn];
    //7.添加一个透明的遮罩层，作为响应打电话的按钮
    _callBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _callBtn.tag=KCallButton;
    [_callBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_callBtn];
    //8.底部细线right
    _lineLabel_right=[[UILabel alloc]init];
    _lineLabel_right.textColor=[UIColor clearColor];
    _lineLabel_right.backgroundColor=COLOR_H;
    [self.contentView addSubview:_lineLabel_right];
    
}
-(void)setModel:(HB_ContactInfoPhoneCellModel *)model{
    _model=[model retain];
    //1.设置号码
    _phoneNumberLabel.text=model.phoneModel.phoneNum;
    //2.设置号码类型
    _numberTypeLabel.text=model.phoneModel.phoneType;
    //3.设置归属地
    _phoneAddress.text=model.phoneModel.areaQuary;
    //4.是否显示左侧图标
    _iconImageView.image=model.icon;
    //5.是否是最近使用的号码
//    _isLastCall=model.lastCall;
}
-(void)layoutSubviews{
    //5.图标
    CGFloat iconImageView_W=20;
    CGFloat iconImageView_H=iconImageView_W;
    CGFloat iconImageView_X=Padding;
    CGFloat iconImageView_Y=self.contentView.bounds.size.height * 0.5 - iconImageView_H*0.5;
    _iconImageView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
    //1.手机号按钮
    CGFloat phoneNumberLabel_W;
    CGFloat phoneNumberLabel_H=14;
    CGFloat phoneNumberLabel_X=CGRectGetMaxX(_iconImageView.frame)+Padding;
    CGFloat phoneNumberLabel_Y=self.bounds.size.height * 0.5 - phoneNumberLabel_H -2;
    //动态计算宽度
    NSString * title=_phoneNumberLabel.text;
    NSMutableDictionary * attributeDict=[[NSMutableDictionary alloc]init];
    attributeDict[NSFontAttributeName]=[UIFont systemFontOfSize:Font];
    CGSize size = [title boundingRectWithSize:CGSizeMake(300, phoneNumberLabel_H) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
    phoneNumberLabel_W=size.width;
    _phoneNumberLabel.frame=CGRectMake(phoneNumberLabel_X, phoneNumberLabel_Y, phoneNumberLabel_W, phoneNumberLabel_H);
    //2.“最近”
    if (self.isLastCall) {
        CGFloat lastCallLabel_W=30;
        CGFloat lastCallLabel_H=phoneNumberLabel_H;
        CGFloat lastCallLabel_X=CGRectGetMaxX(_phoneNumberLabel.frame)+10;
        CGFloat lastCallLabel_Y=phoneNumberLabel_Y;
        _lastCallLabel.frame=CGRectMake(lastCallLabel_X, lastCallLabel_Y, lastCallLabel_W, lastCallLabel_H);
    }else{
        _lastCallLabel.frame=CGRectZero;
    }
    //3.号码类型
    CGFloat numberTypeLabel_W= (Font+1) * 4;//4个字
    CGFloat numberTypeLabel_H=phoneNumberLabel_H;
    CGFloat numberTypeLabel_X=phoneNumberLabel_X;
    CGFloat numberTypeLabel_Y=CGRectGetMaxY(_phoneNumberLabel.frame)+5;
    _numberTypeLabel.frame=CGRectMake(numberTypeLabel_X, numberTypeLabel_Y, numberTypeLabel_W, numberTypeLabel_H);
    //4.归属地
    CGFloat phoneAddress_W= Font * 13;//最多13个字
    CGFloat phoneAddress_H=numberTypeLabel_H;
    CGFloat phoneAddress_X=CGRectGetMaxX(_numberTypeLabel.frame)+10;
    CGFloat phoneAddress_Y=numberTypeLabel_Y;
    _phoneAddress.frame=CGRectMake(phoneAddress_X, phoneAddress_Y, phoneAddress_W, phoneAddress_H);
    //6.发短信按钮
    CGFloat messageBtn_W=40;
    CGFloat messageBtn_H=self.bounds.size.height;
    CGFloat messageBtn_X=self.bounds.size.width-Padding-messageBtn_W;
    CGFloat messageBtn_Y=self.bounds.size.height*0.5-messageBtn_H*0.5;
    _messageBtn.frame=CGRectMake(messageBtn_X, messageBtn_Y, messageBtn_W, messageBtn_H);
    //7.透明的拨号按钮遮罩层
    CGFloat callBtn_X=phoneNumberLabel_X;
    CGFloat callBtn_Y=0;
    CGFloat callBtn_W=messageBtn_X-callBtn_X-Padding;
    CGFloat callBtn_H=messageBtn_H;
    _callBtn.frame=CGRectMake(callBtn_X, callBtn_Y, callBtn_W, callBtn_H);
    //8.底部细线right
    CGFloat lineLabel_right_H=0.5;
    CGFloat lineLabel_right_X=phoneNumberLabel_X;
    CGFloat lineLabel_right_Y=self.bounds.size.height-lineLabel_right_H;
    CGFloat lineLabel_right_W=self.bounds.size.width-Padding-lineLabel_right_X;
    _lineLabel_right.frame=CGRectMake(lineLabel_right_X, lineLabel_right_Y, lineLabel_right_W, lineLabel_right_H);
}
-(void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case KCallButton:{//拨号
            if ([self.delegate respondsToSelector:@selector(contactInfoPhoneCellDidPhoneCall:)]) {
                [self.delegate contactInfoPhoneCellDidPhoneCall:self];
            }
        }break;
        case KMessageButton:{//发短信
            if ([self.delegate respondsToSelector:@selector(contactInfoPhoneCellDidSendMessage:)]) {
                [self.delegate contactInfoPhoneCellDidSendMessage:self];
            }
        }break;
        default: break;
    }
}
@end
