//  归属地查询
//  LocationQuery.h
//  ImagePicker
//
//  Created by yingxin fu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface AreaQuery : NSObject{
  sqlite3 *database;
}

+ (BOOL)installDataBaseFile;

+ (AreaQuery*)getInstance;

+ (void)releaseInstance;

- (id)init;
/**
 *  根据号码查询归属地信息
 */
- (NSString*)queryAreaByNumber:(NSString*)number;

@end
