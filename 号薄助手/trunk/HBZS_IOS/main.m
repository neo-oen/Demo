//
//  main.m
//  HBZS_IOS
//
//  Created by yingxin on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingInfo.h"
#import "HBZSAppDelegate.h"

void redirectNSLogToDocumentFolder()//存储 consle 打印信息
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName =[NSString stringWithFormat:@"PIMIOS.log"];

    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    //    函数名：freopen
    //    声明：FILE *freopen( const char *path, const char *mode, FILE *stream );
    //    所在文件： stdio.h
    //    参数说明：
    //    path: 文件名，用于存储输入输出的自定义文件名。
    //    mode: 文件打开的模式。和fopen中的模式（如r-只读, w-写）相同。
    //  stream: 一个文件，通常使用标准流文件。
    //    返回值：成功，则返回一个path所指定文件的指针；失败，返回NULL。（一般可以不使用它的返回值）
    //    功能：实现重定向，把预定义的标准流文件定向到由path指定的文件中。标准流文件具体是指stdin、stdout和stderr。其中stdin是标准输入流，默认为键盘；stdout是标准输出流，默认为屏幕；stderr是标准错误流，一般把屏幕设为默认。
    
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding],"a+",stderr);
}

int main(int argc, char *argv[])
{
    if ([SettingInfo getIsLogged]) {
        redirectNSLogToDocumentFolder();       //存储 consle 打印信息
    }
  
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([HBZSAppDelegate class]));
    
    [pool release];
    
    return retVal;
}
