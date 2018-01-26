//
//  MapShengModel.h
//  PickerView
//
//  Created by neo on 2018/1/11.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapShengModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSArray * cities;//列表里有数组

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)shengWithDict:(NSDictionary *)dict;

+ (NSArray *)shengsWithPath:(NSString *)path;
+ (NSArray *)shengsWithArray:(NSArray *)array;


@end
