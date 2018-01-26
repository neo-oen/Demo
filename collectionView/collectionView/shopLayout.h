//
//  shopLayout.h
//  collectionView
//
//  Created by neo on 2018/1/9.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^ItemHeightWithIndexPathAndWidht)(NSIndexPath * path,CGFloat widht);

@interface shopLayout : UICollectionViewFlowLayout

@property(nonatomic,copy)ItemHeightWithIndexPathAndWidht  itemHeight;
@property(nonatomic,assign)NSInteger Column;


@end
