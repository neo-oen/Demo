//
//  FormatPhoneNumber.m
//  HBZS_IOS
//
//  Created by zimbean on 13-11-5.
//
//

#import "FormatPhoneNumber.h"

@implementation FormatPhoneNumber

+ (NSString *)formatPhoneNumber:(NSString *)phoneNumber{
    NSMutableString *phone = [NSMutableString stringWithString:phoneNumber];
    NSString *number = @"0123456789";
    
    for(int i = 0; i < phone.length; i ++){
        NSString *character = [phone substringWithRange:NSMakeRange(i, 1)];
        if ( (i == 0) && [character isEqualToString:@"+"]) {
            continue;
        }
       
        if ([number rangeOfString:character].length == 0) {
            [phone deleteCharactersInRange:NSMakeRange(i, 1)];
            i = 0;
        }
    }
    
    return [NSString stringWithFormat:@"tel:%@", phone];
}

@end
