//
//  UncaughtExceptionHandler.h
//  A
//
//  Created by zimbean on 13-12-10.
//  Copyright (c) 2013年 上海天信网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

void HandleException(NSException *exception);
void SignalHandler(int signal);

void InstallUncaughtExceptionHandler(void);

@end


