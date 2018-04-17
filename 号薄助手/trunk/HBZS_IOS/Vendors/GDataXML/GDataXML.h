//
//  GDataXML.h
//  jlzx
//
//  Created by 亮 常 on 12-4-26.
//  Copyright (c) 2012年 Haixu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface GDataXML : NSObject
{
    NSMutableArray *array;
    NSArray *keyWord;
}
@property (nonatomic, strong) NSString *xmlString;
- (NSMutableArray *)parseNetworkXML:(NSData *)data withkey:(NSArray *)key;
@end
