//
//  HB_ShareListView.m
//  testAPP
//
//  Created by neo on 2018/5/16.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "HB_ShareListView.h"
#import "ShareContactTableView.h"
#import "NoShareListTV.h"


@interface HB_ShareListView()

@property(nonatomic,strong)ShareContactTableView * myShareListTV;
@property(nonatomic,strong)ShareContactTableView * toMyShareListTV;
@property(nonatomic,strong)NoShareListTV * noShareListTV;
@property(nonatomic,assign)ShareListViewType shareListType;

@end



@implementation HB_ShareListView


#pragma mark - ============== 懒加载 ==============

-(NoShareListTV *)noShareListTV
{
    if(!_noShareListTV) {
        
        _noShareListTV = [[NSBundle mainBundle] loadNibNamed:@"NoShareListTV" owner:self options:nil].lastObject;
        [_noShareListTV setFrame:self.bounds];
        
        [self addSubview:_noShareListTV];
        [_noShareListTV setHidden:NO];
    }
    return _noShareListTV;
}
-(ShareContactTableView *)myShareListTV
{
    if(!_myShareListTV) {
        _myShareListTV = [[ShareContactTableView alloc] initWithFrame:self.bounds];
        [self addSubview:_myShareListTV];
        [_myShareListTV setHidden:YES];
        _myShareListTV.tag = 1;
    }
    return _myShareListTV;
}

-(ShareContactTableView *)toMyShareListTV
{
    if(!_toMyShareListTV) {
        _toMyShareListTV = [[ShareContactTableView alloc] initWithFrame:self.bounds];
        [self addSubview:_toMyShareListTV];
        [_toMyShareListTV setHidden:YES];
         _toMyShareListTV.tag = 2;
    }
    return _toMyShareListTV;
}

#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============

/* 2传递给ShareListView 相应的页面
 1根据相应的页面和，传值的数量，隐藏显示相应转场相应界面
 2根据传值，显示相应的结果*/


/**
 设置SharelistView展示
    1.判断是否是没值界面。
    2.判断是那种ShareListView
    3.传值

 @param list TableView数据源
 @param listType 判断是那个tableview
 */
-(void)setShareListViewWith:(NSArray *)list andViewType:(ShareListViewType)listType{
    
    if (!list.count) {
        [self setShowSharelist:self.noShareListTV];
        [self.noShareListTV setNameLabelText:listType];
    }else{
        if (listType == myShareListViewType) {
             [self.myShareListTV setModels:list];
            [self setShowSharelist:self.myShareListTV];
           
        }else{
            [self.toMyShareListTV setModels:list];
            [self setShowSharelist:self.toMyShareListTV];
            
            
        }
    }
    
    
    
}



-(void)setShareListViewWith:(NSArray *)list andViewType:(ShareListViewType)listType withFirstBCA:(FirstButtonClickAction)first withSecondBCA:(FirstButtonClickAction)second withSendOtherBCA:(FirstButtonClickAction)send withAccessorViewBCA:(AccessorViewClickAction)accessor{
    
    if (!list.count) {
        [self setShowSharelist:self.noShareListTV];
        [self.noShareListTV setNameLabelText:listType];
    }else{
        if (listType == myShareListViewType) {
            [self.myShareListTV setModels:list];
            [self.myShareListTV setCellActionWithFirstBCA:first withSecondBCA:second withSendOtherBCA:send withAccessorViewBCA:accessor];
            
            [self setShowSharelist:self.myShareListTV];
            
        }else{
            [self.toMyShareListTV setModels:list];
            [self.toMyShareListTV setCellActionWithFirstBCA:first withSecondBCA:second withSendOtherBCA:send withAccessorViewBCA:accessor];
            [self setShowSharelist:self.toMyShareListTV];
            
            
        }
    }
    
    
    
    
    
    
}

#pragma mark - ============== 方法 ==============

/**
 转场显示隐藏view

 @param showView 要显示的view
 */
-(void)setShowSharelist:(UIView *)showView{
    
    [UIView transitionWithView:self duration:0.7 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        for (UIView * view in self.subviews) {
            if (!(showView == view)) {
                [view setHidden:YES];
            }else{
                [view setHidden:NO];
            }
        }
    } completion:^(BOOL finished) {
        
    }];
    
//    for (UIView * view in self.subviews) {
//        if (!(showView.class == view.class)) {
//            [view setHidden:YES];
//        }else{
//            [view setHidden:NO];
//        }
//    }
    
}


#pragma mark - ============== UI界面 ==============
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
if (self) {
    [self noShareListTV];
}
return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
self = [super initWithFrame:frame];
if (self) {
    [self noShareListTV];
}
return self;
}



@end


