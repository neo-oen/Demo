//
//  HB_PackageVersionModel.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/12/14.
//
//

#import "HB_PackageVersionModel.h"

@implementation HB_PackageVersionModel
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.deltaVersion = [aDecoder decodeIntegerForKey:@"deltaversion"];
        self.fullVersion = [aDecoder decodeIntegerForKey:@"fullVersion"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.deltaVersion forKey:@"deltaversion"];
    [aCoder encodeInteger:self.fullVersion forKey:@"fullVersion"];
}
@end
