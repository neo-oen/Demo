//
//  HB_ContactInfoCallHistoryCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import <Foundation/Foundation.h>
#import "HB_ContactInfoDialItemModel.h"

@interface HB_ContactInfoCallHistoryCellModel : NSObject

/** 详情页用到的 通话记录模型 */
@property(nonatomic,retain)HB_ContactInfoDialItemModel *dialItemModel;
/** 图标 */
@property(nonatomic,retain)UIImage *icon;

/**
 *  快速创建一个通话记录cell的model
 */
+(instancetype)modelWithDialItemModel:(HB_ContactInfoDialItemModel *)dialItemModel andIcon:(UIImage *)icon;

@end
