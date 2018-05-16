//
//  ShareContactTableView.m
//  testAPP
//
//  Created by neo on 2018/5/16.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "ShareContactTableView.h"
#import "ShareContactCell.h"
#import "xxmodel.h"

@interface ShareContactTableView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)FirstButtonClickAction firstButtonCA;
@property(nonatomic,copy)SecondButtonClickAction secondButtonCA;
@property(nonatomic,copy)SendOtherButtonClickAction sendOtherButtonCA;
@property(nonatomic,copy)AccessorViewClickAction accessorViewButtonCA;

@end



@implementation ShareContactTableView

static NSString *identifier = @"TableViewCell";

#pragma mark - ============== 懒加载 ==============


-(void )tableView
{
        [self registerClass:ShareContactCell.class forCellReuseIdentifier:identifier];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
}

//-(NSMutableArray *)models
//{
//
//    if(!_models) {
//        _models = [[NSMutableArray alloc]init];
//        for (int i=0; i<10; i++) {
//            ContactShareInfo * model = [[ContactShareInfo alloc]init];
//            model.shareurl = [NSString stringWithFormat:@"XXXXXXX-%d-XXXXXXXXX",i];
//            model.extractcode = [NSString stringWithFormat:@"======x%dx=======",i+7];
//
//            [_models addObject:model];
//        }
//
//    }
//    return _models;
//}


#pragma mark - ============== 初始化 ==============

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self tableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self tableView];
    }
    return self;
}

#pragma mark - ============== 接口 ==============
-(void)setModels:(NSArray *)models{
    _models = models;
    [self reloadData];
}

-(void)setCellActionWithFirstBCA:(FirstButtonClickAction)first withSecondBCA:(FirstButtonClickAction)second withSendOtherBCA:(FirstButtonClickAction)send withAccessorViewBCA:(AccessorViewClickAction)accessor{
    self.firstButtonCA = first;
    self.secondButtonCA = second;
    self.sendOtherButtonCA = send;
    self.accessorViewButtonCA = accessor;
    
}

#pragma mark - ============== 方法 ==============
-(void)updateSlectRowWithIndexPath:(NSIndexPath * )indexPath{
    ContactShareInfo * model = self.models[indexPath.row];
    model.selected = model.isSelected?NO:YES;
    NSIndexPath * indexPath2=nil ;
    for (int i =0; i<self.models.count; i++) {
        ContactShareInfo * model = self.models[i];
        if (model.selected && !(i == indexPath.row)) {
            model.selected = model.isSelected?NO:YES;
            indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    
    NSArray * array;
    if (indexPath2) {
        array = @[indexPath,indexPath2];
    }else{
        array= @[indexPath];
    }
    
    [self reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - ============== UI界面 ==============
#pragma mark - ============== 代理 ==============
//dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // static 避免多次分配内存
    
    
    // 1. 到缓存池中去找cell
    ShareContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    ContactShareInfo * model = self.models[indexPath.row];
    [cell updateTableViewCellWithModel:model];
    
    [cell setActionWithFirstBCA:_firstButtonCA withSecondBCA:_secondButtonCA withSendOtherBCA:_secondButtonCA withAccessorViewBCA:_accessorViewButtonCA];
    
    
    if (indexPath.row) {
        [cell.lineView setBackgroundColor:[UIColor grayColor]];
    }else{
        [cell.lineView setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
}

//delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactShareInfo * model = self.models[indexPath.row];
    return model.isSelected?130:82;
    //    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"section=%ld,row=%ld",indexPath.section,indexPath.row);
    [self updateSlectRowWithIndexPath:indexPath];
    
}

#pragma mark - ============== 设置 ==============



@end
