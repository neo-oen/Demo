//
//  CheckNewVersionRequest.h
//  HBZS_IOS
//
//  Created by zimbean on 14-7-18.
//
//

#import <Foundation/Foundation.h>

typedef void(^CheckNewVersionResponseBlock)(BOOL);

@interface CheckNewVersionRequest : NSObject

/*
 *用于检测版本更新  当block返回 YES时  提示更新
 */
+ (void)requestDidFinsh:(CheckNewVersionResponseBlock)responseBlock;

@end
