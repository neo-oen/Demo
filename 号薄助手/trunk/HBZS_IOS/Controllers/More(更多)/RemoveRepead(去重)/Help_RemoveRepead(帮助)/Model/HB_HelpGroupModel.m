//
//  HB_HelpGroupModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/18.
//
//

#import "HB_HelpGroupModel.h"

@implementation HB_HelpGroupModel
-(void)dealloc{
    [_question release];
    [_answer release];
    [super dealloc];
}
+(instancetype)modelWithDict:(NSDictionary *)dict{
    return [[[self alloc]initWithDict:dict]autorelease];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}



@end
