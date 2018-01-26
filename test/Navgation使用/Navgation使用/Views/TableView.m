//
//  TableView.m
//  Navgation使用
//
//  Created by neo on 2018/1/19.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "TableView.h"
#import "TableViewCell.h"

static NSString * identifier = @"tabelViewCell";

@interface TableView ()<UITableViewDataSource,UITableViewDelegate>



@end

@implementation TableView


#pragma mark - ============== 懒加载 ==============


#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
-(BOOL)addManWithModel:(CellModel *) model;{
    NSIndexPath * path = [NSIndexPath indexPathForRow:(self.models.count) inSection:0];
    [self addManWithModel:model andIndexPath:path];
    return YES;
}

-(BOOL)addManWithModel:(CellModel *) model andIndexPath:(NSIndexPath *) indexPath{
    /*
     1.把model添加到指定的位置上。
     1.判断model要添加到哪里。
     2.取出model，添加数据。
     2.刷新指定位置的数据
     */
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.models];
    [array addObject:model];
    self.models = array;
    [self.tabelView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    return YES;
}
-(BOOL)editManWithModel:(CellModel *) model andIndexPath:(NSIndexPath *) indexPath{
    /*
     1.把model添加到指定的位置上。
     1.判断model要添加到哪里。
     2.取出model，添加数据。
     2.刷新指定位置的数据
     */
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.models];
    [array replaceObjectAtIndex:indexPath.row withObject:model];
    self.models = array;
    [self.tabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    return YES;
}

#pragma mark - ============== 方法 ==============

-(void)deleteRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.models];
    [array removeObjectAtIndex:indexPath.row];
    self.models = array;
    
    [self.tabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}


#pragma mark - ============== 代理 ==============
//dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    TableViewCell * cell = [_tabelView dequeueReusableCellWithIdentifier:identifier];
    CellModel * model = self.models[indexPath.row];
    [cell.nameLabel setText:model.name];
    [cell.phoneLabel setText:model.phone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteRowAtIndexPath:indexPath];
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
#warning 1打开添加控制器，传送地址， 编辑文件，传送回来。
        
    }
    
}


//delegate

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.cellClickAction) {
        
        CellModel * model = self.models[indexPath.row];
        self.cellClickAction(indexPath,model);
    }

    
    
}


#pragma mark - ============== 设置 ==============

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.tabelView registerNib:[UINib nibWithNibName:@"tableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    
}

@end

