//
//  HB_MachineDataModel.m
//

//
//  Created by mac on 16-1-13.
//
//

#import "HB_MachineDataModel.h"
#import "HB_ContactDataTool.h"
#import "FMDB.h"
#import "SettingInfo.h"
@implementation HB_MachineDataModel

@class HB_MachineDataModel;
static HB_MachineDataModel * globalMachineModel;

#pragma mark 类方法
+(HB_MachineDataModel *)getglobalMachineModel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalMachineModel = [[HB_MachineDataModel alloc] init];
    });
    return globalMachineModel;
}


+(NSString *)TimeMachineDbPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"TimeMachine.db"];
    
}

+(void)createTimeMachineDb
{
    FMDatabase * db = [[FMDatabase alloc]initWithPath:[HB_MachineDataModel TimeMachineDbPath]];
    
    if (![db open]) {
        NSLog(@"can not open db");
    }
    else
    {
        if (![db tableExists:@"TimeMachineTable"]) {
            BOOL isSucced = [db executeUpdate:@"CREATE TABLE TimeMachineTable(syncTime INTEGER,contactsCount INTEGER,syncTypecode INTEGER,contactsData BLOB,groupsData BLOB)"];
            if (!isSucced) {
                NSLog(@"NewMessage table create failed");
            }
        }
        
    }
}


#pragma mark 对象方法

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self  = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
//        self.syncTime = [[dic objectForKey:@"syncTime"] integerValue];
//        self.contactsCount = [[dic objectForKey:@"contactsCount"] integerValue];
//        self.syncTypecode = [[dic objectForKey:@"syncTypecode"] integerValue];
    }
    return self;
}

-(void)getCurrentMachineDataWithSyncTask:(SyncTaskType)typecode
{
    NSArray * contacts = [HB_ContactDataTool contactGetAllContactAllProperty];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:contacts];
    self.syncTime = [[NSDate date] timeIntervalSince1970];
    self.syncTypecode = typecode;
    self.contactsCount = [contacts count];
    self.contactsData = data;
    
    
}


#pragma mark 保存数据库

-(BOOL)globalTimeMachineSave
{
    FMDatabase * db = [[FMDatabase alloc] initWithPath:[HB_MachineDataModel TimeMachineDbPath]];
    if (![db open]) {
        
        NSLog(@"Could not open db.");
        [db release];
        return NO;
        
    }
    else
    {
        BOOL isSuccess = [db executeUpdate:@"insert into TimeMachineTable (syncTime,contactsCount,syncTypecode,contactsData,groupsData) values(?,?,?,?,?)",[NSNumber numberWithInteger:self.syncTime],[NSNumber numberWithInteger:self.contactsCount],[NSNumber numberWithInteger:self.syncTypecode],self.contactsData,self.groupsData];
        NSLog(@"TimeMachineTable insert is == %d",isSuccess);
        
        self.syncTime =0;
        self.syncTypecode = 0;
        self.contactsCount = 0;
        self.contactsData = nil;
        self.groupsData = nil;
        
        NSInteger count = [db intForQuery:@"select count(*)from TimeMachineTable"];
        if (count>5) {
            BOOL isDelete = [db executeUpdate:@"delete from TimeMachineTable where syncTime=(select min(syncTime) from TimeMachineTable)"];
            NSLog(@"isDelete = %d",isDelete);
        }
        
        [db close];
        [db release];
        
        return isSuccess;
        
    }
    
    
}

-(instancetype)getContactsAndGropusDataToModel
{
    FMDatabase * db = [[FMDatabase alloc] initWithPath:[HB_MachineDataModel TimeMachineDbPath]];
    if (![db open]) {
        NSLog(@"timeMachineDb can not open");
        [db release];
        return self;
    }
    FMResultSet * timeMachineSet = [db executeQuery:@"SELECT contactsData,groupsData from TimeMachineTable where syncTime = ?",[NSNumber numberWithInteger:self.syncTime]];
    while ([timeMachineSet next]) {
        self.contactsData = [timeMachineSet objectForColumnName:@"contactsData"];
        self.groupsData = [timeMachineSet objectForColumnName:@"groupsData"];
        
    }
    
    
    
    [db close];
    [db release];
    
    [SettingInfo addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[HB_MachineDataModel TimeMachineDbPath]]];
    return self;
}



-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}

-(void)dealloc
{
    [_contactsData release];
    [_groupsData release];
    [super dealloc];
}






@end
