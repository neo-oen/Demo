//
//  HB_ContactInfoPhoneCellModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import "HB_ContactInfoPhoneCellModel.h"

@implementation HB_ContactInfoPhoneCellModel
-(void)dealloc{
    [_phoneModel release];
    [_icon release];
    [super dealloc];
}
+(instancetype)modelWithPhoneModel:(HB_PhoneNumModel *)phoneModel andIcon:(UIImage *)icon andIsLastCall:(BOOL)isLastCall{
    HB_ContactInfoPhoneCellModel * model=[[[self alloc]init]autorelease];
    model.phoneModel=phoneModel;
    model.lastCall=isLastCall;//是否是最后一次呼出的号码
    if (icon) {
        model.icon=icon;
    }
    return model;
}
@end
