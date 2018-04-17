//
//  SearchItem.h
//  HBZS_IOS
//
//  Created by Kevin Zhang、yingxin on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchItem : NSObject {

}

@property (nonatomic) NSInteger contactID;

@property (nonatomic) NSInteger contactType;       //联系人类型：全部(-1)/群组(群ID)/搜索(-2)/公众号(-4)

@property (nonatomic) NSInteger contactGroupID;     //联系人群ID(当前操作群)

@property (nonatomic, retain) NSString* contactFullName;

@property (nonatomic, retain) NSString* contactFirstName;   //名

@property (nonatomic, retain) NSString* contactLastName;    //姓

@property (nonatomic, retain) NSString* contactSearch;      //联系人搜索内容

@property (nonatomic, retain) NSString* PubNumberLogoStr;   //公众号logo图片名字

@property (nonatomic, retain) NSString* contactSearchSimple;    //联系人简拼搜索内容
//new:
@property (nonatomic, retain) NSString* chineseFirstNamePY;    //中文姓

@property (nonatomic, retain) NSString* chineseFirstName;      //中文姓

@property (nonatomic, retain) NSString* contactT9Search;       //联系人T9搜索内容

@property (nonatomic, retain) NSString* contactT9SearchSimple;  //联系人简拼T9搜索内容

@property (nonatomic, retain) NSMutableArray* contactSearchArray;     //提供搜索内容

@property (nonatomic, retain) NSString* contactLastSaveTime;      //联系人最后修改时间

@property (nonatomic, retain) NSMutableArray* contactPhoneArray;

@property (nonatomic, retain)  NSMutableArray *contactEmailArray;

@property (nonatomic, retain) NSString* callLogTime;   //来去电时间

@property (nonatomic) NSInteger callLogType;      //来去电类型,0:call to,1:call from,2:missed calls

@property (nonatomic,assign) NSRange keyRange;

@property (nonatomic,retain) NSMutableArray *rangeArray;

+ (SearchItem*)searchItemAlloc;

@end
