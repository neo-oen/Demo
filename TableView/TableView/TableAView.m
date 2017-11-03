//
//  TableSectionView.m
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableAView.h"
#import "TableSectionModel.h"
#import "CarModel.h"
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
-(BOOL)addTableSectionCellWithModel:(CarModel *) model{
    NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
    if (!indexPath) {
        //在没有选中的情况下默认添加最后一行
        NSInteger row = self.models.count-1;
        TableSectionModel * model = [self.models lastObject];
        NSInteger section = model.cars.count-1;
        indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }
    
    return [self addTableSectionCellWithModel:model andIndexPath:indexPath];
}
-(BOOL)addTableSectionCellWithModel:(CarModel *) model andIndexPath:(NSIndexPath *)indexPath{
    
    TableSectionModel * sectionModel = self.models[indexPath.section];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cars];
    [array insertObject:model atIndex:indexPath.row];
    sectionModel.cars = array;
    
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
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cars];
    [array removeObjectAtIndex:indexPath.row];
    sectionModel.cars = array;
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    return YES;
}

-(BOOL)changeTableSectionCellWithModel:(CarModel *) model andIndexPath:(NSIndexPath *)indexPath{
    TableSectionModel * sectionModel = self.models[indexPath.section];
    NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cars];
    [array replaceObjectAtIndex:indexPath.row withObject:model];
    sectionModel.cars = array;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    return YES;
}

-(BOOL)moveTableSectionCellWithIndexPath:(NSIndexPath *)indexPathA toIndexPath:(NSIndexPath *)indexPathB{
    if (indexPathA.section==indexPathB.section) {
        TableSectionModel * sectionModel = self.models[indexPathA.section];
        NSMutableArray * array = [NSMutableArray arrayWithArray:sectionModel.cars];
        [array exchangeObjectAtIndex:indexPathA.row withObjectAtIndex:indexPathB.row];
        sectionModel.cars = array;
    }else{
        TableSectionModel * sectionModelA = self.models[indexPathA.section];
        TableSectionModel * sectionModelB = self.models[indexPathB.section];
        NSMutableArray * arrayA = [NSMutableArray arrayWithArray:sectionModelA.cars];
        NSMutableArray * arrayB = [NSMutableArray arrayWithArray:sectionModelB.cars];
        
        CarModel *modelA = arrayA[indexPathA.row];
        CarModel *modelB = arrayA[indexPathB.row];
        
        [arrayA removeObjectAtIndex:indexPathA.row];
        
        [arrayB insertObject:model atIndex:indexPath.row];
        
    }
    
   
    
    return YES;
}

//section的增，删，改，移
-(BOOL)addTableSectionSectionWithModel:(TableSectionModel *) model{
    return YES;
}
-(BOOL)addTableSectionSectionWithModel:(TableSectionModel *) model andIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(BOOL)deleteTableSectionSection{
    return YES;
}
-(BOOL)deleteTableSectionSectionWithModel:(TableSectionModel *) model andIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


-(BOOL)changeTableSectionSectionWithModel:(TableSectionModel *) model andIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(BOOL)moveTableSectionSectionWithIndexPath:(NSIndexPath *)indexPathA toIndexPath:(NSIndexPath *)indexPathB{
    return YES;
}

-(BOOL)reloadData{
    return YES;
}
-(BOOL)reloadDataWithModel:(NSArray *)models{
    return YES;
}
#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============
//dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TableSectionModel * model = self.models[section];
    return model.cars.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // static 避免多次分配内存
    static NSString *identifier = @"fdsfdsfds";
    
    // 1. 到缓存池中去找cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // 2. 判断是否取到， 如果取不到就实例化新的cell
    if (nil == cell) {
        // 实例化tableViewcell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TableSectionModel * model = self.models[indexPath.section];
    CarModel * carModel = model.cars[indexPath.row];
    
    
       // 设置imageView
    cell.imageView.image = [UIImage imageNamed:carModel.icon];
    
    // 设置文本
    cell.textLabel.text = carModel.name;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.models[section] title] ;
}

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
    return [model.cars[indexPath.row] cellHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    TableSectionModel * model = self.models[section];
    return model.footerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    TableSectionModel * model = self.models[section];
    return model.headerHeight;
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
