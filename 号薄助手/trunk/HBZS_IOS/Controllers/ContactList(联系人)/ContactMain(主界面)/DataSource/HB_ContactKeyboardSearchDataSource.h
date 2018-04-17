//
//  HB_ContactKeyboardSearchDataSource.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/24.
//
//

#import <Foundation/Foundation.h>

@interface HB_ContactKeyboardSearchDataSource : NSObject<UITableViewDataSource>
/** 数据源数组 */
@property(nonatomic,retain)NSMutableArray * dataArr;
/** 搜索关键字 */
@property(nonatomic,copy)NSString * searchText;

@end
