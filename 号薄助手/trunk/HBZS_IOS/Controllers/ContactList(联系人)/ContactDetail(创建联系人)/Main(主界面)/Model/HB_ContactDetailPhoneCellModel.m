//
//  HB_ContactDetailPhoneCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//

#import "HB_ContactDetailPhoneCellModel.h"

@implementation HB_ContactDetailPhoneCellModel

-(void)dealloc{
    [_placeHolder release];
    [_icon release];
    [_phoneModel release];
    [_emailModel release];
    [super dealloc];
}
+(instancetype)modelWithPlaceHolder:(NSString *)placeHolder andModel:(id)phoneOrEmailModel{
    HB_ContactDetailPhoneCellModel * model=[[[self alloc]init]autorelease];
    model.placeHolder=placeHolder;
    if ([phoneOrEmailModel isKindOfClass:[HB_PhoneNumModel class]]) {
        model.phoneModel=phoneOrEmailModel;
    }else if ([phoneOrEmailModel isKindOfClass:[HB_EmailModel class]]){
        model.emailModel=phoneOrEmailModel;
    }
    return model;
}

@end
