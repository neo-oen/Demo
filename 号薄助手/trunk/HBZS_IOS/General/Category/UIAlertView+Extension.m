//
//  UIAlertView+Extension.m
//  HBZS_IOS
//
//  Created by zimbean on 14-7-17.
//
//

#import "UIAlertView+Extension.h"

@implementation UIAlertView (Extension)


+ (void)alertViewWithMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

+ (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

@end
