//
//  SwipLockView.m
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/28.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "SwipLockView.h"

@interface SwipLockView ()

@property(nonatomic,strong)NSMutableArray * selectButtons;
@property(nonatomic,assign)CGPoint presentPoint;

@end

@implementation SwipLockView

#pragma mark - ============== 懒加载 ==============
-(NSMutableArray *)selectButtons
{
    if(!_selectButtons) {
        _selectButtons = [NSMutableArray array];
    
    }
    return _selectButtons;
}
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============

-(void)addButtons{
    
    for (int i= 0; i<9; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        [button setUserInteractionEnabled:NO];
        [button setTag:i];
        [self addSubview:button];
    }
    
}

-(void)initSelectButtons{
    
    for (UIButton * button in self.selectButtons) {
        [button setSelected:NO];
    }
    [self.selectButtons removeAllObjects];
}

-(CGPoint )getLocaPoint:(NSSet<UITouch *> *)touches{
    UITouch * touch = [touches anyObject];
    CGPoint locPoint = [touch locationInView:self];
    return locPoint;
}

-(void)setButtonSelect:(CGPoint)point{
    
    for (UIButton * button in self.subviews ) {
        if (CGRectContainsPoint(button.frame, point)&& button.selected==NO) {
            [button setSelected:YES];
            [self.selectButtons addObject:button];
        }
    }
   
}

#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

-(void)layoutSubviews{
    [super layoutSubviews];

    CGFloat width = 80;
    CGFloat height = 80;
    CGFloat margin = (self.frame.size.width - 3 * width)/4;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *button = self.subviews[i];
        
       CGFloat col = i % 3;
       CGFloat row = i / 3;
       CGFloat btnX = margin + (margin + width) * col;
       CGFloat  btnY = (margin + height) * row;
        
        button.frame = CGRectMake(btnX, btnY, width, height);
        
    }
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addButtons];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];

    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //获取选中的button， 找到他们的中心， 开始连线 渲染
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path setLineWidth:10];
    [[UIColor redColor]set];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    
    if (!self.selectButtons.count) {
        return;
    }
    
    for (int i=0;i<self.selectButtons.count;i++) {
        
        UIButton * button = self.selectButtons[i];
        if (i==0) {
            
            [path moveToPoint:button.center];
        }else{
            [path addLineToPoint:button.center];
        }
        
    }
    
    [path addLineToPoint:self.presentPoint];
    
    [path stroke];
    
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取点，判断是否在圈内，在的话，就变成选中
    

    CGPoint locPoint = [self getLocaPoint:touches];
    
    
    [self setButtonSelect:locPoint];
    
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.presentPoint = [self getLocaPoint:touches];
    
    [self setButtonSelect:self.presentPoint];
    
    [self setNeedsDisplay];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    NSString * number = [NSString string];
    for (UIButton * button in self.selectButtons) {
        
        number = [NSString stringWithFormat:@"%@,%@",number,@(button.tag)];
    }
    
    NSLog(@"%@",number);
    
    [self initSelectButtons];
    [self setNeedsDisplay];
    
}

@end
