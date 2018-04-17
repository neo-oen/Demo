//
//  HB_InstantMessageModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/12/30.
//
//

#import "HB_InstantMessageModel.h"

static NSString *identify_type = @"_type";
static NSString *identify_account = @"_account";
static NSString *identify_index = @"_index";

@implementation HB_InstantMessageModel

-(void)dealloc{
    [_type release];
    [_account release];
    [super dealloc];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.type = [aDecoder decodeObjectForKey:identify_type];
        self.account = [aDecoder decodeObjectForKey:identify_account];
        self.index = [[aDecoder decodeObjectForKey:identify_index] integerValue];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.type forKey:identify_type];
    [aCoder encodeObject:self.account forKey:identify_account];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:identify_index];
}


@end
