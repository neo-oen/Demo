//
//  ConfigMgr.m
//  HBZS_IOS
//
//  Created by rentao on 5/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GobalSettings.h"
#import "JSON.h"
#import "ConfigMgr.h"
@implementation ConfigMgr

static ConfigMgr* theConfigMgr;

+ (ConfigMgr*)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theConfigMgr = [[ConfigMgr alloc] init];
        [self load];
    });
    
    return theConfigMgr;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    
    if(!initialized)
    {
        initialized = YES;
        
        theConfigMgr = [[ConfigMgr alloc] init];
    }
}

+(NSString *)getConfigPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/config_data.txt"];
    return documentsDirectory;
   
}

/*
 * load
 */
- (void)load
{
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//	documentsDirectory = [documentsDirectory stringByAppendingString:@"/config_data.txt"];
    
	NSData* configData = [NSData dataWithContentsOfFile:[ConfigMgr getConfigPath]];
//    NSString *configString = [[NSString alloc]initWithData:configData encoding:NSUTF8StringEncoding];
//    
//    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
//   
//    NSError *error;
//	
//    configDict = [[jsonParser objectWithString:configString error:&error] retain];//[[configData mutableObjectFromJSONData] retain];
//    
//    [configString release];
//    [jsonParser release];
    
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:configData];
    configDict = [[unarchiver decodeObjectForKey:@"configdata"] retain];
    [unarchiver finishDecoding];
    [unarchiver release];
    
    
    
	if (configDict == nil){
        configDict =  [[NSMutableDictionary alloc] init];
    }
}

/**
  * save
 **/
- (void)save
{
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//	documentsDirectory = [documentsDirectory stringByAppendingString:@"/config_data.txt"];
   
//    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc]init];
//    NSString *configString = [jsonWriter stringWithObject:configDict];
//	NSData* configData = [configString dataUsingEncoding:NSUTF8StringEncoding];//[configDict JSONData];
//    [jsonWriter release];

    NSMutableData * configData = [[NSMutableData alloc] init];
    
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:configData];
    [archiver encodeObject:configDict forKey:@"configdata"];
    [archiver finishEncoding];
	[configData writeToFile:[ConfigMgr getConfigPath] atomically:YES];
}

- (void) setValue:(id)value forKey:(NSString *)key forDomain:(NSString *)domain
{
	[configDict setObject:value forKey:key];
    
	[self save];
}

- (id) getValueForKey:(NSString *)key forDomain:(NSString *)domain
{
    [self load];
	return [configDict objectForKey:key];
}




@end

