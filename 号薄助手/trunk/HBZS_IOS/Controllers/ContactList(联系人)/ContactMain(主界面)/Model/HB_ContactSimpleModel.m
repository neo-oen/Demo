//
//  HB_ContactSimpleModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/21.
//
//

#import "HB_ContactSimpleModel.h"

@implementation HB_ContactSimpleModel

-(void)dealloc{
    
    [_name release];
    [_contactID release];
    [_iconData_thumbnail release];
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}


@end
