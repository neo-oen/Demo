//
//  HB_OneKeyCallModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/31.
//
//

#import "HB_OneKeyCallModel.h"

@implementation HB_OneKeyCallModel

-(void)dealloc{
    [_iconData_thumbnail release];
    [_name release];
    [_phoneNum release];
    [super dealloc];
}
/**
 *  序列化
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.keyNumber forKey:@"keyNumber"];
    [aCoder encodeInteger:self.recordID forKey:@"recordID"];
    [aCoder encodeObject:self.iconData_thumbnail forKey:@"iconData_thumbnail"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phoneNum forKey:@"phoneNum"];
}
/**
 *  反序列化
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.keyNumber=[aDecoder decodeIntegerForKey:@"keyNumber"];
        self.recordID=[aDecoder decodeIntegerForKey:@"recordID"];
        self.iconData_thumbnail=[aDecoder decodeObjectForKey:@"iconData_thumbnail"];
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.phoneNum=[aDecoder decodeObjectForKey:@"phoneNum"];
    }
    return self;
}

@end
