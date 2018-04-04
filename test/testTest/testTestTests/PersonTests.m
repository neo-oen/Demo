//
//  PersonTests.m
//  testTestTests
//
//  Created by 王雅强 on 2018/3/29.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

@interface PersonTests : XCTestCase

@end

@implementation PersonTests
//一次单元测试前准备工作,可以设置为全局变量
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
//一次单元测试前销毁工作
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
//单元测试模拟方法
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
//性能测试
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        NSTimeInterval start = CACurrentMediaTime();
        
        // 测试用例，循环10000次，为了演示效果
        for (NSInteger i = 0; i < 10000; i++) {
            [Person personWithDict:@{@"name":@"zhang",@"age":@20}];
        }
        
        // 传统测试代码耗时方法
        NSLog(@"--=--%lf",CACurrentMediaTime() - start);
        
    }];
}


// 测试异步加载person
- (void)testLoadPersonAsync {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"异步加载 Person"];
    
    [Person loadPersonAsync:^(Person *person) {
        //        NSLog(@"%@",person);
        
        XCTAssertNotNil(person.name, @"名字不能为空");
        XCTAssert(person.age > 0, @"年龄不正确");
        
        // 标注预期达成
        [expectation fulfill];
    }];
    
    // 等待 5s 期望预期达成
    [self waitForExpectationsWithTimeout:5 handler:nil];
}


// 逻辑测试方法
- (void)testNewPerson {
    
    // 1.测试 name和age 是否一致
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@30}];
    
    /** 2.测试出 age 不符合实际，那么需要在字典转模型方法中对age加以判断：
     if (obj.age <= 0 || obj.age >= 130) {
     obj.age = 0;
     }
     */
    [self checkPersonWithDict:@{@"name":@"zhang",@"age":@200}];
    
    // 3.测试出 name 为nil的情况，因此在XCTAssert里添加条件：“person.name == nil“
    [self checkPersonWithDict:@{}];
    
    // 4.测试出 Person类中没有 title 这个key，在字典转模型方法中实现：- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@30, @"title":@"boss"}];
    
    // 5.总体再验证一遍，结果Build Succeeded，测试全部通过
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@-1, @"title":@"boss"}];
    
    // 到目前为止 Person 的 工厂方法测试完成！✅
}

// 根据字典检查新建的 person 信息
- (void)checkPersonWithDict:(NSDictionary *)dict {
    
    Person *person = [Person personWithDict:dict];
    
    NSLog(@"%@",person);
    
    // 获取字典中的信息
    NSString *name = dict[@"name"];
    NSInteger age = [dict[@"age"] integerValue];
    
    // 1.检查名字
    XCTAssert([name isEqualToString:person.name] || person.name == nil, @"姓名不一致");
    
    // 2.检查年龄
    if (person.age > 0 && person.age < 130) {
        XCTAssert(age == person.age, @"年龄不一致");
    } else {
        XCTAssert(person.age == 0, @"年龄超限");
    }
}



@end
