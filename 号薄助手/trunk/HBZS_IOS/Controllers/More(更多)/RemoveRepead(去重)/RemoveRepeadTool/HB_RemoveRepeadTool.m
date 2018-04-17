//
//  HB_RemoveRepeadTool.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/18.
//
//

#import "HB_RemoveRepeadTool.h"
#import "HB_ContactDataTool.h"
#import "HB_ContactModel.h"
#import "HB_PhoneNumModel.h"
#import "HBZSAppDelegate.h"
@implementation HB_RemoveRepeadTool
-(void)dealloc{
    [super dealloc];
}
/**
 *  查找相同或者相似的联系人
 */
-(NSArray *)searchSameAndSimilarContact{
    //获取所有联系人id
    NSArray * allContactRecordID=[HB_ContactDataTool contactGetAllContactID];
    //取出每个联系人的所有属性
    NSMutableArray * allContactModelArr=[[NSMutableArray alloc]init];
    for (int i=0; i<allContactRecordID.count; i++) {
        NSDictionary * contactDict=[HB_ContactDataTool contactPropertyArrWithRecordID:[allContactRecordID[i] intValue]];
        HB_ContactModel * model=[[HB_ContactModel alloc]init];
        [model setValuesForKeysWithDictionary:contactDict];
        [allContactModelArr addObject:model];
        [model release];
    }
    //比较，找出相似或者相同的联系人数组
    int ArrCount = (int)allContactModelArr.count - 1;
    NSMutableArray * finalArr=[[[NSMutableArray alloc]init] autorelease];
    for (int i=ArrCount; i>0;  ) {
        HB_ContactModel * model1=allContactModelArr[i];
        NSMutableArray * tempArr=[[NSMutableArray alloc]init];
        [tempArr addObject:model1];
        for (int j=i-1; j>=0; j--) {
            HB_ContactModel * model2=allContactModelArr[j];
            //比较两个联系人是否相似或相同
            BOOL ret = [self compareContact1:model1 andContact2:model2];
            if (ret) {
                //如果相同，放一起
                [tempArr addObject:model2];
            }
        }
        if (tempArr.count>1) {
            //删除所有联系人（allContactModelArr）数组中的一些相同或者相似的联系人模型
            NSPredicate * predicate= [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",tempArr];
            NSArray * filterArr = [allContactModelArr filteredArrayUsingPredicate:predicate];
            allContactModelArr=[filterArr mutableCopy];
            //添加到重复联系人数组中，这个也是最终要返回的数组
            [finalArr addObject:tempArr];
            i-=tempArr.count;
            [tempArr release];
        }else{
            i--;
            [tempArr release];
        }
        if (i%10==0) {
            if ([self.delegate respondsToSelector:@selector(removeRepeadTool:compeletPercent:)]) {
                
                [self.delegate removeRepeadTool:self compeletPercent:0.8-i*0.8/ArrCount];
            }
        }
        
    }
    
    [allContactModelArr release];
    return finalArr;
}
/**
 *  比较两个联系人是否 相似
 */
-(BOOL)compareContact1:(HB_ContactModel * )contact1 andContact2:(HB_ContactModel *)contact2{
    /*
     名字作为第一条件，如果名字相同，就不用往下比较了。return YES;
     如果电话有重复，就不用往下比较了。return YES;
     */
    //名字是否相同
    NSString * name1=[[NSString alloc] initWithFormat:@"%@%@",contact1.lastName.length?contact1.lastName:@"",contact1.firstName.length?contact1.firstName:@""];
    //[NSString stringWithFormat:@"%@%@",contact1.lastName.length?contact1.lastName:@"",contact1.firstName.length?contact1.firstName:@""];
    NSString * name2= [[NSString alloc] initWithFormat:@"%@%@",contact2.lastName.length?contact2.lastName:@"",contact2.firstName.length?contact2.firstName:@""];
    
    //[NSString stringWithFormat:@"%@%@",contact2.lastName.length?contact2.lastName:@"",contact2.firstName.length?contact2.firstName:@""];
    
    if ([name1 isEqualToString:name2]) {
        [name1 release];
        [name2 release];
        return YES;
    }
    [name1 release];
    [name2 release];
    //手机号码是否相同
    NSArray * phoneArr1=contact1.phoneArr;
    NSArray * phoneArr2=contact2.phoneArr;
    for (int k=0; k<phoneArr1.count; k++) {
        HB_PhoneNumModel *phoneModel1 = phoneArr1[k];
        for (int l=0; l<phoneArr2.count; l++) {
            HB_PhoneNumModel *phoneModel2 = phoneArr2[l];
            if ([phoneModel1.phoneNum isEqualToString:phoneModel2.phoneNum]) {
                return YES;
            }
        }
    }
    //邮箱是否相同

    //地址是否相同
    return NO;
}
-(NSString *)contactGetFullNameWithModel:(HB_ContactModel*)model{
    
    NSString * name = [NSString stringWithFormat:@"%@%@",model.lastName,model.firstName];
    return name;
}

-(NSArray *)filterContactArr{
    
    [[HBZSAppDelegate getAppdelegate] setIsSyncOperatingOrRemovingRepead:YES];
    //获取所有的相同的或者相似的联系人数组
    NSArray *allContactArr = [self searchSameAndSimilarContact];
    NSInteger repeadCount=0;
    NSInteger similarCount=0;
    NSMutableArray * mutableArr=[[allContactArr mutableCopy] autorelease];
    NSInteger muArrcount = mutableArr.count;
    for (NSInteger i=mutableArr.count-1; i>=0; i--) {
        NSMutableArray * oneContactArr=mutableArr[i];
        //判断这个联系人数组中的联系人是不是完全相同的
        for (NSInteger j=oneContactArr.count-1; j>0; ) {
            NSInteger removeNum=0;
            HB_ContactModel * model1=oneContactArr[j];
            for (NSInteger k=j-1; k>=0; k--) {
                HB_ContactModel * model2=oneContactArr[k];
                BOOL ret =[self isSameWithContact1:model1 andContact2:model2];
                if (ret) {
                    //如果是完全相同，则删除靠后的那个重复联系人
                    [oneContactArr removeObject:model2];
                    [HB_ContactDataTool contactDeleteContactByID:model2.contactID.intValue];
                    removeNum++;//用来确定j的值应该怎么变化
                    repeadCount++;//用来统计删了几个联系人
                }
            }
            if (oneContactArr.count==1) {
                //如果此时这个数组中的联系人只剩一个了，则可以把该数组移出了，因为它里面的模型不再有人跟它重复或者相似了。
                [mutableArr removeObject:oneContactArr];
            }
            if (removeNum) {
                j -= removeNum;
            }else{
                j--;
            }
        }
        if (i%5 == 0) {
            if ([self.delegate respondsToSelector:@selector(removeRepeadTool:compeletPercent:)]) {
                
                [self.delegate removeRepeadTool:self compeletPercent:(0.2-i*0.2/muArrcount)+0.8];
            }
        }
    }
    /*这里有点问题需要解释
     1.假如删除了4个联系人，那么应该给系统提示说：已经合并5个联系人。
     这里repeadCount代表了删除几个联系人，所以应该+1;但是，如果删除了0个联系人，
     就不应该再+1了，所以应该有如下判断:
     */
    if (repeadCount) {
        repeadCount++;
    }
    //当前还剩下的联系人个数
    for (int i=0; i<mutableArr.count; i++) {
        NSMutableArray * arr=mutableArr[i];
        similarCount += arr.count;
    }
    HBZSAppDelegate * delegate = [HBZSAppDelegate getAppdelegate];
   
    [delegate initSearchContactData];//合并结束刷新数据
    [delegate setIsSyncOperatingOrRemovingRepead:NO];
    
    if ([self.delegate respondsToSelector:@selector(removeRepeadTool:didFinishFilterContactArrWithRepeadCount:andSimilarCount:)]) {
        
        [self.delegate removeRepeadTool:self didFinishFilterContactArrWithRepeadCount:repeadCount andSimilarCount:similarCount];
    }
    
    
    return mutableArr;
}
/**
 *  比较两个联系人是否相同
 */
-(BOOL)isSameWithContact1:(HB_ContactModel * )contact1 andContact2:(HB_ContactModel *)contact2{
    //名字是否相同
    NSString * name1=[HB_ContactDataTool contactGetFullNameWithModel:contact1];
    NSString * name2=[HB_ContactDataTool contactGetFullNameWithModel:contact2];
    if (![name1 isEqualToString:name2]) {
        return NO;
    }
    //手机号码是否相同
    if (contact1.phoneArr.count != contact2.phoneArr.count) {
        return NO;
    }else{
        //从电话号码模型数组中取出纯电话号码的数组
        NSMutableArray *phoneArr1 = [NSMutableArray array];
        [contact1.phoneArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HB_PhoneNumModel *model = (HB_PhoneNumModel *)obj;
            [phoneArr1 addObject:model.phoneNum];
        }];
        NSMutableArray *phoneArr2 = [NSMutableArray array];
        [contact2.phoneArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HB_PhoneNumModel *model = (HB_PhoneNumModel *)obj;
            [phoneArr2 addObject:model.phoneNum];
        }];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)",phoneArr1];
        NSArray *resultArr = [phoneArr2 filteredArrayUsingPredicate:predicate];
    
        return resultArr.count == 0 ? YES:NO;
    }
}


@end
