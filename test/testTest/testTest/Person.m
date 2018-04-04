//
//  Person.m
//  testTest
//
//  Created by 王雅强 on 2018/3/29.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "Person.h"
@implementation Person
+ (instancetype)personWithDict:(NSDictionary *)dict {
    Person *obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    
    if (obj.age <= 0 || obj.age >= 130) {
        obj.age = 0;
    }
    
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

+ (void)loadPersonAsync:(void (^)(Person *))completion {
    
    // 异步 子线程执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 模拟网络延迟 2s
        [NSThread sleepForTimeInterval:3.0];
        
        Person *person = [Person personWithDict:@{@"name":@"zhang", @"age":@25}];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(person);
            }
        });
    });
}

@end

