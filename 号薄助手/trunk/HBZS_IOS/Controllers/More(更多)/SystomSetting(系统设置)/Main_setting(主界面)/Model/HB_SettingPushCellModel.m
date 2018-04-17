//
//  HB_SettingPushCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingPushCellModel.h"

@implementation HB_SettingPushCellModel

-(void)dealloc{
    [super dealloc];
}
+(instancetype)modelWithName:(NSString *)name andViewController:(Class)viewController{
    HB_SettingPushCellModel *model=[[[self alloc]init]autorelease];
    model.name=name;
    model.viewController=viewController;
    return model;
}

@end
