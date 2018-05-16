//
//  xxmodel.h
//  testAPP
//
//  Created by neo on 2018/5/15.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    myShare,
    toMyShare
} ShareType;

@interface ContactShareInfo : NSObject

@property (readonly) int64_t id;//分享的id
@property (nonatomic, strong) NSString* shareurl;//分享的url
@property (nonatomic, strong) NSString* extractcode;//分享的验证码
@property (readonly) int64_t crdt;//分享的时间
@property(nonatomic,assign,getter=isSelected)BOOL selected;
@property(nonatomic,assign)ShareType shareType;


@end
