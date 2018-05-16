//
//  SegmentView.m
//  testAPP
//
//  Created by neo on 2018/5/8.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "SegmentView.h"
#import "SegmentItemView.h"



@interface SegmentView()

@property (strong, nonatomic)  SegmentItemView *item1;
@property (strong, nonatomic)  SegmentItemView *item2;

@end


@implementation SegmentView

#pragma mark - ============== 懒加载 ==============


#pragma mark - ============== 初始化 ==============

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _item1 = [[SegmentItemView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width/2, self.frame.size.height)];
        _item2 = [[SegmentItemView alloc]initWithFrame:CGRectMake(self.frame.size.width/2, 0,self.frame.size.width/2, self.frame.size.height)];
        [self.item1 setItemWithImage:[UIImage imageNamed:@"通讯录分享管理－left"] andTitle:@"1111"];
        [self.item2 setItemWithImage:[UIImage imageNamed:@"通讯录分享管理－right"] andTitle:@"2222"];
        _selectIndex = -1;
        [self addSubview:_item1];
        [self addSubview:_item2];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _item1 = [[SegmentItemView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width/2, frame.size.height)];
        _item2 = [[SegmentItemView alloc]initWithFrame:CGRectMake(frame.size.width/2, 0,frame.size.width/2, frame.size.height)];
        [self.item1 setItemWithImage:[UIImage imageNamed:@"通讯录分享管理－left"] andTitle:@"1111"];
        [self.item2 setItemWithImage:[UIImage imageNamed:@"通讯录分享管理－right"] andTitle:@"2222"];
         _selectIndex = -1;
        [self addSubview:_item1];
        [self addSubview:_item2];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
- (void)setSelectIndex:(NSInteger)selectIndex{
    if (_selectIndex == selectIndex) {
        return;
    }
    _selectIndex = selectIndex;
    [self updateSegmentView];
    if (self.segmentViewChangeA) {
        self.segmentViewChangeA(selectIndex);
    }
    

}

-(void)updateSegmentView{
    
    if (_selectIndex) {
        
        [self.item1 setItemWithImage:[UIImage imageNamed:@"通讯录分享管理－left"] andTitleColor:[UIColor orangeColor]];
        [self.item2 setItemWithImage:[UIImage imageNamed:@"通讯录分享管理－right点击"] andTitleColor:[UIColor whiteColor]];
        
    }else{
        [self.item1 setItemWithImage:[UIImage imageNamed:@"通讯录分享管理－left点击"] andTitleColor:[UIColor whiteColor]];
        [self.item2 setItemWithImage:[UIImage imageNamed:@"通讯录分享管理－right"] andTitleColor:[UIColor orangeColor]];
        

    }
}

#pragma mark - ============== UI界面 ==============
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = touches.anyObject;
    if ([touch locationInView:self].x > (self.bounds.size.width/2) ){
        [self setSelectIndex:1];
    }else{
        [self setSelectIndex:0];
    }
    
}


#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
-(void)layoutSubviews{
    
   
    
}

@end
