//
//  main.m
//  nsarryAndIndicator
//
//  Created by neo on 2017/10/25.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTT.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        TTT * tt1 = [[TTT alloc]init];
        tt1.name = @"1";
        TTT * tt2 = [[TTT alloc]init];
        tt2.name = @"2";
        TTT * tt3 = [[TTT alloc]init];
        tt3.name = @"3";
        TTT * tt4 = [[TTT alloc]init];
        tt4.name = @"4";
        TTT * tt5 = [[TTT alloc]init];
        tt5.name = @"5";
        TTT * tt6 = [[TTT alloc]init];
        tt6.name = @"6";
        
        NSArray * array1 =@[tt1,tt2,tt3];
        NSArray * array2 =@[tt4,tt5,tt6];
        
        TTT * p = array1[1];
        
        &array1[1] = &array2[1];
        
        
        
    }
    return 0;
}
