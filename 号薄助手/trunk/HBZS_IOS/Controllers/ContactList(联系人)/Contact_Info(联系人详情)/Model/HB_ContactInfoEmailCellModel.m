//
//  HB_ContactInfoEmailCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import "HB_ContactInfoEmailCellModel.h"

@implementation HB_ContactInfoEmailCellModel

-(void)dealloc{
    [_emailModel release];
    [_icon release];
    [super dealloc];
}
+(instancetype)modelWithEmailModel:(HB_EmailModel *)emailModel andIcon:(UIImage *)icon{
    HB_ContactInfoEmailCellModel * model=[[[self alloc]init]autorelease];
    model.emailModel=emailModel;
    if (icon) {
        model.icon=icon;
    }
    return model;
}

@end
