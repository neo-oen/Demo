//
//  HB_MoreVCCollectionCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/4/13.
//
//

#import <UIKit/UIKit.h>
#import "HB_MoreCellModel.h"

@interface HB_MoreVCCollectionCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *leftImageView;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,retain)HB_MoreCellModel *model;

@end
