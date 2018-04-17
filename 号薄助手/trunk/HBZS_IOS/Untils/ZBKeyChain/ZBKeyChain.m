//
//  ZBKeyChain.m
//  A
//
//  Created by zimbean on 13-12-11.
//  Copyright (c) 2013年 上海天信网络科技有限公司. All rights reserved.
//

#import "ZBKeyChain.h"
#import <Security/Security.h>

@implementation ZBKeyChain

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service,(__bridge id)kSecAttrService,
            service,(__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)saveToKeyChain:(NSString *)dataString service:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:dataString] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (void) deleteDataFromKeyChain:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

+ (NSString*)queryDataFromKeyChain:(NSString *)service{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try{
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e){
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        }
        @finally{
        }
    }
    
    if (keyData)
        CFRelease(keyData);
    
    return ret;
}

+ (NSString *)createUUID{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
   
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;
}

@end
