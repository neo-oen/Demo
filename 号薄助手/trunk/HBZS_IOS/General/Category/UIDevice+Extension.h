//
//  UIDevice+Extension.h
//  HBZS_IOS
//
//  Created by zimbean on 14-7-17.
//
//

#import <UIKit/UIKit.h>

@interface UIDevice (Extension)

+ (BOOL)addressBookGetAuthorizationStatus;

+ (void)generateUUID;
+ (NSString *)getUUID;

@end
