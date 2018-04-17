//
//  InlineAppStore.h
//  HBZS_IOS
//
//  Created by zimbean on 14-8-7.
//
//

#import <Foundation/Foundation.h>

@interface InlineAppStore : NSObject

+ (InlineAppStore *)sharedInstance;

- (void)showAppInApp:(NSString *)_appId controller:(UIViewController *)currentViewController;

@end
