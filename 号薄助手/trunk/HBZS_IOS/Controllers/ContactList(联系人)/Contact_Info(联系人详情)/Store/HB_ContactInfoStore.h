//
//  HB_ContactInfoStore.h
//  HBZS_IOS
//
//  Created by zimbean on 16/1/26.
//
//

#import <Foundation/Foundation.h>
#import "HB_ContactModel.h"
#import "HB_ContactDetailListModel.h"

@interface HB_ContactInfoStore : NSObject
/** 数据源数组 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/** 列表需要的数据模型 */
@property(nonatomic,retain)HB_ContactDetailListModel *listModel;
/** 联系人完整模型 */
@property(nonatomic,retain)HB_ContactModel *contactModel;

/**
 *  加载第5组的所有数据
 */
-(void)addAllDataInGroup5;
/**
 *  加载第5组的部分数据
 */
-(void)addHalfDataInGroup5;
@end
