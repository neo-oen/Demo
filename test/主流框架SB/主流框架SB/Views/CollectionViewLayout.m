//
//  CollectionViewLayout.m
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/28.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout

#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

//-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return [super layoutAttributesForItemAtIndexPath:indexPath];
//    
//    
//    
//    
//    
//}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
  //判断每个的下坐标，与那个可移到的50的距离
    //如果大于他，开始形变
    // Cy/50约大，东西约小
    
    CGFloat margin = 50;
    
    CGFloat zhuY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height-margin;
    
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes * attribute in attributes) {
        
        CGFloat Cy = attribute.frame.origin.y + attribute.frame.size.height - zhuY ;
        if (Cy> 0) {
            CGFloat xiShuScale = 1-ABS(Cy)/margin;
            CGFloat xiShuTrans = (ABS(Cy)/(margin-5))* (self.collectionView.center.x-attribute.center.x);
//            attribute.transform = CGAffineTransformMakeScale(xiShuScale, xiShuScale);
            attribute.transform = CGAffineTransformMake(xiShuScale, 0, 0, xiShuScale, xiShuTrans, 0);
//            Translation(xiShuTrans, 0);

        }
        
    }
    
  
    return attributes;

}

//可见范围发生变化的时候, 刷新布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//刷新布局
-(void)prepareLayout{
    [super prepareLayout];
    
    [self setSectionInset:UIEdgeInsetsMake(5, 10, 20, 30)];
    [self setMinimumLineSpacing:10];
    [self setMinimumInteritemSpacing:5];
    [self setItemSize:CGSizeMake(80, 80)];
    
}

//- (CGSize)collectionViewContentSize {
//    
//    // 从数组中获取最大Y值
//    
////    CGFloat maxY = 0;
////    
////    maxY = [self.MinArray[0] doubleValue];
////    
////    for (int i = 1; i < _Column; i++) {
////        
////        CGFloat arrayValue = [self.MinArray[i] doubleValue];
////        
////        if (maxY < arrayValue) {
////            
////            maxY = arrayValue;
////            
////        }
////    }
//    return CGSizeMake(0, MAXFLOAT);
//}
@end
