//
//  HB_ConvertPhoneNumArrTool.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/12.
//
//

#import "HB_ConvertPhoneNumArrTool.h"
#import "HB_PhoneNumModel.h"//电话号码模型
#import "AreaQuery.h"//归属地信息
#import "HB_ContactInfoDialItemTool.h"
#import "HB_ContactInfoDialItemModel.h"


@implementation HB_ConvertPhoneNumArrTool
#pragma mark - life cycle
-(void)dealloc{
    [super dealloc];
}
#pragma mark - pubulic methods
+(NSMutableArray *)convertPhoneTypeWithPhoneArrSystemToHBZS:(NSArray *)phoneArr andContactRecordID:(NSInteger)recordID{
    NSMutableArray *listPhoneModelArr = [NSMutableArray array];
    for (int i=0; i<phoneArr.count; i++) {
        HB_PhoneNumModel *phoneModel = phoneArr[i];

        HB_PhoneNumModel *listPhoneModel = [[HB_PhoneNumModel alloc]init];
        listPhoneModel.phoneNum = phoneModel.phoneNum;

        if ([phoneModel.phoneType isEqualToString:@"_$!<Home>!$_"]) {
            listPhoneModel.phoneType = @"住宅";
        }else if ([phoneModel.phoneType isEqualToString:@"_$!<Work>!$_"]){
            listPhoneModel.phoneType = @"工作";
        }else if ([phoneModel.phoneType isEqualToString:@"iPhone"]){
            listPhoneModel.phoneType = @"iPhone";
        }else if ([phoneModel.phoneType isEqualToString:@"_$!<Mobile>!$_"]){
            listPhoneModel.phoneType = @"手机";
        }else if ([phoneModel.phoneType isEqualToString:@"_$!<Main>!$_"]){
            listPhoneModel.phoneType = @"主要";
        }else if ([phoneModel.phoneType isEqualToString:@"_$!<HomeFAX>!$_"]){
            listPhoneModel.phoneType = @"住宅传真";
        }else if ([phoneModel.phoneType isEqualToString:@"_$!<WorkFAX>!$_"]){
            listPhoneModel.phoneType = @"工作传真";
        }else if ([phoneModel.phoneType isEqualToString:@"_$!<Pager>!$_"]){
            listPhoneModel.phoneType = @"传呼";
        }
//        else if ([phoneModel.phoneType isEqualToString:kSABVPNLabel]){
//            listPhoneModel.phoneType = @"VPN";
//        }
        else if ([phoneModel.phoneType isEqualToString:@"_$!<Other>!$_"]){
            listPhoneModel.phoneType = @"其他";
        }else{
            listPhoneModel.phoneType = @"其他";
        }
        
        [listPhoneModelArr addObject:listPhoneModel];
        [listPhoneModel release];
    }
    //需要把数组里面最近使用的那一个电话号码放到第一个位置，这时候，需要与该联系人的通话记录数组相比较了
    //1.获取该联系人的通话记录数组
    NSArray *dialItemsArr = [HB_ContactInfoDialItemTool contactInfoDialItemArrWithRecordID:recordID];
    if (dialItemsArr.count) {//如果没有通话记录就不用移动了
        HB_ContactInfoDialItemModel *dialItemModel = dialItemsArr[0];
        for (int i=0; i<listPhoneModelArr.count; i++) {
            HB_PhoneNumModel *phoneNumModel = listPhoneModelArr[i];
            if ([phoneNumModel.phoneNum isEqualToString:dialItemModel.phoneNum]) {
                //把这个最近使用的电话号码移到第一个
                [listPhoneModelArr exchangeObjectAtIndex:0 withObjectAtIndex:i];
            }
        }
    }
    
    return listPhoneModelArr;
}
+(NSMutableArray *)convertPhoneTypeWithPhoneArrHBZSToSystem:(NSArray *)phoneArr{
    NSMutableArray *systemPhoneModelArr = [NSMutableArray array];
    
    for (int i=0; i<phoneArr.count; i++) {
        HB_PhoneNumModel *phoneModel = phoneArr[i];
        if (phoneModel.phoneNum.length==0) {
            continue;
        }
        HB_PhoneNumModel *systemPhoneModel = [[HB_PhoneNumModel alloc]init];
        systemPhoneModel.phoneNum = phoneModel.phoneNum;
        
        if ([phoneModel.phoneType isEqualToString:@"住宅"]) {
            systemPhoneModel.phoneType = @"_$!<Home>!$_";
        }else if ([phoneModel.phoneType isEqualToString:@"工作"]){
            systemPhoneModel.phoneType = @"_$!<Work>!$_";
        }else if ([phoneModel.phoneType isEqualToString:@"iPhone"]){
            systemPhoneModel.phoneType = @"iPhone";
        }else if ([phoneModel.phoneType isEqualToString:@"手机"]){
            systemPhoneModel.phoneType = @"_$!<Mobile>!$_";
        }
        else if ([phoneModel.phoneType isEqualToString:@"主要"]){
            systemPhoneModel.phoneType = @"_$!<Main>!$_";
        }
        else if ([phoneModel.phoneType isEqualToString:@"住宅传真"]){
            systemPhoneModel.phoneType = @"_$!<HomeFAX>!$_";
        }else if ([phoneModel.phoneType isEqualToString:@"工作传真"]){
            systemPhoneModel.phoneType = @"_$!<WorkFAX>!$_";
        }else if ([phoneModel.phoneType isEqualToString:@"传呼"]){
            systemPhoneModel.phoneType = @"_$!<Pager>!$_";
        }
//        else if ([phoneModel.phoneType isEqualToString:@"VPN"]){
//            systemPhoneModel.phoneType = (NSString *)kSABVPNLabel;
//        }
        else if ([phoneModel.phoneType isEqualToString:@"其他"]){
            systemPhoneModel.phoneType = @"_$!<Other>!$_";
        }
        else
        {
            systemPhoneModel.phoneType = @"_$!<Other>!$_";
        }
        
        [systemPhoneModelArr addObject:systemPhoneModel];
        [systemPhoneModel release];
    }
    
    return systemPhoneModelArr;
}

+(NSString *)convertPhoneTypePhoneSystemToHBZS:(NSString *)typeString
{
    NSString * str;
    if ([typeString isEqualToString:@"_$!<Home>!$_"]) {
        str = [NSString stringWithFormat:@"住宅"];
    }else if ([typeString isEqualToString:@"_$!<Work>!$_"]){
        str = [NSString stringWithFormat: @"工作"];
    }else if ([typeString isEqualToString:@"iPhone"]){
        str = [NSString stringWithFormat:@"iPhone"];
    }else if ([typeString isEqualToString:@"_$!<Mobile>!$_"]){
        str = [NSString stringWithFormat: @"手机"];
    }else if ([typeString isEqualToString:@"_$!<Main>!$_"]){
        str = [NSString stringWithFormat: @"主要"];
    }else if ([typeString isEqualToString:@"_$!<HomeFAX>!$_"]){
        str = [NSString stringWithFormat: @"住宅传真"];
    }else if ([typeString isEqualToString:@"_$!<WorkFAX>!$_"]){
        str = [NSString stringWithFormat: @"工作传真"];
    }else if ([typeString isEqualToString:@"_$!<Pager>!$_"]){
        str = [NSString stringWithFormat: @"传呼"];
    }
//    else if ([typeString isEqualToString:(NSString *)kSABVPNLabel]){
//        str = [NSString stringWithFormat: @"VPN"];
//    }
    else if ([typeString isEqualToString:@"_$!<Other>!$_"]){
        str = [NSString stringWithFormat: @"其他"];
    }else{
        str = [NSString stringWithFormat: @"其他"];
    }
    return str;
}

+(NSString *)convertPhoneTypeHBZSToPhoneSystem:(NSString *)HBZStype
{
    NSString * str;
    if ([HBZStype isEqualToString:@"住宅"]) {
        str = [NSString stringWithFormat:@"_$!<Home>!$_"];
    }else if ([HBZStype isEqualToString:@"工作"]){
        str = [NSString stringWithFormat: @"_$!<Work>!$_"];
    }else if ([HBZStype isEqualToString:@"iPhone"]){
        str = [NSString stringWithFormat:@"iPhone"];
    }else if ([HBZStype isEqualToString:@"手机"]){
        str = [NSString stringWithFormat: @"_$!<Mobile>!$_"];
    }else if ([HBZStype isEqualToString:@"主要"]){
        str = [NSString stringWithFormat: @"_$!<Main>!$_"];
    }else if ([HBZStype isEqualToString:@"住宅传真"]){
        str = [NSString stringWithFormat: @"_$!<HomeFAX>!$_"];
    }else if ([HBZStype isEqualToString:@"工作传真"]){
        str = [NSString stringWithFormat: @"_$!<WorkFAX>!$_"];
    }else if ([HBZStype isEqualToString:@"传呼"]){
        str = [NSString stringWithFormat: @"_$!<Pager>!$_"];
    }
//    else if ([HBZStype isEqualToString:@"VPN"]){
//        str = [NSString stringWithFormat: (NSString *)kSABVPNLabel];
//    }
    else if ([HBZStype isEqualToString:@"其他"]){
        str = [NSString stringWithFormat:@"_$!<Other>!$_"];
    }else{
        str = [NSString stringWithFormat: @"其他"];
    }
    return str;
}

@end
