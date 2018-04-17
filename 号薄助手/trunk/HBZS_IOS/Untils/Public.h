//
//  Public.h
//  CTPIM
//
//  Created by scanmac on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Public : NSObject{
  
}

+ (NSString *)subWithString:(NSString *)str Length:(NSInteger)length;

+ (NSInteger)theLengthOfString:(NSString *)str;

+ (NSString*)md5:(NSString *)str;            //MD5加密

+ (long)getCurrentTimeLong;                 //获得当前时间

+ (NSString*)getCurrentTimeStr;

+ (NSString*)getDeviceID;                 //获得设备序列号

+ (NSString*)getSysVersion;               //获得ios系统版本号

+ (NSString*)getDeviceVersion;           //获得当前设备型号

+ (NSString*)getSigStr:(NSString*)timeStr;          //time+key做md5加密

+ (NSString*)getClientInfo;                  //终端型号|操作系统版本信息|UA

+ (BOOL)bCheckFeedbackEmail:(NSString*) EmailStr;          //检查Email是否正确

+ (NSMutableString*)stringToEncodeBase64:(NSString*)input;    //获得B64编码(返回的NSString要释放)

+ (NSUInteger)getStringLen:(NSString*) str;                 //计算字符串的长度

+ (NSString *)checkDeviceType;

+ (void)allocAlertview:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)title1 btnTitle:(NSString *)title2 delegate:(id)_delegate tag:(NSInteger)_tag;

+ (void)setImageviewBackgroundImage:(NSString *)img imageview:(UIImageView *)imageview;

+ (void)setButtonBackgroundImage:(NSString *)nomalImg highlighted:(NSString *)highlightedImg button:(UIButton *)btn;

@end


@interface NSString (PublicExtensions)

- (NSString *) md5;

- (NSString *) base64;

- (NSData *) SimpleEncryptByOffset:(int)offset bySalt:(int)salt;

@end

@interface NSData (PublicExtensions)

- (NSString *) md5;

- (NSString *) base64;

- (NSString *) SimpleDecryptByOffset:(int)offset bySalt:(int)salt;

@end


