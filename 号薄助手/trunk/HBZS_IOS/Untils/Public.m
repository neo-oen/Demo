//
//  Public.m
//  CTPIM
//
//  Created by scanmac on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Public.h"
#import "GobalSettings.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "sys/utsname.h"//用于获取设备具体的型号

@implementation Public


/*
 * subWithString
 */
+ (NSString *)subWithString:(NSString *)str Length:(NSInteger)length{
    NSInteger nameLength = [Public theLengthOfString:str];
    
    NSMutableString *tempString = [NSMutableString stringWithString:@""];
    
    if (nameLength > length) {
        int len = 0;
        
        for (int i = 0; i < str.length; ++i){
            NSRange range = NSMakeRange(i, 1);
            
            NSString *subString = [str substringWithRange:range];
            
            const char *cString = [subString UTF8String];
            
            if (strlen(cString) == 3){
                len = len + 3;
                
                if (len > length) {
                    [tempString appendString:@"..."];
                    break;
                }
                
                [tempString appendString:subString];
            }
            else{
                
                len = len + 1;
                
                if (len > length) {
                    [tempString appendString:@"..."];
                    break;
                }
                
                [tempString appendString:subString];
            }
        }
    }
    
    return tempString;
}

/*
 * theLengthOfString
 */
+ (NSInteger)theLengthOfString:(NSString *)str{
    NSInteger len = 0;
    
    for (int i = 0; i < str.length; ++i){
        NSRange range = NSMakeRange(i, 1);
        
        NSString *subString = [str substringWithRange:range];
        
        const char *cString = [subString UTF8String];
        
        if (strlen(cString) == 3){
            len = len + 3;
        }
        else{
            len = len + 1;
        }
    }
    
     return len;
}

/*
 * md5
 */
+ (NSString*)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    
    unsigned char result[17];
    
    CC_MD5(cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]];
}

/*
 * checkDeviceType
 */
+ (NSString *)checkDeviceType{
    CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
    
    NSString *str = [NSString stringWithFormat:@"%0.1f",deviceHeight];
    
    NSString *temp = nil;
    
    if ([str isEqualToString:@"568.0"]) {
        temp = @"iPhone 5";
    }
    else if([str isEqualToString:@"480.0"]){
        temp = @"iPhone 4";
    }
    
    return temp;
}

/*
 * getCurrentTimeLong
 */
+ (long)getCurrentTimeLong{                //获得当前时间
    NSDate *now = [NSDate date];
    
	return [now timeIntervalSince1970];
}

/*
 * getCurrentTimeStr
 */
+ (NSString*)getCurrentTimeStr{
    NSDate *now = [NSDate date];
    
    long long IntTime= [now timeIntervalSince1970];
    
    NSString *str = [NSString stringWithFormat:@"%lld",IntTime];
    
    return str;
}

/*
 * 获得设备序列号
 */
+ (NSString*)getDeviceID{
    NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
    
    NSString *uuid = [NSString stringWithFormat:@"%@",
                      [handler objectForKey:[NSString stringWithFormat:@"uuid_created_by_pimios"]]];
    
    return uuid;
}

/*
 * 获得ios系统版本号
 */
+ (NSString*)getSysVersion{
    UIDevice *dev = [UIDevice currentDevice];
    
    return dev.systemVersion;
}


/*
 * 获得当前设备型号
 */
+ (NSString*)getDeviceVersion{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"设备版本：%@",deviceString);
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return [UIDevice currentDevice].model;
}

/*
 * time+key做md5加密
 */
+ (NSString*)getSigStr:(NSString*)timeStr{
    //号簿助手的key为b30b426680559f7dfeba5d92cb9de695
    NSString *str = [NSString stringWithFormat:@"%@b30b426680559f7dfeba5d92cb9de695", timeStr];
    
    NSString *md5Str = [self md5:str];
    
    return [md5Str lowercaseString];
}

/*
 * 终端型号+操作系统版本信息+UA
 */
+ (NSString*)getClientInfo{
    NSMutableString *str = [[[NSMutableString alloc]initWithFormat:@"%@|%@|UA",
                             [self getDeviceVersion], [self getSysVersion]]autorelease];
    return str;
}

/*
 * 检查Email是否正确
 */
+ (BOOL)bCheckFeedbackEmail:(NSString*) EmailStr{
    if ([EmailStr length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"意见反馈邮件地址不能为空!"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
        [alert release];
        
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailTest evaluateWithObject:EmailStr]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"邮件地址有误,请重新输入!"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
        [alert release];
        
        return NO;
    }
    
    return YES;
}

//获得B64编码
+ (NSMutableString*)stringToEncodeBase64:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    
    NSMutableString *base64String = [[[NSMutableString alloc] initWithData:data
                                                                  encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}

//计算字符串的长度
+ (NSUInteger)getStringLen:(NSString*) str{
    if (str == nil) {
        return 0;
    }
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSUInteger leng = [str lengthOfBytesUsingEncoding:enc];
    
    ZBLog(@"计算字符串长度[%d]", leng);
    return leng;
}

+ (void)allocAlertview:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)title1 btnTitle:(NSString *)title2 delegate:(id)_delegate tag:(NSInteger)_tag{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:title message:msg delegate:_delegate cancelButtonTitle:nil otherButtonTitles:title1,title2, nil];
    [alertview setTag:_tag];
    
    [alertview show];
    
    [alertview release];
}

+ (void)setButtonBackgroundImage:(NSString *)nomalImg highlighted:(NSString *)highlightedImg button:(UIButton *)btn{
    if (nomalImg) {
//        NSString *imgPath = [[NSBundle mainBundle]pathForResource:nomalImg ofType:@"png"];
//        
//        UIImage *image = [[UIImage alloc]initWithContentsOfFile:imgPath];
        
        UIImage * image = [UIImage imageNamed:nomalImg];
        
//        if (Device_Width == 375) {
//            CGFloat top = 0;
//            CGFloat left = 60;
//            CGFloat bottom = 0;
//            CGFloat right = 60;
//            image =  [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeTile];
//        }
        
        [btn setImage:image forState:UIControlStateNormal];
//        [btn setImage:image forState:UIControlStateNormal];
        
//        [image release];
    }
    
    if (highlightedImg) {
//        NSString *imgPath = [[NSBundle mainBundle]pathForResource:highlightedImg ofType:@"png"];
//        
//        UIImage *image = [[UIImage alloc]initWithContentsOfFile:imgPath];
        
        UIImage * image = [UIImage imageNamed:highlightedImg];
//        if (Device_Width == 375) {
//            CGFloat top = image.size.height *0.9;
//            CGFloat left = image.size.width*0.9;
//            CGFloat bottom = image.size.height*0.9;
//            CGFloat right = image.size.width*0.9;
//            image =  [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeTile];
//        }
        [btn setImage:image forState:UIControlStateHighlighted];
        
//        [image release];
    }
}

+ (void)setImageviewBackgroundImage:(NSString *)img imageview:(UIImageView *)imageview{
    NSString *imgPath = [[NSBundle mainBundle]pathForResource:img ofType:@"png"];
    
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:imgPath];
    
    [imageview setImage:image];
    
    [image release];
}


@end


@implementation NSString (PublicExtensions)

/*
 * md5
 */
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    
    unsigned char result[16];
    
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

/*
 * base64
 */
- (NSString *) base64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    return base64String;
}

/*
 * SimpleEncryptByOffset
 */
- (NSData *) SimpleEncryptByOffset:(int)offset bySalt:(int)salt
{
    NSData *sourceData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    Byte *data = (Byte *)[sourceData bytes];
    
    int len = [sourceData length];
    
    for (int i =0; i<len; i++)
    {
        //data[i] = ((data[i] << (8 - offset)) & 0x00FF | data[i] >> offset);
        data[i] = (((data[i] << (8 - offset)) & 0x00FF) | data[i] >> offset);
        data[i] = (Byte)(data[i] ^ salt);
    }
    
    for (int i = 0; i < len/2; i++)
    {
        Byte temp = data[i];
        
        data[i] = data[len-i-1];
        
        data[len-i-1] = temp;
    }
	
    return [[[NSData alloc] initWithBytes:data length:len] autorelease];
}

@end

@implementation NSData (PublicExtensions)

/*
 * md5
 */
- (NSString *) md5
{
    unsigned char result[16];
    
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

/*
 * base64
 */

- (NSString *) base64
{
    //转换到base64
    NSData *data = [GTMBase64 encodeData:self];
    
    NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    return base64String;
}

/*
 *  SimpleDecryptByOffset
 */
- (NSString *) SimpleDecryptByOffset:(int)offset bySalt:(int)salt
{
    Byte *data = (Byte *)[self bytes];
    
    int len = [self length];
    
    for (int i = 0; i < len/2; i++)
    {
        Byte temp = data[i];
        
        data[i] = data[len-i-1];
        
        data[len-i-1] = temp;
    }
    
    for (int i = 0; i < len; i++)
    {
        data[i] = (Byte)(data[i] ^ salt);
        
        data[i] = (Byte)(((data[i] << offset) & 0x00FF) | (data[i] >> (8 - offset)));
    }
	
    return [[[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding] autorelease];
}


@end

