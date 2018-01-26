//
//  BannerView.m
//  bannerView
//
//  Created by neo on 2017/10/10.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "BannerView.h"
#import "BannerModel.h"

#import "BannerCell.h"
#import "BannerLayout.h"

#import "Masonry.h"

#import "Public.h"


static NSString * identifier = @"collectionCell";
@interface BannerView()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,weak)UIScrollView * scrollView;
@property(nonatomic,weak)UIPageControl * pageControl;
@property(nonatomic,strong)NSTimer * time;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIButton * previousButton;
@property(nonatomic,strong)UIButton * nextButton;

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
-(UICollectionView *)collectionView
{
    if(!_collectionView) {
        BannerLayout * flowLayout = [[BannerLayout alloc]init];
//        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[BannerCell class] forCellWithReuseIdentifier:identifier];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];

        [self addSubview:_collectionView];
    }
    return _collectionView;
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
-(UIButton *)previousButton
{
    if(!_previousButton) {
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_previousButton setBackgroundColor:[UIColor blueColor]];
        _previousButton.tag = 1;
        [_previousButton addTarget:self action:@selector(buttonClick:)  forControlEvents:UIControlEventTouchUpInside];

        
        [self addSubview: _previousButton];
//        [_previousButton setFrame:CGRectMake(0, 0, 30, 100)];
        
        [_previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(30);
        }];
    }
    return _previousButton;
}

-(UIButton *)nextButton
{
    if(!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_nextButton setBackgroundColor:[UIColor redColor]];
        _nextButton.tag = 0;
        [_nextButton addTarget:self action:@selector(buttonClick:)  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: _nextButton];
//        [_nextButton setFrame:CGRectMake(300, 0, 30, 120)];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(30);
        }];

    }
    return _nextButton;
}



#pragma mark - ============== 初始化 ==============

/**
 初始化view
 */

+ (BannerView *)bannerWithFrame:(CGRect)frame updateWithModels:(NSArray *)models andTime:(NSInteger)time andBannerViewStyle:(UIBannerViewStyle)style{
    BannerView * bannerView = [[self alloc]initWithFrame:frame];
    bannerView.style = style;
    bannerView.timeInt = time;
    [bannerView updateBannerViewWith:models];
    return bannerView;
}

+(BannerView *)bannerAutoLayoutWithModels:(NSArray *)models andTime:(NSInteger)time andBannerViewStyle:(UIBannerViewStyle)style{
    BannerView * bannerView = [[self alloc]init];
    bannerView.style = style;
    bannerView.timeInt = time;
    bannerView.models = models;
    return bannerView;
}

#pragma mark - ============== 更新视图 ==============
/**
 根据资源，更新View
 
 @param models 资源
 */
- (void)updateBannerViewWith:(NSArray *)models {
    
    NSInteger sWidth = self.frame.size.width;
    NSInteger sHeight = self.frame.size.height;
    
    if (_style == UIBannerViewStyleScrollView) {
        //scrollView
        for (int i=0; i<models.count; i++) {
            BannerModel * model = models[i];
            UIImage * image = [UIImage imageNamed:model.icon];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(sWidth * i, 0, sWidth, sHeight)];
            [imageView setImage:image];
            [self.scrollView addSubview:imageView];
        }
        [self.scrollView setContentSize:CGSizeMake(sWidth * models.count, sHeight)];
        
    }else if (_style == UIBannerViewStyleCollection){
        self.collectionView;
        
        
    }
    
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

-(BOOL)changePictureWithChangeType:(ChangeType)type{
    
    NSInteger change = type == NextChange?1:-1;
    UICollectionViewFlowLayout * flowLayout = self.collectionView.collectionViewLayout;
    CGFloat sWidth = flowLayout.itemSize.width + flowLayout.minimumLineSpacing;
    NSInteger item = (self.collectionView.contentOffset.x + sWidth * change)/sWidth ;
    if (item == -1) {
        item = _models.count-1;
    }else if (item == _models.count){
        item = 0;
    }
    NSIndexPath * path = [NSIndexPath indexPathForItem:item inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self.pageControl setCurrentPage: item];
    return YES;
}

#pragma mark - ============== 方法 ==============

-(void)changeNextPicture{
    
    if (_style == UIBannerViewStyleScrollView) {
        //scrollView
        
        NSInteger sWidth = self.scrollView.frame.size.width;
        NSInteger setWidth = (_scrollView.contentOffset.x + sWidth)>=_scrollView.contentSize.width ? 0: _scrollView.contentOffset.x + sWidth;
        
        [self.scrollView setContentOffset:CGPointMake(setWidth, 0)  animated:YES];
        [self.pageControl setCurrentPage: setWidth/sWidth];
       
        
    }else if (_style == UIBannerViewStyleCollection){
        
        UICollectionViewFlowLayout * flowLayout = self.collectionView.collectionViewLayout;
        CGFloat sWidth = flowLayout.itemSize.width;
        NSInteger item = (self.collectionView.contentOffset.x + sWidth +110)/(sWidth +110);
        item = item == _models.count?0:item;
        NSIndexPath * path = [NSIndexPath indexPathForItem:item inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

        [self.pageControl setCurrentPage: item ];
        
    }

}

-(void)buttonClick:(UIButton *)button{
        [self changePictureWithChangeType:button.tag];
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

//collectionDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _models.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath ];
    cell.model = _models[indexPath.row];
    [cell setBackgroundColor:[UIColor redColor]];
    return cell;
    
}




#pragma mark - ============== 设置 ==============

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self updateBannerViewWith:_models];
    self.previousButton;
    self.nextButton;


    
}

@end




