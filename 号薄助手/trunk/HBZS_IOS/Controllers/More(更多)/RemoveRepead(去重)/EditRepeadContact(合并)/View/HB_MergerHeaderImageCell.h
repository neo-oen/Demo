//
//  HB_MergerHeaderImageCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/9/11.
//
//

#import <UIKit/UIKit.h>
@class HB_MergerHeaderImageCell;

@protocol HB_MergerHeaderImageCellDelegate <NSObject>
/**
 *  在头像数组中，第index个头像被选中了
 */
-(void)mergerHeaderImageCell:(HB_MergerHeaderImageCell *)cell didSelectHeaderImageViewWithIndex:(NSInteger)index;

@end

@interface HB_MergerHeaderImageCell : UITableViewCell
/**
 *  代理
 */
@property(nonatomic,assign)id<HB_MergerHeaderImageCellDelegate> delegate;
/**
 *  头像数组
 */
@property(nonatomic,retain)NSMutableArray *iconArr;


@end
