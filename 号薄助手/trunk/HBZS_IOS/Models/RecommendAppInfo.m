//
//  RecommendAppInfo.m
//  HBZS_IOS
//
//  Created by zimbean on 14-8-7.
//
//

#import "RecommendAppInfo.h"

@implementation RecommendAppInfo

@synthesize topPictureUrl;
@synthesize thumbnailUrl1;
@synthesize thumbnailUrl2;
@synthesize thumbnailUrl3;
@synthesize thumbnailUrl4;
@synthesize appIconUrl;
@synthesize appName;
@synthesize appVendor;
//@synthesize thumbnailUrl;
@synthesize downloadUrl;

@synthesize packetSize;

@synthesize appDescription;

@synthesize starRate;

@synthesize previewImgUrls;

- (void)dealloc{
    if (previewImgUrls) {
        [previewImgUrls release];
    }
    
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        previewImgUrls = [[NSMutableArray alloc]init];
    }
    
    return self;
}
@end
