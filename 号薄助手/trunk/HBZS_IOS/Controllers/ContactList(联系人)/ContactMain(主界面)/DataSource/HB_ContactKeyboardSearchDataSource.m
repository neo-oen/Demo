//
//  HB_ContactKeyboardSearchDataSource.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/24.
//
//

#import "HB_ContactKeyboardSearchDataSource.h"
#import "HB_ContactDataTool.h"
#import "HB_ContactSimpleModel.h"
#import "NSString+Extension.h"
#import "HB_ContactCell.h"

@implementation HB_ContactKeyboardSearchDataSource

#pragma mark - life cycle

-(void)dealloc{
    [_dataArr release];
    [_searchText release];
    [super dealloc];
}

#pragma mark - tableView datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_ContactCell *cell=[HB_ContactCell cellWithTableView:tableView];
    cell.contactModel=self.dataArr[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

#pragma mark - getter and getter 

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(void)setSearchText:(NSString *)searchText{
    _searchText=[searchText retain];
    [self.dataArr removeAllObjects];
    //1、获得字典数组
    NSArray *contactDictArr= [HB_ContactDataTool contactGetAllContactSimpleProperty];
    //2、转为模型数组  (HB_ContactSimpleModel)类型   并添加到所有联系人
    for (int i=0; i<contactDictArr.count ; i++) {
        HB_ContactSimpleModel * model=[[HB_ContactSimpleModel alloc]init];
        [model setValuesForKeysWithDictionary:contactDictArr[i]];
        [self.dataArr addObject:model];
        [model release];
    }
    for (int i=0; i<self.dataArr.count; i++) {
        HB_ContactSimpleModel * model=self.dataArr[i];
        NSString * nameStrPinYin=[model.name chineseToPinYin];
        //1.姓名长度小于搜索长度的模型，删除
        if (nameStrPinYin.length<searchText.length) {
            [self.dataArr removeObject:model];
            i -= 1;
            continue;
        }
        //2.比较前几位是否相同，不同的模型，删除
        if ([[nameStrPinYin substringToIndex:searchText.length] compare:searchText options:NSCaseInsensitiveSearch]==0) {
            //不操作
        }else{
            [self.dataArr removeObject:model];
            i-=1;
        }
    }
}


@end
