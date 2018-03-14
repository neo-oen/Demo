//
//  WYQBaseTableView.m
//  TableView
//
//  Created by 王雅强 on 2018/3/13.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "WYQBaseTableView.h"

@interface WYQBaseTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WYQBaseTableView
static NSString *identifier = @"TableViewCell";
static NSString * identiString = @"headerView";

#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
/**
 接口
 
 @param model 输入的数据
 @return 返回成功与否
 */



//cell的增，删，改，移
-(BOOL)addTableSectionCellWithModel:(CellModel *) model{
    NSIndexPath * indexPath = self.indexPathForSelectedRow;
    if (!indexPath) {
        //在没有选中的情况下默认添加最后一行
        NSInteger section = self.groups.count-1;
        TableSectionModel * model = [self.groups lastObject];
        NSInteger row = model.cells.count;
        indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }
    
    return [self addTableSectionCellWithModel:model andIndexPath:indexPath];
}
-(BOOL)addTableSectionCellWithModel:(CellModel *) model andIndexPath:(NSIndexPath *)indexPath{
    TableSectionModel * sectionModel = self.groups[indexPath.section];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cells];
    [array insertObject:model atIndex:indexPath.row];
    sectionModel.cells = array;
    
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    return YES;
}
-(BOOL)deleteTableSectionCell{
    NSIndexPath * indexPath = self.indexPathForSelectedRow;
    if (!indexPath) {
        //在没有选中的情况下默认删除第一行
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    return [self deleteTableSectionCellWithIndexPath:indexPath];
    
}
-(BOOL)deleteTableSectionCellWithIndexPath:(NSIndexPath *)indexPath{
    TableSectionModel * sectionModel = self.groups[indexPath.section];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cells];
    if (array.count==1) {
        [self deleteTableSectionWithIndexSet:[NSIndexSet indexSetWithIndex:indexPath.section]];
        return YES;
    }
    [array removeObjectAtIndex:indexPath.row];
    sectionModel.cells = array;
    
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    return YES;
}

-(BOOL)changeTableSectionCellWithModel:(CellModel *) model andIndexPath:(NSIndexPath *)indexPath{
    TableSectionModel * sectionModel = self.groups[indexPath.section];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cells];
    [array replaceObjectAtIndex:indexPath.row withObject:model];
    sectionModel.cells = array;
    
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    return YES;
}

-(BOOL)moveTableSectionCellWithIndexPath:(NSIndexPath *)indexPathA toIndexPath:(NSIndexPath *)indexPathB{
    //判断是否是同一个section
    if (indexPathA.section==indexPathB.section) {
        TableSectionModel * sectionModel = self.groups[indexPathA.section];
        NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cells];
        [array exchangeObjectAtIndex:indexPathA.row withObjectAtIndex:indexPathB.row];
        sectionModel.cells = array;
    }else{
        TableSectionModel * sectionModelA = self.groups[indexPathA.section];
        TableSectionModel * sectionModelB = self.groups[indexPathB.section];
        NSMutableArray * arrayA = [NSMutableArray arrayWithArray:sectionModelA.cells];
        NSMutableArray * arrayB = [NSMutableArray arrayWithArray:sectionModelB.cells];
        
        CellModel *modelA = arrayA[indexPathA.row];
        
        
        [arrayB insertObject:modelA atIndex:indexPathB.row];
        [arrayA removeObjectAtIndex:indexPathA.row];
        sectionModelA.cells = arrayA;
        sectionModelB.cells = arrayB;
        if (arrayA.count == 0) {
            [self deleteTableSectionWithIndexSet:[NSIndexSet indexSetWithIndex:indexPathA.section]];
        }
    }
    [self moveRowAtIndexPath:indexPathA toIndexPath:indexPathB];
    //    //或使用先增加，再删除的方法
    //
    //    TableSectionModel * sectionModelA = self.models[indexPathA.section];
    //    NSArray * arrayA = [NSArray arrayWithArray:sectionModelA.cells];
    //    CellModel *modelA = arrayA[indexPathA.row];
    //
    //    [self deleteTableSectionCellWithIndexPath:indexPathA];
    //    [self addTableSectionCellWithModel:modelA andIndexPath:indexPathB];
    
    
    
    return YES;
}

//section的增，删，改，移

-(BOOL)addTableSectionSectionWithModel:(TableSectionModel *) model andIndexSet:(NSIndexSet *)indexSet{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.groups];
    [array insertObject:model atIndex:indexSet.lastIndex];
    self.groups = array;
    [self insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    return YES;
}


-(BOOL)deleteTableSectionWithIndexSet:(NSIndexSet *)indexSet{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.groups];
    [array removeObjectAtIndex:indexSet.lastIndex];
    self.groups = array;
    [self deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    return YES;
    
}


-(BOOL)changeTableSectionWithModel:(TableSectionModel *) model andIndexSet:(NSIndexSet *)indexSet{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.groups];
    [array replaceObjectAtIndex:indexSet.lastIndex withObject:model];
    self.groups = array;
    [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
    return YES;
}

-(BOOL)moveTableSectionWithSection:(NSInteger)sectionA toSection:(NSInteger)sectionB{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.groups];
    [array exchangeObjectAtIndex:sectionA withObjectAtIndex:sectionB];
    self.groups = array;
    [self moveSection:sectionA toSection:sectionB];
    
    return YES;
}


-(BOOL)reloadDataWithModel:(NSArray *)models{
    self.groups = models;
    [self reloadData];
    return YES;
}

-(void)setCellLineView:(UIView *)lineView{
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
TableSectionModel * group = self.groups[section];

return group.iscellHiddened?0:group.cells.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
return self.groups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // static 避免多次分配内存

    
    // 1. 到缓存池中去找cell
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    TableSectionModel * group = self.groups[indexPath.section];
    CellModel * CellModel = group.cells[indexPath.row];
    
    [cell updateTableViewCellWithModel:CellModel];
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableSectionModel * model = self.groups[indexPath.section];
    return [model.cells[indexPath.row] cellHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    TableSectionModel * model = self.groups[section];
    return model.footerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    TableSectionModel * model = self.groups[section];
    return model.headerHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"section=%ld,row=%ld",indexPath.section,indexPath.row);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    TableViewHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identiString];

    [headerView updateTableViewHeaderViewWithModel:self.groups[section]];
    
    __weak typeof(self) weekSelf = self;
    headerView.buttonCA = ^() {
        NSLog(@"%li",section);
        TableSectionModel * model = self.groups[section];
        model.cellHidden = !model.cellHidden;
        NSLog(@"%i",model.cellHidden);
        [weekSelf changeTableSectionWithModel:model andIndexSet:[NSIndexSet indexSetWithIndex:section]];
        
    };
    
    
    return headerView;
}




#pragma mark - ============== 设置 ==============

- (instancetype)init
{
    self = [super init];
    
    [self tableView];

    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
   self = [super initWithFrame:frame style:style];
    
        [self tableView];
    
    return self;
}


-(void)tableView{
    self.delegate = self;
    self.dataSource = self;
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self registerClass:TableViewCell.class forCellReuseIdentifier:identifier];
    [self registerClass:TableViewHeaderView.class forHeaderFooterViewReuseIdentifier:identiString];
}
@end
