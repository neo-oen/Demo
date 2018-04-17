//
//  HB_MachineDataModel.h
//  HBZS_IOS
//
//  Created by mac on 16-1-13.
//
//
/**
 *  1.创建时光机所需的数据库
 *  2.获取当前联系人数据缓存，并可以存入数据库
 */

#import <Foundation/Foundation.h>
#import "SyncEngine.h"
#import "FMDB.h"
@interface HB_MachineDataModel : NSObject

@property(nonatomic,assign)NSInteger syncTime;
@property(nonatomic,assign)NSInteger contactsCount;
@property(nonatomic,assign)NSInteger syncTypecode;
@property(nonatomic,strong)NSData * contactsData;
@property(nonatomic,strong)NSData * groupsData;


/**
 *  获取当前联系人数据记录全局model
 */
+(HB_MachineDataModel *)getglobalMachineModel;

/*
 *  创建Machinetime数据库表
 */
+(void)createTimeMachineDb;

/*
 *  数据库地址
 */
+(NSString *)TimeMachineDbPath;



#pragma Mark 对象方法

#pragma mark 保存数据库  仅供全局的对象来调用，单例调用
-(BOOL)globalTimeMachineSave;



-(instancetype)initWithDictionary:(NSDictionary *)dic;
-(instancetype)getContactsAndGropusDataToModel;


-(void)getCurrentMachineDataWithSyncTask:(SyncTaskType)typecode;

@end
