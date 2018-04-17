//
//  QRCodeInfoModel.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/5/25.
//
//

#import "QRCodeInfoModel.h"

@implementation QRCodeInfoModel

//KVC防止崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}


@end
