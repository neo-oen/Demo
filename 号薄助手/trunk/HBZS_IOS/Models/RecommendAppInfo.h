//
//  RecommendAppInfo.h
//  HBZS_IOS
//
//  Created by zimbean on 14-8-7.
//
//

#import <Foundation/Foundation.h>

@interface RecommendAppInfo : NSObject

@property (nonatomic, retain)NSString *thumbnailUrl1;
@property (nonatomic, retain)NSString *thumbnailUrl2;
@property (nonatomic, retain)NSString *thumbnailUrl3;
@property (nonatomic, retain)NSString *thumbnailUrl4;
@property (nonatomic, retain)NSMutableArray *previewImgUrls;

@property (nonatomic, retain)NSString *appName;
@property (nonatomic, retain)NSString *appVendor;
@property (nonatomic, assign)CGFloat packetSize;
@property (nonatomic, retain)NSString *appDescription;

@property (nonatomic, retain)NSString *topPictureUrl;
@property (nonatomic, retain)NSString *appIconUrl;


@property (nonatomic, retain)NSString *downloadUrl;

@property (nonatomic, assign)int starRate;
@end

