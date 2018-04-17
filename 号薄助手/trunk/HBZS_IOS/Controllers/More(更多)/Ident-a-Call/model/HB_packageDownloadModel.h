//
//  HB_packageDownloadModel.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/12/14.
//
//

#import <Foundation/Foundation.h>
#import "DHBSDKUpdateItem.h"
#import "DHBSDKCommonType.h"
@interface HB_packageDownloadModel : NSObject

@property(nonatomic,retain)DHBSDKUpdateItem * item;
@property(nonatomic,assign)DHBDownloadPackageType downLoadType;

@end
