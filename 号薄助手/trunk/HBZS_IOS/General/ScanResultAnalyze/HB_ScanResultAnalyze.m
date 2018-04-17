//
//  HB_ ScanResultAnalyze.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/21.
//
//

#import "HB_ScanResultAnalyze.h"
#import "HB_ContactDetailController.h"
#import "HB_BusinessCardParser.h"
#import "HB_textViewController.h"
@implementation HB_ScanResultAnalyze

-(instancetype)initWithCurrentVc:(id)CurrentViewController
{
    self  = [super init];
    if (self) {
        self.CurrentViewController = CurrentViewController;
    }
    return self;
}

-(void)AnalyzeResult:(NSString *)result
{
    
    //判断扫码的结果，进行对应的操作
    if (!result) {
        UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法解析此内容！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
        [al release];
        return;
    }
    
    if([self isCardParser:result])
    {
        HB_ContactDetailController *editVC = [[HB_ContactDetailController alloc]init];
        editVC.contactModel = [HB_BusinessCardParser parseWithPropertyString:result];
        editVC.delegate = (id)self.CurrentViewController;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editVC];
        [self.CurrentViewController presentViewController:nav animated:YES completion:nil];
        [editVC release];
        [nav release];
        [HB_BusinessCardParser parseWithPropertyString:result];
    }
    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    }
    else
    {
        HB_textViewController * textVc = [[HB_textViewController alloc] init];
        textVc.detailString = result;
        textVc.title = @"扫描结果";
        [self.CurrentViewController.navigationController pushViewController:textVc animated:YES];
    }
}

-(BOOL)isCardParser:(NSString *)propertyString
{
    NSString * beginString =  [[propertyString componentsSeparatedByString:@":"] firstObject];
    if ([beginString isEqualToString:@"CARD"] ||[beginString isEqualToString:@"MECARD"]) {
        return YES;
    }
    NSArray * arr = [propertyString componentsSeparatedByString:@"\n"];
    if ([arr.firstObject rangeOfString:@"BEGIN:VCARD"].location !=NSNotFound) {
        return YES;
    }
    return NO;
}

//正则表达式 可以用于URL网址解析
-(BOOL)isUrlstring:(NSString *)result
{
    
/* 几组正则表达式
((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)
 
[a-zA-z]+://[^\s]* //此表达式存在一个
 
(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)
*/
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-z]+://[^\s]*" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *checkingResult = [regex firstMatchInString:result options:0 range:NSMakeRange(0, [result length])];
    if (checkingResult)
    {
        NSRange range = checkingResult.range;
        if (range.location == 0) {
            return YES;
        }
    }
    return NO;
}



@end
