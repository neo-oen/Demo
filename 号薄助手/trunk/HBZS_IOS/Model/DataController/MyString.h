//
//  MyString.h
//  CTPIM
//
//  Created by  Kevin Zhang、 scanmac on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyString : NSObject {
  
}

//过滤非数字,sourceStr必须是一个NSMutableString类,不能为一串字符
//字符串不能包含中文字符
+ (BOOL)filterToNumberString:(NSMutableString*) sourceStr;

+ (BOOL)checkIsNumberString:(NSMutableString *)sourceStr;

@end
