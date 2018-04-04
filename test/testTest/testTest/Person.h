//
//  Person.h
//  testTest
//
//  Created by 王雅强 on 2018/3/29.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,assign)NSInteger age;


+ (instancetype)personWithDict:(NSDictionary *)dict;
+ (void)loadPersonAsync:(void (^)(Person *))completion;
@end
