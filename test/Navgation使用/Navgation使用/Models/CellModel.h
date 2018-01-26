//
//  CellModel.h
//  Navgation使用
//
//  Created by neo on 2018/1/19.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * phone;//列表里有数组

- (instancetype)initWithName:(NSString *)name andPhone:(NSString *)phone;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellWithDict:(NSDictionary *)dict;

+ (NSArray *)cellsWithPath:(NSString *)path;
+ (NSArray *)cellsWithArray:(NSArray *)array;


@end
