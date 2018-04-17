//
//  HB_ContactListDataSource.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/26.
//
//

/**
 ‘全部联系人’‘未分组’‘管理分组’对应的groupID（自己构造的）
 */
typedef enum {
    KSelectViewAllContactGroupID = -100 , //‘全部联系人’对应的groupID（自己构造的）
    KSelectViewNoGroupID = -101 , //‘未分组’对应的groupID（自己构造的）
    KSelectViewGroupManageGroupID = -102 //‘管理分组’对应的groupID（自己构造的）
}KSelectViewCustomerGroupIDType;

#import "HB_ContactListDataSource.h"
#import "HB_ContactCell.h"
#import "HB_ContactModel.h"//联系人模型
#import "HB_ContactSendTopTool.h"//联系人置顶工具
#import "HB_ContactDataTool.h"//通讯录工具
#import "pinyin.h"
#import "GroupData.h"//分组管理工具
#import "ContactItems.h"//包含了分组模型
#import "NSString+Extension.h"
#import "ContactProtoToContactModel.h"
#import "HB_NameToPinyin.h"
@interface HB_ContactListDataSource ()
/**  ‘我的名片’数组（其实只有一个元素） */
@property(nonatomic,retain)NSMutableArray *myCardArr;
/**  置顶联系人Model数组 */
@property(nonatomic,retain)NSMutableArray *topContactArr;
/**  除去置顶联系人后的 其余的联系人Model数组 */
@property(nonatomic,retain)NSMutableArray *otherContactArr;
/**  未分组联系人Model数组 */
@property(nonatomic,retain)NSMutableArray *noGroupContactArr;

@end

@implementation HB_ContactListDataSource
-(void)dealloc{
    [_myCardArr release];
    [_topContactArr release];
    [_otherContactArr release];
    [_noGroupContactArr release];
    [_dataArr release];
    [super dealloc];
}
/**
 *  初始化dataArr
 */
-(void)initDataArr{
    [self.dataArr removeAllObjects];
    for (int i=0; i<28; i++) {//、‘置顶联系人’、'A'~'Z','#'  新版本去掉'我的名片'2016-10-27
        NSMutableArray * groupArr =[NSMutableArray array];
        [self.dataArr addObject:groupArr];
    }
    self.myCardArr=nil;
    self.topContactArr=nil;
    self.otherContactArr=nil;
    self.noGroupContactArr=nil;
}
#pragma mark - TableView dataSource方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HB_ContactCell * cell=[HB_ContactCell cellWithTableView:tableView];
    HB_ContactSimpleModel * simpleModel = self.dataArr[indexPath.section][indexPath.row];
    cell.contactModel=simpleModel;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSString * str;
    if (self.topContactArr.count) {
        str = [NSString stringWithFormat:@"★"];
    }
    else
    {
        str = [NSString stringWithFormat:@"☆"];
    }
    NSArray * sectionIndexTitles = [[NSArray alloc]initWithObjects:str,
                                    @"A", @"B", @"C", @"D",
                                    @"E", @"F", @"G",
                                    @"H", @"I", @"J", @"K", @"L", @"M", @"N",
                                    @"O", @"P", @"Q", @"R", @"S", @"T", @"U",
                                    @"V",@"W", @"X", @"Y", @"Z",  @"#",nil];
    tableView.sectionIndexColor=COLOR_F;
    return [sectionIndexTitles autorelease];
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;// 是因为“个人名片”“置顶”不需要索引 去掉个人名片
}
#pragma mark - private methods
/**
 *  根据groupID获取当前分组的联系人model数组
 */
-(NSArray *)getContactArrWithGroupID:(NSInteger)groupID{
    //1.获取当前分组下所有联系人的recordID
    NSMutableArray * recordIDArr = [GroupData getGroupAllContactIDByID:groupID];
    //2.联系人数组
    NSMutableArray * contactArr =[[[NSMutableArray alloc]init] autorelease];
    for (int i=0; i<recordIDArr.count; i++) {
        NSString * contactID =recordIDArr[i];
        NSDictionary * dict = [HB_ContactDataTool contactSimplePropertyArrWithRecordID:contactID.intValue];
        HB_ContactSimpleModel *model=[[HB_ContactSimpleModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [contactArr addObject:model];
        [model release];
    }
    return contactArr;
}
/**
 *  将数组中的所有联系人model，分组后添加到dataArr
 */
-(void)addDataToDataArrWithContactArr:(NSArray *)contactArr{
    
    NSMutableArray * firstZiMuArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * firsthanziArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * firstShuziArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * firstotherArr = [NSMutableArray arrayWithCapacity:0];
    
    for (HB_ContactSimpleModel * model in contactArr) {
      
        unichar firstChar = [model.name  characterAtIndex:0];
        if ((firstChar>= 'A' && firstChar<='Z')||(firstChar>= 'a' && firstChar<='z')) {
            [firstZiMuArr addObject:model];
        }
        else{
            unichar firstPinyinChar = [model.PinyinName characterAtIndex:0];
            if ((firstPinyinChar>= 'A' && firstPinyinChar<='Z')||(firstPinyinChar>= 'a' && firstPinyinChar<='z'))
            {
                [firsthanziArr addObject:model];
            }
            else if (firstPinyinChar>='0'&&firstPinyinChar<='9')
            {
                [firstShuziArr addObject:model];
            }
            else
            {
                [firstotherArr addObject:model];
            }
        }
        
    }
    
    NSArray * sortedZiMuArr = [self arrsortBypinyin:firstZiMuArr];
    NSArray * sortedhanziArr = [self arrsortBypinyin:firsthanziArr];
    
    for (int i=0; i<sortedZiMuArr.count; i++) {
        HB_ContactSimpleModel *model = sortedZiMuArr[i];
        //取出大写首字母
        NSString * firststring = [[model.name substringToIndex:1] uppercaseString];
        char firstChar = [firststring characterAtIndex:0];
        //根据首字母，找到对应的字母分组
        NSMutableArray *letterArr = self.dataArr[firstChar-'A'+1];
        [letterArr addObject:model];
    }
    
    for (int i=0; i<sortedhanziArr.count; i++) {
        HB_ContactSimpleModel *model = sortedhanziArr[i];
        //取出大写首字母
        char firstChar = [model.PinyinName  characterAtIndex:0];
        //根据首字母，找到对应的字母分组
        NSMutableArray *letterArr = self.dataArr[firstChar-'A'+1];
        [letterArr addObject:model];
     
    }
    
    [self.dataArr.lastObject addObjectsFromArray: [self arrsortBynumber:firstShuziArr]];
    [self.dataArr.lastObject addObjectsFromArray:[self arrsortByUnicod:firstotherArr]];
    
    
}
#pragma mark - public methods
/**
 *  刷新数据源（全部联系人）
 */
-(void)refreshDataSource{
    // 改为当前分组
    if (self.groupID) {
        self.groupID=self.groupID;

    }
    else
    {
        //设置id为查询所有联系人
        self.groupID = KSelectViewAllContactGroupID ;
    }
}
/**
 *  数据源是否为空
 */
-(BOOL)dataArrIsNull{
    __block BOOL ret = YES;
    [self.dataArr enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
        NSArray *arr=(NSArray *)obj;
        if (arr.count) {
            ret = NO;
        }
    }];
    return ret;
}
#pragma mark - setter and getter
/**
 *  根据groupID查询包含的联系人（-100表示全部联系人，-101表示未分组联系人）
 */
-(void)setGroupID:(NSInteger)groupID{
    //清空数据源
    [self initDataArr];
    _groupID=groupID;
    switch (groupID) {
        case KSelectViewAllContactGroupID:{//‘全部联系人’
//            //把‘我的名片’‘置顶联系人’‘其余联系人’按照首字母分组，并加入数据源
//            [self.dataArr[0] addObjectsFromArray:self.myCardArr];
            
            //除去置顶联系人后的，其余联系人，按首字母分组添加
            [self addDataToDataArrWithContactArr:self.otherContactArr];
            //'置顶联系人'
            [self.dataArr[0] addObjectsFromArray:self.topContactArr];
        }break;
        case KSelectViewNoGroupID:{//‘未分组’
            [self addDataToDataArrWithContactArr:self.noGroupContactArr];
        }break;
        default:{//真正的某一个分组的联系人
            [self addDataToDataArrWithContactArr:[self getContactArrWithGroupID:_groupID]];
        }break;
    }
}
-(NSMutableArray *)myCardArr{
    if (!_myCardArr) {
        _myCardArr = [[NSMutableArray alloc]init];
        //1.创建一个HB_ContactSimpleModel的对象，来封装一些“个人名片”的一些数据
        HB_ContactSimpleModel *myCardModel = [[HB_ContactSimpleModel alloc]init];
        myCardModel.name=@"我的名片";
        myCardModel.contactID=@"myCard";
        //2.获取本地存储的个人名片信息，如果有图片就加载，否则加载默认
//        HB_ContactModel * contactModel = [[NSUserDefaults standardUserDefaults] objectForKey:@"myCard"];
        Contact * MeContact = [[MemAddressBook getInstance] myCard];
        HB_ContactModel * contactModel = [[ContactProtoToContactModel shareManager] memMycardToContactModel:MeContact];
        if (contactModel.iconData_thumbnail.length) {
            myCardModel.iconData_thumbnail=contactModel.iconData_thumbnail;
        }else{
            NSData * iconData=UIImagePNGRepresentation([UIImage imageNamed:@"默认联系人头像"]);
            myCardModel.iconData_thumbnail=iconData;
        }
        [_myCardArr addObject:myCardModel];
        [myCardModel release];
    }
    return _myCardArr;
}
-(NSMutableArray *)topContactArr{
    if (!_topContactArr) {
        _topContactArr=[[NSMutableArray alloc]init];
        
        for (NSInteger i =1; i<self.dataArr.count; i++) {
            NSMutableArray * letterArr = [self.dataArr objectAtIndex:i];
            for (NSInteger j = 0;j<letterArr.count;j++) {
                HB_ContactSimpleModel *model = letterArr[j];
                BOOL istop = [HB_ContactSendTopTool contactIsSendTopWithRecordID:model.contactID.integerValue];
                if (istop) {
                    
                    [_topContactArr addObject:model];
                    [letterArr removeObject:model];
                    j--;
                }
            }
        }
        
        
//        NSMutableArray * firstZiMuarr = [NSMutableArray arrayWithCapacity:0];
//        NSMutableArray * firsthanzi = [NSMutableArray arrayWithCapacity:0];
//        NSMutableArray * firstShuzi = [NSMutableArray arrayWithCapacity:0];
//        NSMutableArray * firstother = [NSMutableArray arrayWithCapacity:0];
//
//        //遍历字典，转化成联系人模型
//        [recordIDArr enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
//            NSDictionary * modelDict = [HB_ContactDataTool contactSimplePropertyArrWithRecordID:[recordIDArr[idx] intValue]];
//            HB_ContactSimpleModel * model =[[HB_ContactSimpleModel alloc]init];
//            [model setValuesForKeysWithDictionary:modelDict];
//            unichar firstChar = [model.name  characterAtIndex:0];
//
//            if ((firstChar>= 'A' && firstChar<='Z')||(firstChar>= 'a' && firstChar<='z')) {
//                [firstZiMuarr addObject:model];
//            }
//            else
//            {
//                unichar nozimufirstChar  = [model.PinyinName characterAtIndex:0];
//
//                if ((nozimufirstChar>= 'A' && nozimufirstChar<='Z')||(nozimufirstChar>= 'a' && nozimufirstChar<='z')) {
//                    [firsthanzi addObject:model];
//                }
//                else if(nozimufirstChar>='0'&&nozimufirstChar<='9')
//                {
//                    [firstShuzi addObject:model];
//                }
//                else
//                {
//                    [firstother addObject:model];
//                }
//
//            }
//
//            [model release];
//        }];
//
//        [_topContactArr addObjectsFromArray: [self arrsortBypinyin:firstZiMuarr]];
//        [_topContactArr addObjectsFromArray: [self arrsortBypinyin:firsthanzi]];
//        [_topContactArr addObjectsFromArray: [self arrsortBynumber:firstShuzi]];
//        [_topContactArr addObjectsFromArray: [self arrsortByUnicod:firstother]];

//        //按首字母排序
//        [_topContactArr sortUsingComparator:^NSComparisonResult(id   obj1, id   obj2) {
//            HB_ContactSimpleModel *model1=(HB_ContactSimpleModel*)obj1;
//            HB_ContactSimpleModel *model2=(HB_ContactSimpleModel*)obj2;
//            return [model1.name localizedStandardCompare:model2.name];
//
//        }];
    }
    return _topContactArr;
}
-(NSMutableArray *)otherContactArr{
    if (!_otherContactArr) {
        _otherContactArr=[[NSMutableArray alloc]init];
       
        NSArray * contactArr = [HB_ContactDataTool contactGetAllContactSimpleProperty];
        [contactArr enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
            //1.字典转模型
            NSDictionary * simplePropertyDict =contactArr[idx];
            HB_ContactSimpleModel * simpleModel=[[HB_ContactSimpleModel alloc]init];
            [simpleModel setValuesForKeysWithDictionary:simplePropertyDict];
            [_otherContactArr addObject:simpleModel];
            
            [simpleModel release];
        }];
    }
    return _otherContactArr;
}
-(NSMutableArray *)noGroupContactArr{
    if (!_noGroupContactArr) {
        _noGroupContactArr = [[NSMutableArray alloc]init];
        //1.获取所有联系人id
        NSMutableArray *allContactID=[[HB_ContactDataTool contactGetAllContactID] mutableCopy];
        //2.遍历查找每一个联系人所在的群组个数，如果不为0，则从数组中删除，反之，则是未分组的联系人
        for (int i=allContactID.count-1; i>=0 ; i--) {
            NSNumber *numberObj=allContactID[i];
            NSInteger contactID = numberObj.integerValue;
            NSArray *currentGroupArr=[GroupData getAllGroupsIDByContactID:contactID];
            if (currentGroupArr.count) {
                [allContactID removeObject:numberObj];
            }else{
                //如果没有分组，则是未分组联系人，根据其id构造模型，添加到数组中去
                NSDictionary * dict = [HB_ContactDataTool contactSimplePropertyArrWithRecordID:contactID];
                HB_ContactSimpleModel *model=[[HB_ContactSimpleModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_noGroupContactArr addObject:model];
                [model release];
            }
        }
        [allContactID release];
    }
    return _noGroupContactArr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}


-(NSArray *)arrsortBypinyin:(NSMutableArray *)temparr
{
    [temparr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HB_ContactSimpleModel * model1 = (HB_ContactSimpleModel *)obj1;
        HB_ContactSimpleModel * model2 = (HB_ContactSimpleModel *)obj2;
        return [model1.PinyinName compare:model2.PinyinName];
    }];
    return temparr;
}

-(NSArray *)arrsortByUnicod:(NSMutableArray *)temparr
{
    [temparr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HB_ContactSimpleModel * model1 = (HB_ContactSimpleModel *)obj1;
        HB_ContactSimpleModel * model2 = (HB_ContactSimpleModel *)obj2;
        if ([model1.name characterAtIndex:0] > [model2.name characterAtIndex:0])
        {
            return NSOrderedDescending;
        }
        else if([model1.name characterAtIndex:0] < [model2.name characterAtIndex:0])
        {
            return NSOrderedAscending;
        }
        else
        {
            return [model1.name compare:model2.name];
        }
        
    }];
    return  temparr;
}
-(NSArray *)arrsortBynumber:(NSMutableArray *)temparr
{
    [temparr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HB_ContactSimpleModel * model1 = (HB_ContactSimpleModel *)obj1;
        HB_ContactSimpleModel * model2 = (HB_ContactSimpleModel *)obj2;
        if ([model1.name substringToIndex:1].integerValue > [model2.name substringToIndex:1].integerValue)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
        
    }];
    return temparr;
}



@end
