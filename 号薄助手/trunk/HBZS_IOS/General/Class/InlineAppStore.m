//
//  InlineAppStore.m
//  HBZS_IOS
//
//  Created by zimbean on 14-8-7.
//
//

#import "InlineAppStore.h"
#import <StoreKit/StoreKit.h>

@interface InlineAppStore () <SKStoreProductViewControllerDelegate>

@end

@implementation InlineAppStore

+ (InlineAppStore *)sharedInstance {
    static InlineAppStore* inlineAppstore = nil;
    
    @synchronized(self) {
        if (inlineAppstore == nil) {
            inlineAppstore = [[self alloc] init];
        }
    }
    
    return inlineAppstore;
}

- (void)showAppInApp:(NSString *)_appId controller:(UIViewController *)currentViewController{
    Class storeVC = NSClassFromString(@"SKStoreProductViewController");
    if (storeVC != nil) {
  
        SKStoreProductViewController *_SKSVC = [[SKStoreProductViewController alloc] init];
        _SKSVC.delegate = self;
        [_SKSVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: _appId}
                          completionBlock:^(BOOL result, NSError *error) {
                              if (result) {
                                [currentViewController presentViewController:_SKSVC animated:YES completion:NULL];
                              }
                              else{
                                  NSLog(@"%@",error);
                              }
                          }];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
