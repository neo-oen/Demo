//
//  HB_ContactListDataSource.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/26.
//
//

#import <Foundation/Foundation.h>

@interface HB_ContactListDataSource : NSObject<UITableViewDataSource>

/**  最终的数据源数组 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**  需要展示的分组的id （-100表示全部联系人，-101表示未分组联系人） */
@property(nonatomic,assign)NSInteger groupID;

/** 刷新数据源（全部联系人） */
-(void)refreshDataSource;
/** 数据源是否为空 */
-(BOOL)dataArrIsNull;


@end
