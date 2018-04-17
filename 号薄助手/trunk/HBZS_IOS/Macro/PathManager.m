//
//  PathManager.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/4/20.
//
//

#import "PathManager.h"

@implementation PathManager
+(NSString *)dbPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MessageCenter.db"];
    return dbPath;
}
@end
