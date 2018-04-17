//  同步日志实体类
//  SyncLogItem.h
//  HBZS_IOS
//
//  Created by Kevin Zhang、yingxin fu on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncLogItem : NSObject {
  NSString *syncType;
    
  NSString *startTime;
    
  NSString *endTime;
    
  NSString *syncResult;
}

@property (nonatomic, retain) NSString *syncType;

@property (nonatomic, retain) NSString *startTime;

@property (nonatomic, retain) NSString *endTime;

@property (nonatomic, retain) NSString *syncResult;

+ (SyncLogItem*)syncLogItemAlloc;


@end
