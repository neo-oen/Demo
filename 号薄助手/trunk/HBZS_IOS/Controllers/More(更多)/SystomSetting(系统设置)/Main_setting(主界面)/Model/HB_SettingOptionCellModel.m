//
//  HB_SettingOptionCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingOptionCellModel.h"

@implementation HB_SettingOptionCellModel
-(void)dealloc{
    [_rightString release];
    [super dealloc];
}
+(instancetype)modelWithName:(NSString *)name andOption:(void (^)(void))option{
    HB_SettingOptionCellModel *model=[[[self alloc]init]autorelease];
    model.name=name;
    model.option=option;
    return model;
}
@end
