//
//  HB_MoreVCSettingCell.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/11.
//
//

#import <UIKit/UIKit.h>
#import "HB_MoreCellModel.h"

@class HB_MoreVCSettingCell;
@protocol HB_MoreVCSettingCellDelegate <NSObject>

-(void)MoreVCSettingCell:(HB_MoreVCSettingCell *)MoreVCSettingCell selectedAtIdexPath:(NSIndexPath *)indexPath;

@end

@interface HB_MoreVCSettingCell : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *  cell的数据模型
 */
@property(nonatomic,retain)HB_MoreCellModel *model;

@property(nonatomic,retain)NSArray * cellModelArr;

@property(nonatomic,assign)id<HB_MoreVCSettingCellDelegate>delegate;

/**
 *  快速返回一个cell
 *
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
