//
//  BannerView.m
//  bannerView
//
//  Created by neo on 2017/10/10.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "BannerView.h"
#import "BannerModel.h"
#import "Public.h"



@interface BannerView()<UIScrollViewDelegate>

@property(nonatomic,weak)UIScrollView * scrollView;
@property(nonatomic,weak)UIPageControl * pageControl;
@property(nonatomic,strong)NSTimer * time;

@end

@implementation BannerView

#pragma mark - ============== 懒加载 ==============
-(UIScrollView *)scrollView
{
    if(!_scrollView) {
        UIScrollView * sce = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView = sce;
        [_scrollView setPagingEnabled:YES];
        [_scrollView setDelegate:self];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
    }
    return _scrollView;
}

-(UIPageControl *)pageControl
{
    if(!_pageControl) {
        UIPageControl *dss = [[UIPageControl alloc] init];
        _pageControl = dss;
        [_pageControl setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height * 0.9)];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl setCurrentPage:0];
        [self addSubview:_pageControl];
        
    }
    return _pageControl;
}



#pragma mark - ============== 初始化 ==============

/**
 初始化view
 */

+ (BannerView *)bannerWithFrame:(CGRect)frame updateWithModels:(NSArray *)models andTime:(NSInteger)time{
   
   BannerView * bannerView = [[self alloc]initWithFrame:frame];
    bannerView.timeInt = time;
    [bannerView updateBannerViewWith:models];
    return bannerView;
}



#pragma mark - ============== 更新视图 ==============
/**
 根据资源，更新View
 
 @param models 资源
 */
- (void)updateBannerViewWith:(NSArray *)models {
    _models = models;
    NSInteger sWidth = self.scrollView.frame.size.width;
    NSInteger sHeight = self.scrollView.frame.size.height;
    //scrollView
    for (int i=0; i<models.count; i++) {
        BannerModel * model = models[i];
        UIImage * image = [UIImage imageNamed:model.icon];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(sWidth * i, 0, sWidth, sHeight)];
        [imageView setImage:image];
        [self.scrollView addSubview:imageView];
    }
    [self.scrollView setContentSize:CGSizeMake(sWidth * models.count, sHeight)];
    
    //pageControl
    [self.pageControl setNumberOfPages:models.count];
    
    [self makeTimer];
    
}



#pragma mark - ============== 接口 ==============


/**
 接口
 
 @param title 输入的数据
 @return 返回成功与否
 */
-(BOOL)addBanner:(NSString *) title{
    
    return YES;
}


#pragma mark - ============== 方法 ==============

-(void)changeNextPicture{
    NSInteger sWidth = self.scrollView.frame.size.width;
    NSInteger setWidth = (_scrollView.contentOffset.x + sWidth)>=_scrollView.contentSize.width ? 0: _scrollView.contentOffset.x + sWidth;
    
    [self.scrollView setContentOffset:CGPointMake(setWidth, 0)  animated:YES];
    [self.pageControl setCurrentPage: setWidth/sWidth];
}
    
-(void)makeTimer{
    
        _time = [NSTimer scheduledTimerWithTimeInterval:_timeInt
                                                      target:self
                                                    selector:@selector(changeNextPicture)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_time forMode:NSRunLoopCommonModes];
}

-(void)changePageControlPageNumber{
    
    self.pageControl.currentPage = _scrollView.contentOffset.x/_scrollView.bounds.size.width;
}

#pragma mark - ============== 代理 ==============

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self changePageControlPageNumber];
}

/**
 *  当用户开始拖拽表格时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 暂停下载
    [_time invalidate];
}

/**
 *  当用户停止拖拽表格时调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 恢复下载
    [self makeTimer];
}


@end




