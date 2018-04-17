//
//  ZBKeyChain.h
//  A
//
//  Created by zimbean on 13-12-11.
//  Copyright (c) 2013年 上海天信网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBKeyChain : NSObject{
    
}

+ (void)saveToKeyChain:(NSString *)dataString service:(NSString*)service;

+ (void)deleteDataFromKeyChain:(NSString *)service;

+ (NSString*)queryDataFromKeyChain:(NSString*)service;

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service;

+ (NSString *)createUUID;

@end
