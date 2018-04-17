//
//  HB_SettingSwitchCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingSwitchCellModel.h"

@implementation HB_SettingSwitchCellModel
-(void)dealloc{
    [super dealloc];
}
+(instancetype)modelWithName:(NSString *)name andSwitchIsOn:(BOOL)switchIsOn{
    HB_SettingSwitchCellModel *model=[[[self alloc]init]autorelease];
    model.name=name;
    model.switchIsOn=switchIsOn;
    return model;
}
@end
