//
//  HB_ContactSearchResultDataSource.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/26.
//
//

#import <Foundation/Foundation.h>

@interface HB_ContactSearchResultDataSource : NSObject<UITableViewDataSource>
/** 数据源数组 */
@property(nonatomic,retain)NSMutableArray * dataArr;
/** 搜索关键字 */
@property(nonatomic,copy)NSString * searchText;


-(void)NetMsgSearchContactWithText:(NSString *)searchText;

@end
