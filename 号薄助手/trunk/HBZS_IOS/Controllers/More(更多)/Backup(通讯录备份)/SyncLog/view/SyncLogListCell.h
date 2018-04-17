//
//  SyncLogListCell.h
//  HBZS_IOS
//
//  Created by zimbean on 14-8-12.
//
//

#import <UIKit/UIKit.h>

@class SyncLogItem;

@interface SyncLogListCell : UITableViewCell{
    
}

@property (nonatomic, retain)IBOutlet UIImageView *statusImgView;

@property (nonatomic, retain)IBOutlet UILabel *syncTypeLabel;
@property (nonatomic, retain)IBOutlet UILabel *endTimeLabel;


@property (nonatomic, retain)IBOutlet UIImageView *rightArrowImgView;

- (void)configureCellWithSyncLog:(SyncLogItem *)logItem;
@end
