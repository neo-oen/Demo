//
//  HB_ContactDetailArrowCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

#import "HB_ContactDetailArrowCellModel.h"

@implementation HB_ContactDetailArrowCellModel
-(void)dealloc{
    [_placeHolder release];
    [_listModel release];
    [_icon release];
    [super dealloc];
}

+(instancetype)modelWithPlaceHolder:(NSString *)placeHolde andListModel:(HB_ContactDetailListModel *)listModel andIcon:(UIImage *)icon andViewController:(Class)viewController{
    HB_ContactDetailArrowCellModel * model=[[[HB_ContactDetailArrowCellModel alloc]init]autorelease];
    model.placeHolder=placeHolde;
    model.listModel=listModel;
    model.icon=icon;
    if (viewController) {
        model.viewController=viewController;
    }
    return model;
}


@end
