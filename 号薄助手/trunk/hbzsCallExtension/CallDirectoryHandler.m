//
//  CallDirectoryHandler.m
//  hbzsCallExtension
//
//  Created by 冯强迎 on 16/12/2.
//
//

#import "CallDirectoryHandler.h"
#import "HB_IdentACall.h"
@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    if (![self addBlockingPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add blocking phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:1 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    if (![self addIdentificationPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add identification phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:2 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    [context completeRequestWithCompletionHandler:nil];
}

- (BOOL)addBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    

    return YES;
}

- (BOOL)addIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    NSURL * fileDirectory=[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupid];
    NSString *filePath = [fileDirectory.path stringByAppendingString:@"/BridgeFile"];
    NSString *filePathI=[[NSString alloc] initWithFormat:@"%@/BridgeFile",filePath];
    
    NSLog(@"1-%@",filePathI);
    NSLog(@"2-%@",filePath);
    for (int i=0;i<1000;i++) {
        @autoreleasepool {
            NSString * filePathIZip=[[NSString alloc] initWithFormat:@"%@Cache%d",filePath,i];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePathIZip])
            {
                break;
            }
            
            DHBSDKYuloreZipArchive * zip=[[DHBSDKYuloreZipArchive alloc] init];
            [zip UnzipOpenFile:filePathIZip Password:APISIG];
            [zip UnzipFileTo:filePath overWrite:YES];
            [zip UnzipCloseFile];
            
            NSMutableDictionary *contentDict = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathI];
            
            NSArray * phoneNumbers=[contentDict allKeys];
            
            phoneNumbers = [phoneNumbers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 longLongValue] > [obj2 longLongValue]) {
                    return NSOrderedDescending;
                } else if ([obj1 longLongValue] < [obj2 longLongValue]) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedSame;
                }
            }];
            
            for (NSNumber * phoneNumber in phoneNumbers) {
                NSString *label = [contentDict objectForKey:phoneNumber];
                long long phone = [phoneNumber longLongValue];
                [context addIdentificationEntryWithNextSequentialPhoneNumber:phone label:label];
            }
            
            
            
            [[NSFileManager defaultManager] removeItemAtPath:filePathI error:nil];
            filePathIZip=nil;
        }
    }
    [context completeRequestWithCompletionHandler:nil];

    return YES;
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}

@end
