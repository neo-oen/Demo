//
//  main.m
//  testFounction
//
//  Created by 王雅强 on 2018/3/25.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sun.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Sun * p1 = [[Sun alloc]init];
        [p1 setValue:@"wangbadan" forKey:@"name"];
        [p1 setValue:@"hhjk" forKey:@"qqqq"];
        
   
        NSLog(@"%@",p1);
    }
    return 0;
}
