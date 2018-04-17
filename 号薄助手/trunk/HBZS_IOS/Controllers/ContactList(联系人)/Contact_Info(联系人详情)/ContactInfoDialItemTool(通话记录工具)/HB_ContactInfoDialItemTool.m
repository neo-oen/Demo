//
//  HB_ContactInfoDialItemTool.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/16.
//
//

#import "HB_ContactInfoDialItemTool.h"
#import "HB_ContactInfoDialItemModel.h"//详情页通话记录模型
#import "ContactItems.h"//里面包含了普通的通话记录模型
#import "SettingInfo.h"//全局的一些工具

@implementation HB_ContactInfoDialItemTool

+(NSArray *)contactInfoDialItemArrWithRecordID:(NSInteger)recordID{
    //用于存放最终的HB_ContactInfoDialItemModel模型
    NSMutableArray * mutableArr=[[[NSMutableArray alloc]init] autorelease];
    //1.获取所有通话记录数组
    NSArray * allDialItemsArr = [SettingInfo getDialItems];
    //2.找出对应当前联系人的所有通话记录数组
    NSMutableArray * currentRecordDialItemArr=[[NSMutableArray alloc]init];
    for (int i=0; i<allDialItemsArr.count; i++) {
        DialItem * dialItem=allDialItemsArr[i];
        if (dialItem.contactID==recordID) {
            [currentRecordDialItemArr addObject:dialItem];
        }
    }
    //3.根据currentRecordDialItemArr中的DialItem模型，来构造出每一个HB_ContactInfoDialItemModel模型
    for (int i=0; i<currentRecordDialItemArr.count; i++) {
        DialItem * dialItem=currentRecordDialItemArr[i];
        for (int j=0; j<dialItem.times.count; j++) {
            HB_ContactInfoDialItemModel *contactInfoDialItemModel=[[HB_ContactInfoDialItemModel alloc]init];
            contactInfoDialItemModel.name=dialItem.name;
            contactInfoDialItemModel.phoneNum=dialItem.phone;
            contactInfoDialItemModel.callDate=dialItem.times[j];
            [mutableArr addObject:contactInfoDialItemModel];
            [contactInfoDialItemModel release];
        }
    }
    //4.按照时间顺序排序展示
    [mutableArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HB_ContactInfoDialItemModel * model1=(HB_ContactInfoDialItemModel*)obj1;
        HB_ContactInfoDialItemModel * model2=(HB_ContactInfoDialItemModel*)obj2;
        NSComparisonResult result = [model1.callDate compare:model2.callDate];
        return result==NSOrderedAscending;//降序
    }];
    
    [currentRecordDialItemArr release];
    return mutableArr;
}

@end
