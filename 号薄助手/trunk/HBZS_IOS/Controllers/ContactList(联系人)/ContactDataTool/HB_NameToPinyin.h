//
//  HB_NameToPinyin.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2018/2/8.
//

#import <Foundation/Foundation.h>

@interface HB_NameToPinyin : NSObject

@property(nonatomic,retain)NSMutableDictionary * dic;

+(instancetype) sharedInstance;

-(NSString *)nameTopinyin:(NSString*)name;
@end
