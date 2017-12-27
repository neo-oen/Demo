//
//  BannerModel.h
//  bannerView
//
//  Created by neo on 2017/10/10.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

@property(nonatomic,copy)NSString * icon;
@property(nonatomic,copy)NSString * imageUrl;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)BannerWithDict:(NSDictionary *)dict;

+ (NSArray *)BannersWithPath:(NSString *)path;
+ (NSArray *)BannersWithArray:(NSArray *)array;


@end
