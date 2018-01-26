//
//  BannerLayout.m
//  bannerView
//
//  Created by neo on 2018/1/8.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "BannerLayout.h"

@implementation BannerLayout


#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============


#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

/**
 改变item.size，让他离中心约近越大。
1.获取移到的屏幕中心点，
 2，获取当前的attibutes
    3.计算他们与屏幕中心的距离
    4，约小，放大率就越大
    5.修改attributes
 6.返回数组
 
 @param rect 当前位置和大小
 @return 改好的atttibutes数组
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    CGFloat screenCenter = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes * attribute in attributes) {
//
        CGFloat deltaMargin = ABS(screenCenter-attribute.center.x);
//
        CGFloat scaleDelta = 2 - deltaMargin/(self.collectionView.frame.size.width/2 + attribute.size.width);
        attribute.transform = CGAffineTransformMakeScale(scaleDelta, scaleDelta);
        NSLog(@"----%@,%f,==%f",NSStringFromCGRect(attribute.frame),deltaMargin,scaleDelta);
    }

    return attributes;
    
}


/**
 当屏幕的可见范围发生变化的时候, 要重新刷新布局
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

/**
 布局刷新时调用
 调用父类，
 初始化操作
 */
-(void)prepareLayout{
    [super prepareLayout];
    
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    self.itemSize = self.collectionView.frame.size;
    // 取出collectionView的size
    CGSize collectionViewSize = self.collectionView.frame.size;
    
    // 设置item的宽高
    CGFloat itemWidth = collectionViewSize.height * 0.8;
    
    // 设置item的高度
    CGFloat itemHeight = collectionViewSize.height * 0.5;
    
    // 修改item的size
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    CGFloat sectionMargin = collectionViewSize.width/2-itemWidth/2;
    
    self.sectionInset = UIEdgeInsetsMake(0, sectionMargin, 0, sectionMargin);
    self.minimumLineSpacing = 110;
    
    
}

/**
 当手指离开时调用
 此时判断当前的哪个item靠中间的最近，就往哪个方向移到
 1.计算中心
 2.取出当前的items
 3，判断哪个靠的最近，
 4.往哪个方向移动。
 

 @param proposedContentOffset 目前的位置
 @return 最终的位置
 */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGFloat screenCenter = proposedContentOffset.x + self.collectionView.frame.size.width/2;
    CGRect rect =CGRectZero;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    CGFloat minMargin = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * attribute in attributes) {
        CGFloat deltaMargin = attribute.center.x - screenCenter;
        
        if (ABS(minMargin) > ABS(deltaMargin)) {
            
            minMargin = deltaMargin;
        }
        
    }
    return CGPointMake(proposedContentOffset.x + minMargin, proposedContentOffset.y);
}

//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
//    
//    CGFloat screenCenter = proposedContentOffset.x + self.collectionView.frame.size.width/2;
//    CGRect rect =CGRectZero;
//    rect.origin = proposedContentOffset;
//    rect.size = self.collectionView.frame.size;
//    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
//    CGFloat minMargin = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes * attribute in attributes) {
//        CGFloat deltaMargin = attribute.center.x - screenCenter;
//        
//        if (ABS(minMargin) > ABS(deltaMargin)) {
//            
//            minMargin = deltaMargin;
//        }
//        
//    }
//    return CGPointMake(proposedContentOffset.x + minMargin, proposedContentOffset.y);
//    
//}


@end
