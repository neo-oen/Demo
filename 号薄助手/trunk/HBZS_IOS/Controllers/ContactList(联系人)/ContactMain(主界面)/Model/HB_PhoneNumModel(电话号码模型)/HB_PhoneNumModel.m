//
//  HB_PhoneNumModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/12.
//
//

#import "HB_PhoneNumModel.h"
#import "AreaQuery.h"

static NSString *identify_phoneType = @"_phoneType";
static NSString *identify_phoneNum = @"_phoneNum";
static NSString *identify_areaQuery = @"_areaQuery";
static NSString *identify_index = @"_index";

@implementation HB_PhoneNumModel
-(void)dealloc{
    [_phoneNum release];
    [_phoneType release];
    [_areaQuary release];
    [super dealloc];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.phoneType = [aDecoder decodeObjectForKey:identify_phoneType];
        self.phoneNum = [aDecoder decodeObjectForKey:identify_phoneNum];
        self.areaQuary = [aDecoder decodeObjectForKey:identify_areaQuery];
        self.index = [[aDecoder decodeObjectForKey:identify_index] integerValue];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.phoneType forKey:identify_phoneType];
    [aCoder encodeObject:self.phoneNum forKey:identify_phoneNum];
    [aCoder encodeObject:self.areaQuary forKey:identify_areaQuery];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:identify_index];
}


-(void)setPhoneNum:(NSString *)phoneNum{
    if (_phoneNum != phoneNum) {
        [_phoneNum release];
        _phoneNum = [phoneNum retain];
    }
    self.areaQuary = [[AreaQuery getInstance]queryAreaByNumber:_phoneNum];
}



@end
