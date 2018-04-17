//
//  HB_MemberModelCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/27.
//
//

#import <UIKit/UIKit.h>
#import "HB_ModelItemView.h"
@class HB_MemberModelCell;
@protocol memberModelCellDelegate <NSObject>

-(void)memberModelCell:(HB_MemberModelCell *)cell ClickModel:(HB_MemberModel *)model;

@end

@interface HB_MemberModelCell : UITableViewCell<MemberModelDelegate>
@property(nonatomic,retain)id<memberModelCellDelegate>delegate;
@property(nonatomic,retain)NSMutableArray * models;

-(void)initdataWithDictionary:(NSDictionary *)dic;

@end
