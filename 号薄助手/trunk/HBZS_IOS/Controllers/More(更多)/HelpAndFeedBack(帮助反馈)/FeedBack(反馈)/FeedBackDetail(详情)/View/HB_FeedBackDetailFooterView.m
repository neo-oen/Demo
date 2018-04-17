//
//  HB_FeedBackDetailFooterView.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#define Padding 15.0f //间距

#import "HB_FeedBackDetailFooterView.h"

/**
 满意度评价按钮tag值
 */
typedef enum {
    KEvaluateBtnTypeVeryGood = 100,//非常满意
    KEvaluateBtnTypeGoog ,//满意
    KEvaluateBtnTypeNormal ,//一般
    KEvaluateBtnTypeShit//不满意
}EvaluateBtnType;

@interface HB_FeedBackDetailFooterView ()<UITextViewDelegate>
/** ‘满意度评价’提示语 */
@property(nonatomic,retain)UILabel *evaluateHint;
/** 满意度评价 按钮组合视图 */
@property(nonatomic,retain)UIView *evaluateView;
/** ‘问题补充’提示语 */
@property(nonatomic,retain)UILabel *supplyHint;
/** 输入框底部字数统计 */
@property(nonatomic,retain)UILabel *countOfChar;

@end

@implementation HB_FeedBackDetailFooterView

-(void)dealloc{
    [_evaluateHint release];
    [_evaluateView release];
    [_supplyHint release];
    [_textView release];
    [_countOfChar release];
    [super dealloc];
}
- (void)drawRect:(CGRect)rect {
    [self addSubview:self.evaluateHint];
    [self addSubview:self.evaluateView];
    [self addSubview:self.supplyHint];
    [self addSubview:self.textView];
    [self addSubview:self.countOfChar];
    //设置frame
    CGFloat evaluateHint_X=Padding;
    CGFloat evaluateHint_Y=Padding;
    CGFloat evaluateHint_W=SCREEN_WIDTH - 2*Padding;
    CGFloat evaluateHint_H=20;
    self.evaluateHint.frame=CGRectMake(evaluateHint_X, evaluateHint_Y, evaluateHint_W, evaluateHint_H);
    self.evaluateView.frame=CGRectMake(evaluateHint_X, CGRectGetMaxY(self.evaluateHint.frame)+Padding, evaluateHint_W, 35);
    self.supplyHint.frame=CGRectMake(evaluateHint_X, CGRectGetMaxY(self.evaluateView.frame)+Padding*2, evaluateHint_W, evaluateHint_H);
    self.textView.frame=CGRectMake(evaluateHint_X, CGRectGetMaxY(self.supplyHint.frame)+Padding, evaluateHint_W, 180);
    self.countOfChar.frame=CGRectMake(evaluateHint_X, CGRectGetMaxY(self.textView.frame), evaluateHint_W, evaluateHint_H);
}
-(instancetype)init{
    if (self=[super init]) {
        self.clipsToBounds=YES;
    }
    return self;
}
#pragma mark - event response
-(void)btnClick:(UIButton *)btn{
    btn.selected=YES;
    btn.backgroundColor=COLOR_A;
    self.evaluateView.userInteractionEnabled=NO;
#warning 在这里发送请求给服务器
    
}
#pragma mark - public methods
-(BOOL)textViewIsNull{
    //根据颜色，判断是否是用户输入的值
    return !CGColorEqualToColor(self.textView.textColor.CGColor, COLOR_D.CGColor);
}
#pragma mark - textView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (CGColorEqualToColor(textView.textColor.CGColor, COLOR_H.CGColor)) {
        textView.text = nil;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (CGColorEqualToColor(textView.textColor.CGColor, COLOR_H.CGColor)) {
        textView.text = @"请在这里补充问题（127字以内）";
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    self.countOfChar.text = [NSString stringWithFormat:@"%d/127",textView.text.length];
    if (textView.text.length < 127) {
        self.countOfChar.textColor=COLOR_F;
    }else{
        self.countOfChar.textColor=[UIColor redColor];
    }
    if (textView.text.length == 0) {
        textView.textColor=COLOR_H;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length) {
        //表示正在输入
        textView.textColor=COLOR_D;
        return textView.text.length + text.length <= 127 ? YES:NO;
    }else{
        return YES;
    }
}
#pragma mark - setter and getter
-(UILabel *)evaluateHint{
    if (!_evaluateHint) {
        _evaluateHint=[[UILabel alloc]init];
        _evaluateHint.textColor=COLOR_D;
        _evaluateHint.font=[UIFont systemFontOfSize:14];
        _evaluateHint.text=@"满意度评价";
    }
    return _evaluateHint;
}
-(UIView *)evaluateView{
    if (!_evaluateView) {
        _evaluateView=[[UIView alloc]init];
        //添加4个按钮
        NSArray *titleArr=@[@"非常满意",@"满意",@"一般",@"不满意"];
        for (int i=0; i<4; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn setTitleColor:COLOR_D forState:UIControlStateNormal];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=KEvaluateBtnTypeVeryGood+i;
            btn.layer.borderWidth=1;
            btn.layer.borderColor=COLOR_F.CGColor;
            btn.layer.cornerRadius=5;
            CGFloat btn_W = ( SCREEN_WIDTH - 5 * Padding ) / 4 ;
            CGFloat btn_H = 35;
            CGFloat btn_X = (btn_W + Padding) * i;
            CGFloat btn_Y = 0;
            btn.frame=CGRectMake(btn_X, btn_Y, btn_W, btn_H);
            [_evaluateView addSubview:btn];
        }
    }
    return _evaluateView;
}
-(UILabel *)supplyHint{
    if (!_supplyHint) {
        _supplyHint=[[UILabel alloc]init];
        _supplyHint.textColor=COLOR_D;
        _supplyHint.font=[UIFont systemFontOfSize:14];
        _supplyHint.text=@"您可以对问题进行补充";
    }
    return _supplyHint;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView=[[UITextView alloc]init];
        _textView.textColor=COLOR_H;
        _textView.delegate=self;
        _textView.font=[UIFont systemFontOfSize:14];
        _textView.layer.borderColor=COLOR_F.CGColor;
        _textView.layer.borderWidth=1;
        _textView.layer.cornerRadius=5;
        _textView.text=@"请在这里补充问题（127字以内）";
    }
    return _textView;
}
-(UILabel *)countOfChar{
    if (!_countOfChar) {
        _countOfChar=[[UILabel alloc]init];
        _countOfChar.textColor=COLOR_F;
        _countOfChar.font=[UIFont systemFontOfSize:10];
        _countOfChar.textAlignment=NSTextAlignmentRight;
        _countOfChar.text=@"0/127";
    }
    return _countOfChar;
}
-(void)setEvaluateNumber:(NSUInteger)evaluateNumber{
    switch (evaluateNumber) {
        case 1:{
        
        }break;
        case 2:{
            
        }break;
        case 3:{
            
        }break;
        case 4:{
            
        }break;
        default: break;
    }
}
@end
