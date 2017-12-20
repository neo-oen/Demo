//
//  TableSectionView.m
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableSectionView.h"
#import "TableSectionModel.h"
#import "TableViewCell.h"
#import "TableViewHeaderView.h"
#import "CellModel.h"
#import "Public.h"



@interface TableSectionView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)UITableViewStyle style ;



@end

@implementation TableSectionView

#pragma mark - ============== 懒加载 ==============
-(UITableView *)tableView
{
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:_style];
    //是否等宽高
        [_tableView setRowHeight:30];
        [_tableView setSectionFooterHeight:30];
        [_tableView setSectionHeaderHeight:30];
//        [_tableView setEditing:NO];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        TableViewCell * cell = [TableViewCell cellWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"TableViewCell"];//用来注册cell,在当堆栈里没有cell使用，就会根据reuseId直接调用生成新的。
//        [_tableView registerClass:cell forCellReuseIdentifier:@"TableViewCell"];
        [self addSubview:_tableView];
    }
    return _tableView;
}


#pragma mark - ============== 初始化 ==============

/**
 初始化view
 */


+(TableSectionView *)TableSectionWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style andModel:(NSArray *)models{

    TableSectionView * TableSectionView = [[self alloc]initWithFrame:frame];
    TableSectionView.style = style;
    [TableSectionView updateTableSectionViewWithModel:models];
    return TableSectionView;
}

#pragma mark - ============== 更新视图 ==============
/**
 根据资源，更新View
 
 @param models 资源
 */
- (void)updateTableSectionViewWithModel:(NSArray *)models{

    self.tableView;
    _models = models;
    
}




#pragma mark - ============== 接口 ==============


/**
 接口
 
 @param model 输入的数据
 @return 返回成功与否
 */



//cell的增，删，改，移
-(BOOL)addTableSectionCellWithModel:(CellModel *) model{
    NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
    if (!indexPath) {
        //在没有选中的情况下默认添加最后一行
        NSInteger section = self.models.count-1;
        TableSectionModel * model = [self.models lastObject];
        NSInteger row = model.cells.count;
        indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }
    
    return [self addTableSectionCellWithModel:model andIndexPath:indexPath];
}
-(BOOL)addTableSectionCellWithModel:(CellModel *) model andIndexPath:(NSIndexPath *)indexPath{
    TableSectionModel * sectionModel = self.models[indexPath.section];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cells];
    [array insertObject:model atIndex:indexPath.row];
    sectionModel.cells = array;
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    return YES;
}
-(BOOL)deleteTableSectionCell{
    NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
    if (!indexPath) {
        //在没有选中的情况下默认删除第一行
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    return [self deleteTableSectionCellWithIndexPath:indexPath];
    
}
-(BOOL)deleteTableSectionCellWithIndexPath:(NSIndexPath *)indexPath{
    TableSectionModel * sectionModel = self.models[indexPath.section];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cells];
    if (array.count==1) {
        [self deleteTableSectionWithIndexSet:[NSIndexSet indexSetWithIndex:indexPath.section]];
        return YES;
    }
    [array removeObjectAtIndex:indexPath.row];
    sectionModel.cells = array;
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    return YES;
}

-(BOOL)changeTableSectionCellWithModel:(CellModel *) model andIndexPath:(NSIndexPath *)indexPath{
    TableSectionModel * sectionModel = self.models[indexPath.section];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cells];
    [array replaceObjectAtIndex:indexPath.row withObject:model];
    sectionModel.cells = array;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    return YES;
}

-(BOOL)moveTableSectionCellWithIndexPath:(NSIndexPath *)indexPathA toIndexPath:(NSIndexPath *)indexPathB{
    //判断是否是同一个section
    if (indexPathA.section==indexPathB.section) {
        TableSectionModel * sectionModel = self.models[indexPathA.section];
        NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cells];
        [array exchangeObjectAtIndex:indexPathA.row withObjectAtIndex:indexPathB.row];
        sectionModel.cells = array;
    }else{
        TableSectionModel * sectionModelA = self.models[indexPathA.section];
        TableSectionModel * sectionModelB = self.models[indexPathB.section];
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
      [self.tableView moveRowAtIndexPath:indexPathA toIndexPath:indexPathB];
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
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.models];
    [array insertObject:model atIndex:indexSet.lastIndex];
    self.models = array;
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    return YES;
}


-(BOOL)deleteTableSectionWithIndexSet:(NSIndexSet *)indexSet{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.models];
    [array removeObjectAtIndex:indexSet.lastIndex];
    self.models = array;
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    return YES;
    
}


-(BOOL)changeTableSectionWithModel:(TableSectionModel *) model andIndexSet:(NSIndexSet *)indexSet{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.models];
    [array replaceObjectAtIndex:indexSet.lastIndex withObject:model];
    self.models = array;
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
    return YES;
}

-(BOOL)moveTableSectionWithSection:(NSInteger)sectionA toSection:(NSInteger)sectionB{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.models];
    [array exchangeObjectAtIndex:sectionA withObjectAtIndex:sectionB];
    self.models = array;
    [self.tableView moveSection:sectionA toSection:sectionB];
    
    return YES;
}

-(BOOL)reloadData{
    [self.tableView reloadData];
    return YES;
}
-(BOOL)reloadDataWithModel:(NSArray *)models{
    self.models = models;
    [self reloadData];
    return YES;
}
#pragma mark - ============== 方法 ==============

#pragma mark - ============== 代理 ==============
//dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TableSectionModel * model = self.models[section];
    
    return model.iscellHiddened?0:model.cells.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // static 避免多次分配内存
    static NSString *identifier = @"TableViewCell";
    
    // 1. 到缓存池中去找cell
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // 2. 判断是否取到， 如果取不到就实例化新的cell
    if (nil == cell) {
        // 实例化tableViewcell
        cell = [TableViewCell cellWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TableSectionModel * model = self.models[indexPath.section];
    CellModel * CellModel = model.cells[indexPath.row];
    
    [cell updateTableViewCellWithModel:CellModel];
    
    return cell;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.models[section] title] ;
//}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [self.models[section] desc];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    TableSectionModel * model = self.models[indexPath.section];
    return [model.cells[indexPath.row] cellHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    TableSectionModel * model = self.models[section];
    return model.footerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    TableSectionModel * model = self.models[section];
    return model.headerHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"section=%ld,row=%ld",indexPath.section,indexPath.row);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString * identiString = @"headerView";
    
    TableViewHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identiString];
    if (nil == headerView) {
        
        headerView = [TableViewHeaderView viewWithReuseIdentifier:identiString];
    }
        [headerView updateTableViewHeaderViewWithModel:self.models[section]];

    headerView.buttonCA = ^() {
        NSLog(@"%li",section);
        TableSectionModel * model = self.models[section];
        model.cellHidden = !model.cellHidden;
        NSLog(@"%i",model.cellHidden);
        [self changeTableSectionWithModel:model andIndexSet:[NSIndexSet indexSetWithIndex:section]];
        
    };
    

    return headerView;
}



@end


//@implementation TableSectionView
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end
