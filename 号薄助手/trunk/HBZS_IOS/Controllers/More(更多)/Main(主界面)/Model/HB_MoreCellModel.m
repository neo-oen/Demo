//
//  HB_MoreCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/11.
//
//

#import "HB_MoreCellModel.h"

@implementation HB_MoreCellModel

-(void)dealloc{
    [_icon release];
    [_nameStr release];
    [super dealloc];
}
+(instancetype)modelWithIcon:(UIImage *)image andNameStr:(NSString *)name andViewController:(Class)viewController andOption:(void (^)(void))block{
    HB_MoreCellModel * model=[[[self alloc]init]autorelease];
    model.icon=image;
    model.nameStr=name;
    model.viewController=viewController;
    model.block=[block copy];
    return model;
}


@end
