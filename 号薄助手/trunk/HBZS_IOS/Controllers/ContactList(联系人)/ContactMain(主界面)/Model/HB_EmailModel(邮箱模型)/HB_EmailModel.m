//
//  HB_EmailModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/13.
//
//

#import "HB_EmailModel.h"

static NSString *identify_emailType = @"_emailType";
static NSString *identify_emailAddress = @"_emailAddress";
static NSString *identify_index = @"_index";

@implementation HB_EmailModel
-(void)dealloc{
    [_emailType release];
    [_emailAddress release];
    [super dealloc];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.emailType = [aDecoder decodeObjectForKey:identify_emailType];
        self.emailAddress = [aDecoder decodeObjectForKey:identify_emailAddress];
        self.index = [[aDecoder decodeObjectForKey:identify_index] integerValue];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.emailType forKey:identify_emailType];
    [aCoder encodeObject:self.emailAddress forKey:identify_emailAddress];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:identify_index];
}

@end
