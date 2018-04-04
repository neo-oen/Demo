//
//  Person.m
//  testFounction
//
//  Created by 王雅强 on 2018/3/25.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "Person.h"
@interface Person(){
    NSString * name;
}
@property(nonatomic,copy)NSString * qqqq;


@end

@implementation Person


-(NSString *)description{
    
    return [NSString stringWithFormat:@"Person--name=%@,qqqq=%@",self->name,self.qqqq];
}

@end
