//  版本更新
//  VersionCheck.h
//  Path2DemoPrj
//
//  Created by yingxin on 12-5-9.
//  Copyright (c) 2012年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mach/mach_init.h>
#include <mach/task.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

@interface VersionCheck : NSObject<UIAlertViewDelegate>{
    NSMutableData* webData;
    
    NSURLConnection *theConnection;
    
    NSTimer * checkTime;
}

/*
 * 检查版本
 */
- (void)checkVersion;

+ (VersionCheck*)getInstance;

@end
