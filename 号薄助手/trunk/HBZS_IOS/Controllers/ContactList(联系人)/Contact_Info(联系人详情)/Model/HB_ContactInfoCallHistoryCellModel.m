//
//  HB_ContactInfoCallHistoryCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import "HB_ContactInfoCallHistoryCellModel.h"

@implementation HB_ContactInfoCallHistoryCellModel
-(void)dealloc{
    [_dialItemModel release];
    [_icon release];
    [super dealloc];
}

+(instancetype)modelWithDialItemModel:(HB_ContactInfoDialItemModel *)dialItemModel andIcon:(UIImage *)icon{
    HB_ContactInfoCallHistoryCellModel * model=[[[HB_ContactInfoCallHistoryCellModel alloc]init]autorelease];
    model.dialItemModel=dialItemModel;
    model.icon=icon;
    return model;
}

@end
