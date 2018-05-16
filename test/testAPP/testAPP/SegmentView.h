//
//  SegmentView.h
//  testAPP
//
//  Created by neo on 2018/5/8.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SegmentViewChangeAction)(NSInteger index);

@interface SegmentView : UIView

@property(nonatomic,assign)NSInteger selectIndex;


/**
 点击成功Block
 */
@property(nonatomic,copy)SegmentViewChangeAction segmentViewChangeA ;



@end
