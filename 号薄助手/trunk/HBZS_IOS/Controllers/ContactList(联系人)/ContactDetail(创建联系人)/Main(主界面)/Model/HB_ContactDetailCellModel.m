//
//  HB_ContactDetailCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

#import "HB_ContactDetailCellModel.h"

@implementation HB_ContactDetailCellModel

-(void)dealloc{
    [_placeHolder release];
    [_listModel release];
    [_icon release];
    [super dealloc];
}
+(instancetype)modelWithPlaceHolder:(NSString *)placeHolder andListModel:(HB_ContactDetailListModel *)listModel andIcon:(UIImage *)icon{
    HB_ContactDetailCellModel * model=[[[self alloc]init] autorelease];
    model.placeHolder=placeHolder;
    model.icon=icon;
    model.listModel=listModel;
    return model;
}


@end
