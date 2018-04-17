//
//  NewMessage.m
//  HBZS_IOS
//
//  Created by zimbean on 14-6-25.
//
//

#import "NewMessage.h"

@implementation NewMessage

@synthesize jobServerId;
@synthesize iconUrl;
@synthesize title;
@synthesize content;
@synthesize imgContentUrl1;
@synthesize imgContentUrl2;
@synthesize imgContentUrl3;

@synthesize urlDetail;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}

@end
