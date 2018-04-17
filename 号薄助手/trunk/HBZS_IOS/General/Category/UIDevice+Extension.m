//
//  UIDevice+Extension.m
//  HBZS_IOS
//
//  Created by zimbean on 14-7-17.
//
//

#import "UIDevice+Extension.h"
#import <AddressBook/AddressBook.h>
#import "ZBKeyChain.h"

@implementation UIDevice (Extension)

+ (BOOL)addressBookGetAuthorizationStatus{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {//表示允许
        return YES;
    }else{
        if(status == kABAuthorizationStatusRestricted){
            ZBLog(@"已经收到禁止");
        }
        return NO;
    }
}

+ (void)generateUUID{
    NSString *cfuuid = [ZBKeyChain queryDataFromKeyChain:kUUID];
    
	if (cfuuid == nil || 10 > [cfuuid length])
    {
        CFUUIDRef uuidObj = CFUUIDCreate(nil);    //create a new CFUUID
        
        NSString *temp = (NSString*)CFUUIDCreateString(nil, uuidObj);
        //get the string representation of the UUID
        NSString *uuidString = [NSString stringWithFormat:@"%@",temp];
        
        CFRelease(uuidObj);
        
        cfuuid = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [ZBKeyChain saveToKeyChain:cfuuid service:kUUID];
    
        [temp release];
    }
}

+ (NSString *)getUUID{
    NSString *uuid = [ZBKeyChain queryDataFromKeyChain:kUUID];
    ZBLog(@"### [uuid]: %@", uuid);
    
    return uuid;
}
+ (NSString*) getUUIDString

{
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
    
}

@end
