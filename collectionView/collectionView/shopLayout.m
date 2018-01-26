//
//  shopLayout.m
//  collectionView
//
//  Created by neo on 2018/1/9.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "shopLayout.h"

@interface shopLayout ()

@property(nonatomic,strong)NSMutableArray * MinArray;


@end

@implementation shopLayout

#pragma mark - ============== 懒加载 ==============
-(NSMutableArray *)MinArray
{
    if(!_MinArray) {
        _MinArray = [NSMutableArray array];
        for (int i = 0; i < self.Column; i++) {
            [_MinArray addObject:@(self.sectionInset.top)];
        }
    }
    return _MinArray;
}

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
-(NSInteger)Column{
    if (_Column ==0) {
        self.Column = 3;
    }
    return _Column;
}
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============


/**
 返回属性
 默认为纵向瀑布流
 1.计算item的 x.y.w.h然后返回
    先判断，有几段 间距是多少，然后求出w
    也有可能，先判断有几段，w是多少，然后求出 间距
 
 求每一个x,和y。
    先弄一个最小的数组，
        min = array[0]
        minN = 0
    for i =1 i<geshuo
        if(min>a)
            min=a
            minN =i
 x = minN*(w+jianju)
 y = min + jinaju
 
 array[minN] = y;
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat lineSpace = self.minimumLineSpacing;
    CGFloat itemSpace = self.minimumInteritemSpacing;
    CGFloat sectionInsetLeft = self.sectionInset.left;
    CGFloat sectionInsetRight = self.sectionInset.right;
    
    CGFloat width = (self.collectionView.frame.size.width - sectionInsetLeft - sectionInsetRight-(self.Column -1) * itemSpace)/self.Column;
    
    CGFloat height = self.itemHeight(indexPath, width);
    
    //计算x和y
    CGFloat minHeight = [self.MinArray[0] doubleValue];
    NSInteger minNum = 0;
    
    for (int i = 1; i < self.Column; i++) {
        if (minHeight > [_MinArray[i] doubleValue]) {
            minHeight =  [_MinArray[i] doubleValue];
            minNum = i;
        }
    }
    CGFloat x = sectionInsetLeft + minNum * (width + itemSpace);
    //判断是否是第一行
    NSInteger oneLine = (CGFloat)(indexPath.item + 1 )/self.Column >1 ? 1:0;
    
    CGFloat y = minHeight + lineSpace * oneLine ;
    
    _MinArray[minNum] = @(y + height);
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.frame = CGRectMake(x, y , width, height);
    NSLog(@"%@",NSStringFromCGRect(attribute.frame));
    return attribute;
    
    
}

/**
 返回区域内数组
这里实现返回所有数组
 
 1.新建数组，
 2.判断有多少个数，然后遍历添加数组
 3.返回数组
 
 rect 就是范围，就是目前屏幕整体，在整个sclloView里的cotentView的位置
 x,y就是offset，宽高都是屏幕，这里要讨论是横向还是纵向，横向滚动，y和高就没有用了
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
 
    // 清空掉之前的数据否则会接着往下加View
    [self.MinArray removeAllObjects];
    
    // 实例化数组
    for (int i = 0; i < self.Column; i++) {
        [_MinArray addObject:@(self.sectionInset.top)];
    }
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    NSLog(@"%@",array);
    
    NSMutableArray * attributes =[NSMutableArray array];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i<count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        CGFloat site = attribute.frame.origin.y;
        if (site >=rect.origin.y && site <= rect.size.height) {
            [attributes addObject:attribute];
        }
        
    }
    return attributes;
    
    
}
//NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
//
//for (NSIndexPath *indexPath in visibleIndexPaths) {
//    
//    UICollectionViewLayoutAttributes *attributes =
//    
//    [self layoutAttributesForItemAtIndexPath:indexPath];
//    
//    [layoutAttributes addObject:attributes];
//    
//}

-(void)prepareLayout{
    [super prepareLayout];
}

//这里的x，y是相对纵向和横向的，纵向的x就是宽不需要
- (CGSize)collectionViewContentSize {
    
    // 从数组中获取最大Y值
    
    CGFloat maxY = 0;
    
        maxY = [self.MinArray[0] doubleValue];
        
        for (int i = 1; i < _Column; i++) {
            
            CGFloat arrayValue = [self.MinArray[i] doubleValue];
            
            if (maxY < arrayValue) {
                
                maxY = arrayValue;
                
            }
        }
    return CGSizeMake(0, maxY + self.sectionInset.bottom);
}
@end

