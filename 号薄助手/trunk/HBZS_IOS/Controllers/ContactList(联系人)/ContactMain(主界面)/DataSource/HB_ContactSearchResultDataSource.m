//
//  HB_ContactSearchResultDataSource.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/26.
//
//

#import "HB_ContactSearchResultDataSource.h"
#import "HB_ContactCell.h"
#import "SearchCoreManager.h"//搜索管理工具（第三方）
#import "ContactPeople.h"//搜索联系人的模型（第三方）
#import "HBZSAppDelegate.h"
#import "HB_ContactDataTool.h"//通讯录操作工具类


@interface HB_ContactSearchResultDataSource ()
/** 根据名字搜索出来的联系人id数组 */
@property(nonatomic,retain)NSMutableArray *searchByName;
/** 根据号码搜索出来的联系人id数组 */
@property(nonatomic,retain)NSMutableArray *searchByPhone;

@end

@implementation HB_ContactSearchResultDataSource
-(void)dealloc{
    [_dataArr release];
    [_searchText release];
    [_searchByName release];
    [_searchByPhone release];
    [super dealloc];
}
#pragma mark - dataSource数据源方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.backgroundColor=[UIColor whiteColor];
    HB_ContactCell * cell=[HB_ContactCell cellWithTableView:tableView];
    HB_ContactSimpleModel * model=self.dataArr[indexPath.row];
    cell.contactModel=model;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
#pragma mark - searchBar中的搜索方法
/**
 *   searchBar的搜索方法
 */
-(void)searchContactWithText:(NSString *)searchText{
    //1.清空搜索的结果
    [self.dataArr removeAllObjects];
    [self.searchByName removeAllObjects];
    [self.searchByPhone removeAllObjects];
    //2.重新搜索
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
    if (self.searchByName.count == 0 && self.searchByPhone.count == 0) {//没有搜索到联系人
        return;
    }
    [self sortArray];
    [self doNameSearch:searchText];//查找名字
    [self doPhoneSearch:searchText];//查找电话
}

/**
 *   netMessage搜索联系人专用搜索
 */
-(void)NetMsgSearchContactWithText:(NSString *)searchText{
    //1.清空搜索的结果
    [self.dataArr removeAllObjects];
    [self.searchByName removeAllObjects];
    [self.searchByPhone removeAllObjects];
    //2.重新搜索
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchByName phoneMatch:self.searchByPhone];
    if (self.searchByName.count == 0 && self.searchByPhone.count == 0) {//没有搜索到联系人
        return;
    }
    [self sortArray];
    [self doNameSearchforNetMsg:searchText];//查找名字
    [self doPhoneSearch:searchText];//查找电话
}

/**
 *  对searchByName数组和searchByPhone进行排序
 */
- (void)sortArray{
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"intValue" ascending:YES];
    NSArray *sortDescriptors3 = [NSArray arrayWithObject:sortDescriptor3];
    [self.searchByName sortUsingDescriptors:sortDescriptors3];
    [self.searchByPhone sortUsingDescriptors:sortDescriptors3];
    [sortDescriptor3 release];
}
/**
 *  根据姓名查找联系人id数组
 *
 *  @param searchText 名字
 */
- (void)doNameSearch:(NSString *)searchText{
    for (int i = 0; i < self.searchByName.count; i++) {
        //1.获得第i个联系人的localid，这个id是第三方库自带的
        NSNumber *localID = [self.searchByName objectAtIndex:i];
        //2.根据id来查找联系人(结果是ContactPeople模型，需要和HB_ContactSimpleModel转换)
        HBZSAppDelegate * delegate=(HBZSAppDelegate*)[UIApplication sharedApplication].delegate;
        ContactPeople *contactModel = [delegate.contactDic objectForKey:localID];
        //根据联系人id查找该联系人模型
        NSDictionary * propertyDict = [HB_ContactDataTool contactSimplePropertyArrWithRecordID:contactModel.contactId];
        HB_ContactSimpleModel * simpleModel=[[HB_ContactSimpleModel alloc]init];
        [simpleModel setValuesForKeysWithDictionary:propertyDict];
        
        //添加一个展示号码
        if (contactModel.phoneArray.count) {
            simpleModel.showNumber = contactModel.phoneArray.firstObject;
        }
        //3.加入搜索结果数组里面
        [self.dataArr addObject:simpleModel];
        [simpleModel release];
    }
}
/**
 *  根据姓名查找联系人id数组- 网络短信搜索联系人界面使用
 *
 *  @param NetMsgsearchText 名字
 */
- (void)doNameSearchforNetMsg:(NSString *)searchText{
    for (int i = 0; i < self.searchByName.count; i++) {
        //1.获得第i个联系人的localid，这个id是第三方库自带的
        NSNumber *localID = [self.searchByName objectAtIndex:i];
        //2.根据id来查找联系人(结果是ContactPeople模型，需要和HB_ContactSimpleModel转换)
        HBZSAppDelegate * delegate=(HBZSAppDelegate*)[UIApplication sharedApplication].delegate;
        ContactPeople *contactModel = [delegate.contactDic objectForKey:localID];
        //根据联系人id查找该联系人模型
        NSDictionary * propertyDict = [HB_ContactDataTool contactSimplePropertyArrWithRecordID:contactModel.contactId];
        
        
        //添加展示所有号码
        for (NSString * phonenum in contactModel.phoneArray) {
            HB_ContactSimpleModel * simpleModel=[[HB_ContactSimpleModel alloc]init];
            [simpleModel setValuesForKeysWithDictionary:propertyDict];
            simpleModel.showNumber = phonenum;
            
            //3.加入搜索结果数组里面
            [self.dataArr addObject:simpleModel];
            [simpleModel release];
        }
    }
}


/**
 *  根据号码查找联系人的id数组
 *
 *  @param searchText 号码
 */
- (void)doPhoneSearch:(NSString *)searchText{
    for (int i = 0; i < self.searchByPhone.count; i++) {
        //1.获得第i个id
        NSNumber *localID = [self.searchByPhone objectAtIndex:i];
        HBZSAppDelegate * delegate=(HBZSAppDelegate*)[UIApplication sharedApplication].delegate;
        ContactPeople *contactModel = [delegate.contactDic objectForKey:localID];
        //根据联系人id查找该联系人模型
        NSDictionary * propertyDict = [HB_ContactDataTool contactSimplePropertyArrWithRecordID:contactModel.contactId];
        HB_ContactSimpleModel * simpleModel=[[HB_ContactSimpleModel alloc]init];
        [simpleModel setValuesForKeysWithDictionary:propertyDict];
        //添加一个展示号码
        if (contactModel.phoneArray.count) {
            for (NSString * phonenum in contactModel.phoneArray) {
                NSRange range = [phonenum rangeOfString:searchText];
                if (range.location!=NSNotFound) {
                    simpleModel.showNumber = phonenum;
                    simpleModel.colorRange = range;
                }
            }
        }
        //3.加入搜索结果数组里面
        [self.dataArr addObject:simpleModel];
        [simpleModel release];
    }
}
#pragma mark - setter and getter
/**
 *  获取数据源数组
 */
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
/**
 *  设置搜索关键字
 */
-(void)setSearchText:(NSString *)searchText{
    _searchText=[searchText retain];
    //每一次设置关键字，都重新发起搜索
    [self searchContactWithText:searchText];
}
/**
 *  根据名字搜索的结果数组
 */
-(NSMutableArray *)searchByName{
    if (!_searchByName) {
        _searchByName=[[NSMutableArray alloc]init];
    }
    return _searchByName;
}
/**
 *  根据电话号码搜索的结果数组
 */
-(NSMutableArray *)searchByPhone{
    if (!_searchByPhone) {
        _searchByPhone=[[NSMutableArray alloc]init];
    }
    return _searchByPhone;
}


@end
