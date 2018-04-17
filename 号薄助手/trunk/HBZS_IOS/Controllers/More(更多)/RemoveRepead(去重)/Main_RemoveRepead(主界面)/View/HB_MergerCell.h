//
//  HB_MergerCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/17.
//
//

#import <UIKit/UIKit.h>
@class HB_MergerCell;

@protocol HB_MergerCellDelegate <NSObject>
/**
 *  cell右侧的“合并”按钮点击
 */
-(void)mergerCelldidMergerBtnClick:(HB_MergerCell *)mergerCell;

@end

@interface HB_MergerCell : UITableViewCell
/**  存放重复联系人model的数组 */
@property(nonatomic,retain)NSArray *contactArr;
/**  代理 */
@property(nonatomic,assign)id<HB_MergerCellDelegate> delegate;
/**  快速创建HB_MergerCell */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
