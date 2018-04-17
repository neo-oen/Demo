//
//  LocationQuery.m
//  ImagePicker
//
//  Created by yingxin fu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "areaQuery.h"

@interface AreaQuery ()
- (BOOL)openDataBase;

- (void)closeDataBase;

@end


@implementation AreaQuery

AreaQuery* quertInstanse = nil;

+ (AreaQuery*)getInstance{
    if (quertInstanse == nil) {
        quertInstanse = [[AreaQuery alloc] init];
    }
    
    return quertInstanse;
}

+ (void)releaseInstance{
    if (quertInstanse) {
        [quertInstanse release];
        
        quertInstanse = nil;
    }
}

+ (BOOL)installDataBaseFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory , NSUserDomainMask, YES);//
    
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"Sqlite3TableAreaDetail.sql"];
    
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Sqlite3TableAreaDetail.bin"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
    }
    
    return success;
}

- (void)dealloc{
    [self closeDataBase];
    [super dealloc];
}

- (id)init{
    self = [super init];
    if (self) {
        [self openDataBase];
    }
    
    return self;
}

- (BOOL)openDataBase{
    BOOL result = NO;
    
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"Sqlite3TableAreaDetail.sql"];
    
    if (sqlite3_open([databaseFilePath UTF8String], &database) == SQLITE_OK){
        result = YES;
    }
    else{
        sqlite3_close(database);
    }
    
    return result;
}

- (void)closeDataBase{
    if (database) {
        sqlite3_close(database);
        
        database = nil;
    }
}

/*
 * 归属地查询
 */
- (NSString*)queryAreaByNumber:(NSString*)number{
    if (number == nil || [number length] < 7) {
        return @"";
    }
    
    NSString* result = nil;
    
    NSString* quertString = [NSString stringWithFormat:@"select * from AreaDetail where Num = %@ ;",[number substringToIndex:7]];
    
    const char *selectSql= [quertString cStringUsingEncoding:NSUTF8StringEncoding];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &statement, nil)==SQLITE_OK){
        int i = 0;
        
        if(sqlite3_step(statement) == SQLITE_ROW)//SQLITE_OK SQLITE_ROW
        {
            
            NSString *sheng = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
           
            NSString *shi = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            
            i++;
            
            result = [NSString stringWithFormat:@"%@ %@",sheng,shi];
            
            [sheng release];
            
            [shi release];
        }
        else{
            result = @"";
        }
    }
    else{
        result = @"";
    }
    
    sqlite3_finalize(statement);
   
    return result;
}

@end
