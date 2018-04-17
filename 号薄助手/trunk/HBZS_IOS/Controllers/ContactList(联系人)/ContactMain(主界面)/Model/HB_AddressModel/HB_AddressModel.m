//
//  HB_AddressModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/12/28.
//
//

#import "HB_AddressModel.h"

static NSString *identify_type = @"_type";
static NSString *identify_country = @"_country";
static NSString *identify_state = @"_state";
static NSString *identify_city = @"_city";
static NSString *identify_street = @"_street";
static NSString *identify_zip = @"_zip";
static NSString *identify_countryCode = @"_countryCode";
static NSString *identify_index = @"_index";

@implementation HB_AddressModel

-(void)dealloc{
    [_type release];
    [_country release];
    [_state release];
    [_city release];
    [_street release];
    [_zip release];
    [_countryCode release];
    [super dealloc];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.type = [aDecoder decodeObjectForKey:identify_type];
        self.country = [aDecoder decodeObjectForKey:identify_country];
        self.state = [aDecoder decodeObjectForKey:identify_state];
        self.city = [aDecoder decodeObjectForKey:identify_city];
        self.street = [aDecoder decodeObjectForKey:identify_street];
        self.zip = [aDecoder decodeObjectForKey:identify_zip];
        self.countryCode = [aDecoder decodeObjectForKey:identify_countryCode];
        self.index = [[aDecoder decodeObjectForKey:identify_index] integerValue];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.type forKey:identify_type];
    [aCoder encodeObject:self.country forKey:identify_country];
    [aCoder encodeObject:self.state forKey:identify_state];
    [aCoder encodeObject:self.city forKey:identify_city];
    [aCoder encodeObject:self.street forKey:identify_street];
    [aCoder encodeObject:self.zip forKey:identify_zip];
    [aCoder encodeObject:self.countryCode forKey:identify_countryCode];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:identify_index];
}


@end
