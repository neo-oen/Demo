//
//  HB_ConvertEmailArrTool.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/13.
//
//

#import "HB_ConvertEmailArrTool.h"
#import "HB_EmailModel.h"

@implementation HB_ConvertEmailArrTool
-(void)dealloc{
    [super dealloc];
}

#pragma mark - public methods 
+(NSMutableArray *)convertEmailTypeWithArraySystemToHBZS:(NSArray *)emailArr{
    NSMutableArray *listEmailArr = [NSMutableArray array];
    
    for (int i=0; i<emailArr.count; i++) {
        HB_EmailModel *emailModel = emailArr[i];
        
        HB_EmailModel *listEmailModel = [[HB_EmailModel alloc]init];
        listEmailModel.emailAddress = emailModel.emailAddress;
        
        if ([emailModel.emailType isEqualToString:@"_$!<Home>!$_"]) {
            listEmailModel.emailType = @"常用邮箱";
        }else if ([emailModel.emailType isEqualToString:@"_$!<Work>!$_"]){
            listEmailModel.emailType = @"商务邮箱";
        }
        else if ([emailModel.emailType isEqualToString:@"iCloud"]){
            listEmailModel.emailType = @"其他邮箱2";
        }
        else if ([emailModel.emailType isEqualToString:@"_$!<Other>!$_"]){
            listEmailModel.emailType = @"个人邮箱";
        }
        else if ([emailModel.emailType isEqualToString:kSABMSNLabel]){
            listEmailModel.emailType = @"其他邮箱1";
        }
        else{
            //用户自定义的标签，同意转化为‘其他邮箱’
            listEmailModel.emailType = @"其他邮箱1";
        }
        
        [listEmailArr addObject:listEmailModel];
        [listEmailModel release];
    }
    return listEmailArr;
}
+(NSMutableArray *)convertEmailTypeWithArrayHBZSToSystem:(NSArray *)emailArr{
    NSMutableArray *systemEmailArr = [NSMutableArray array];
    
    for (int i=0; i<emailArr.count; i++) {
        HB_EmailModel *emailModel = emailArr[i];
        if (emailModel.emailAddress.length==0) {
            continue;
        }
        HB_EmailModel *systemEmailModel = [[HB_EmailModel alloc]init];
        systemEmailModel.emailAddress = emailModel.emailAddress;
        
        if ([emailModel.emailType isEqualToString:@"常用邮箱"]) {
            systemEmailModel.emailType = @"_$!<Home>!$_";
        }else if ([emailModel.emailType isEqualToString:@"商务邮箱"]){
            systemEmailModel.emailType = @"_$!<Work>!$_";
        }
        else if ([emailModel.emailType isEqualToString:@"其他邮箱2"]){
            systemEmailModel.emailType = @"iCloud";
        }
        else if ([emailModel.emailType isEqualToString:@"其他邮箱1"]){
            systemEmailModel.emailType = kSABMSNLabel;
        }
        else if ([emailModel.emailType isEqualToString:@"个人邮箱"]){
            systemEmailModel.emailType = @"_$!<Other>!$_";
        }
        
        [systemEmailArr addObject:systemEmailModel];
        [systemEmailModel release];
    }
    return systemEmailArr;
}

+(NSString * )convertEmailTypeSystemToHBZS:(NSString *)typeString
{
    NSString * str ;
    if ([typeString isEqualToString:@"_$!<Home>!$_"])
    {
        str = [NSString stringWithFormat:@"常用邮箱"];
    }
    else if ([typeString isEqualToString:@"_$!<Work>!$_"])
    {
        str = [NSString stringWithFormat:@"商务邮箱"];
    }
    else if ([typeString isEqualToString:@"iCloud"])
    {
        str = [NSString stringWithFormat:@"其他邮箱2"];
    }
    else if ([typeString isEqualToString:@"_$!<Other>!$_"])
    {
        str = [NSString stringWithFormat:@"个人邮箱"];
    }
    else if ([typeString isEqualToString:(NSString *)kSABMSNLabel])
    {
        str = [NSString stringWithFormat:@"其他邮箱1"];
    }
    else
    {
        //用户自定义的标签，同意转化为‘其他邮箱’
        str = [NSString stringWithFormat:@"其他邮箱1"];
    }
    return str;
}

+(NSString *)convertEmailTypeHBZSToSystem:(NSString *)HBZSstring
{
    NSString * str ;
    if ([HBZSstring isEqualToString:@"常用邮箱"])
    {
        str = [NSString stringWithFormat:@"_$!<Home>!$_"];
    }
    else if ([HBZSstring isEqualToString:@"商务邮箱"])
    {
        str = [NSString stringWithFormat:@"_$!<Work>!$_"];
    }
    else if ([HBZSstring isEqualToString:@"其他邮箱2"])
    {
        str = [NSString stringWithFormat:@"iCloud"];
    }
    else if ([HBZSstring isEqualToString:@"个人邮箱"])
    {
        str = [NSString stringWithFormat:@"_$!<Other>!$_"];
    }
    else if ([HBZSstring isEqualToString:@"其他邮箱1"])
    {
        str = [NSString stringWithFormat:(NSString *)kSABMSNLabel];
    }
    else{
        //用户自定义的标签，同意转化为‘其他邮箱’
        str = [NSString stringWithFormat:@"其他邮箱1"];
    }
    return str;

}
@end
