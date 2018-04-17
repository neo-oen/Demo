//
//  UIDevice+Reachability.h
//  HBZS_IOS
//
//  Created by zimbean on 14-7-17.
//
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface UIDevice (Reachability)

+ (BOOL)canConnectToNetwork;

+ (CTCallCenter *)checkDeviceCallState;

@end
