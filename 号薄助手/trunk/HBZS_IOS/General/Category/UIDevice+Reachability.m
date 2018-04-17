//
//  UIDevice+Reachability.m
//  HBZS_IOS
//
//  Created by zimbean on 14-7-17.
//
//

#import "UIDevice+Reachability.h"
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation UIDevice (Reachability)

+ (BOOL)canConnectToNetwork{
    struct sockaddr_in zeroAddress;
    
	bzero(&zeroAddress, sizeof(zeroAddress));
	
    zeroAddress.sin_len = sizeof(zeroAddress);
	
    zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	
    CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		ZBLog(@"Error. Count not recover network reachability flags\n");
		return NO;
	}
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (CTCallCenter *)checkDeviceCallState{
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    
    BOOL isDialing = NO;
    
    if (callCenter.currentCalls != nil) {
        isDialing = YES;
    }
    
    ZBLog(@"callState: %@", callCenter.currentCalls);
    
    return [callCenter autorelease];;
}

@end
