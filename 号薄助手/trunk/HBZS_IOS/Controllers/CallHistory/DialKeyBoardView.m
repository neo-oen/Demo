//
//  DialKeyBoardView.m
//  HBZS_IOS
//
//  Created by yingxin on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialKeyBoardView.h"
#import "Public.h"


@implementation DialKeyBoardView

@synthesize dialNumberString;

@synthesize delegate  = _delegate;

@synthesize m_hidden;

@synthesize showFrame;
@synthesize hideFrame;

- (void)dealloc{
     [super dealloc];
    if (btnImagesNormal) {
        [btnImagesNormal release];
        
        btnImagesNormal = nil;
    }
  
    if (btnImagesHighlight) {
       [btnImagesHighlight release];
        
        btnImagesHighlight = nil;
    }
    
    if (dialNumberString) {
       [dialNumberString release];
        
        dialNumberString = nil;
    }
    if (numberKeyBoardView) {
        [numberKeyBoardView release];
        numberKeyBoardView  = nil;
    }
    
    
   
}

- (id)initWithShowFrame:(CGRect)sframe hideFrame:(CGRect)hframe{
  
  self = [super initWithFrame:sframe];
    
  if (self) {
    m_hidden = NO;
      
    dialNumberString = [[NSMutableString alloc] initWithCapacity:128];
      
    showFrame = sframe;
    hideFrame = hframe;
    
      self.backgroundColor  =[UIColor whiteColor];
      [self createKeyboardView];
      [self createNumberKeyboardView];
      
  }
    
  return self;
}



-(void)createNumberKeyboardView
{
    NSArray * arr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"abc",@"0",@"#", nil];
    numberKeyBoardView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 275)];
    for (int i = 0; i<12; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(i%3*Device_Width/3, i/3*55, Device_Width/3, 55);
        [button setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 9) {
            button.tag = keyBoardToabc;
            [button setTitle:[NSString stringWithFormat:@"abc"] forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        [button addTarget:self
                   action:@selector(dialButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        UIImage * image = [UIImage imageNamed:arr[i]];
        CGFloat top = image.size.height -1;
        CGFloat left = image.size.width-1;
        CGFloat bottom = image.size.height-1;
        CGFloat right = image.size.width-1;
        UIImage * newimage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
        [button setBackgroundImage:newimage forState:UIControlStateNormal];
        [numberKeyBoardView addSubview:button];
        
#pragma mark 一建拨号
        if (i<9) {
            UILongPressGestureRecognizer * oneKeyDial = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(oneKeyLongPressClick:)];
            oneKeyDial.minimumPressDuration = 0.8;
            oneKeyDial.numberOfTouchesRequired = 1;
            [button addGestureRecognizer:oneKeyDial];
            [oneKeyDial release];
        }
        
    }
    
    //拨号按键
    UIButton * dialbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dialbtn.frame = CGRectMake(Device_Width/2-70, 220+7.5, 140*RATE, 40);
    dialbtn.center = CGPointMake(Device_Width/2, dialbtn.center.y);
    dialbtn.backgroundColor = COLOR_B;
    dialbtn.layer.cornerRadius = 2;
    dialbtn.layer.masksToBounds = YES;
    UIImage * dimage =[UIImage imageNamed:@"拨号按键"];
   
    [dialbtn setImage:dimage forState:UIControlStateNormal];
    [dialbtn addTarget:self
               action:@selector(dialButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    dialbtn.tag = keyBoardDial;
    [numberKeyBoardView addSubview:dialbtn];
    
    //电话本
    UIButton * addressBook = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBook.frame = CGRectMake(35, 220+12.5, 30, 30);
    [addressBook setBackgroundImage:[UIImage imageNamed:@"号码本"] forState:UIControlStateNormal];
    addressBook.tag = keyBoardAddressBook;
    [addressBook addTarget:self
                action:@selector(dialButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
//    [numberKeyBoardView addSubview:addressBook];
    
    
    //删除按键
    UIButton * deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletebtn.frame = CGRectMake(Device_Width
                                 -65*RATE, 220+12.5, 40, 30);
    [deletebtn setImage:[UIImage imageNamed:@"删除_search"] forState:UIControlStateNormal];
    [deletebtn addTarget:self
                action:@selector(dialButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    deletebtn.tag = keyBoardDelete;
    [numberKeyBoardView addSubview:deletebtn];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDelete:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [deletebtn addGestureRecognizer:longPress];
    [longPress release];
    [self addSubview:numberKeyBoardView];
    
    
}

- (void)createKeyboardView{
    abcKeyBoardView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 220)];
    CGFloat keybtn_width = 20*RATE;
    CGFloat spacing = 10 * RATE;
    for (int i = 0; i<10; i++) {
        UIButton * numberbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        numberbutton.frame = CGRectMake(15+i*(keybtn_width+spacing), 17.5, keybtn_width, 20);
        
        [numberbutton setTitle:[NSString stringWithFormat:@"%d",(i+1)%10] forState:UIControlStateNormal];
        [numberbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [numberbutton addTarget:self
                    action:@selector(dialButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [abcKeyBoardView addSubview:numberbutton];
        
    }
    
    NSArray * abc = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
    
    for (int i = 0;i<abc.count ; i++) {
        UIButton * abcbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i<10) {
            abcbutton.frame = CGRectMake(15+i*(keybtn_width+spacing), 55+17.5, keybtn_width, 20);
        }
        else if (i<19)
        {
            abcbutton.frame = CGRectMake(30+(i-10)*(keybtn_width+spacing), 110+17.5, keybtn_width, 20);
        }
        else
        {
            abcbutton.frame = CGRectMake(60+(i-19)*(keybtn_width+spacing), 165+17.5, keybtn_width, 20);
        }
        [abcbutton setTitle:[abc objectAtIndex:i] forState:UIControlStateNormal];
        abcbutton.titleLabel.textColor = [UIColor blackColor];
        [abcbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [abcbutton addTarget:self
                    action:@selector(dialButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [abcKeyBoardView addSubview:abcbutton];
        
    }
    
    //删除按键
    UIButton * deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletebtn.frame = CGRectMake(Device_Width-45*RATE, 165+10, 40*RATE, 30);
    [deletebtn setImage:[UIImage imageNamed:@"删除_search"] forState:UIControlStateNormal];
    [deletebtn addTarget:self
                action:@selector(dialButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    deletebtn.tag = keyBoardDelete;
    [abcKeyBoardView addSubview:deletebtn];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDelete:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    [deletebtn addGestureRecognizer:longPress];
    [longPress release];
    
    //切换按键
    UIButton * toNumberkeyViewbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toNumberkeyViewbtn.frame = CGRectMake(15, 165+10, 35*RATE, 30);
    [toNumberkeyViewbtn setTitle:@"123" forState:UIControlStateNormal];
    [toNumberkeyViewbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    toNumberkeyViewbtn.tag = keyBoardToNumber;
    [toNumberkeyViewbtn addTarget:self
                  action:@selector(dialButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [abcKeyBoardView addSubview:toNumberkeyViewbtn];
    [self addSubview:abcKeyBoardView];
    
    
    abcKeyBoardView.hidden = YES; //默认
    
}

-(void)keyBoardchange
{
    CGFloat boardy = numberKeyBoardView.hidden?(showFrame.origin.y-55):(showFrame.origin.y+55);
    showFrame = CGRectMake(showFrame.origin.x, boardy, showFrame.size.width, 275);
    [self setHidden:NO animated:YES];
    numberKeyBoardView.hidden = !numberKeyBoardView.hidden;
    abcKeyBoardView.hidden = !abcKeyBoardView.hidden;
}

#pragma mark  键盘 隐藏/弹出
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated{
    
    m_hidden = hidden;
    
    if (animated)    {
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = (hidden) ? (hideFrame) : (showFrame);
        }];
    }
    else{
        self.hidden = hidden;
    }
    
    if (_delegate)
        [_delegate dialKeyBoardHided:hidden];
}

- (void)longPressDelete:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([dialNumberString length] > 0) {
            [dialNumberString deleteCharactersInRange:NSMakeRange(0, dialNumberString.length)];
        }
        
        if (_delegate)
            [_delegate dialButtonIndex:113];
    }
}

-(void)oneKeyLongPressClick:(UIGestureRecognizer*)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self.delegate OneKeyDailIndex:longPress.view.tag];
    }
    
}


#pragma mark 拨号键盘 按钮响应方法
- (void)dialButtonClicked:(id)sender{
    UIButton * button = (UIButton *)sender;
    switch (button.tag) {
        case keyBoardToNumber:
        case keyBoardToabc:
        {
            [self keyBoardchange];
        }
            break;
        case keyBoardDelete:
        {
            if (dialNumberString.length>0) {
                [dialNumberString deleteCharactersInRange:NSMakeRange(dialNumberString.length-1, 1)];
                [self.delegate dialButtonIndex:button.tag];
            }
            
        }
            break;
        case keyBoardAddressBook:
        {
            [self.delegate pushToaddressVc];
        }
            break;
        case keyBoardDial:
        {
            [self.delegate dialingClick];
        }
            break;
        default:
        {
            [dialNumberString appendString:button.titleLabel.text];
            [self.delegate dialButtonIndex:button.tag];
        }
            break;
    }
    
  }
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
