//
//  TestTouchView.m
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/26.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "TestTouchView.h"

@interface TestTouchView ()
@property(nonatomic,strong)UIView * tuView;

@end

@implementation TestTouchView



#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
-(void)pan:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint xyPoint = [panGesture translationInView:self.tuView];
    
   NSLog(@"%@",NSStringFromCGPoint(xyPoint)) ;
    
    [self.tuView setTransform:CGAffineTransformTranslate(self.tuView.transform, xyPoint.x, xyPoint.y)];
    [panGesture setTranslation:CGPointZero inView:self.tuView];
    NSLog(@"%@",NSStringFromCGRect(_tuView.frame) );
}

#pragma mark - ============== 代理 ==============
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//    return YES;
//}
#pragma mark - ============== 设置 ==============
//解析xib时候调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    return self;
}
//加载xib时候调用
-(void)awakeFromNib{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.tuView = self.subviews.lastObject;
    
    UIPanGestureRecognizer * pan  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//    pan.delegate = self;
    [self.tuView addGestureRecognizer:pan];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
