//
//  GDataXML.m
//  jlzx
//
//  Created by 亮 常 on 12-4-26.
//  Copyright (c) 2012年 Haixu. All rights reserved.
//

#import "GDataXML.h"

@implementation GDataXML

@synthesize xmlString;

// GDataXML方式解析
- (NSMutableArray *)parseNetworkXML:(NSData *)data withkey:(NSArray *)key
{  
    keyWord = key;
    
    array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [keyWord count]; i ++) {
        [array insertObject:[[NSMutableArray alloc] init] atIndex:i];
    }
    // 得到XML文本并转码
    self.xmlString = 
    [[NSString alloc] initWithData:data 
                          encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSError *error;
    // 加载XML文件
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] 
                             initWithXMLString: self.xmlString
                             options:0 
                             error:&error];
    
    if (doc == nil) { 
        return nil; 
    }
    NSLog(@"LOG=%@", [[NSString alloc] initWithData:doc.XMLData encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]);
    // 解析
    // 使用XPath语法
    NSArray *partyMembers = [doc.rootElement nodesForXPath:@"//xml/metadata" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        
        for (int i = 0; i < [keyWord count]; i ++) {
            NSArray *arr = [partyMember elementsForName:[keyWord objectAtIndex:i]];
            if (arr.count > 0) {
                GDataXMLElement *element = (GDataXMLElement *) [arr objectAtIndex:0];
                [[array objectAtIndex:i] addObject:element.stringValue];
                NSLog(@"[array objectAtIndex:i] ====== %@\n", [[array objectAtIndex:i] objectAtIndex:0]);
            } else continue;
        }
    }
    return array;
}

@end
