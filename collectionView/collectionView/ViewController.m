//
//  ViewController.m
//  collectionView
//
//  Created by neo on 2018/1/5.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "ViewController.h"
#import "Public.h"
#import "shopCellModel.h"
#import "shopLayout.h"
#import "shopCell.h"


@interface ViewController ()<UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSArray * goods;

@end

static NSString * collectionCellID = @"collectionCell1";

@implementation ViewController



#pragma mark - ============== 懒加载 ==============
-(UICollectionView *)collectionView
{
    if(!_collectionView) {
        shopLayout * flowLayout = [[shopLayout alloc]init];
        flowLayout.itemHeight = ^CGFloat(NSIndexPath *path, CGFloat widht) {
            shopCellModel * model = self.goods[path.item];
            return widht * model.h / model.w;
        };
        [flowLayout setSectionInset:UIEdgeInsetsMake(5, 10, 20, 30)];
        [flowLayout setMinimumLineSpacing:10];
        [flowLayout setMinimumInteritemSpacing:20];
        [flowLayout setColumn:4];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) collectionViewLayout:flowLayout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[shopCell class] forCellWithReuseIdentifier:collectionCellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSArray *)goods
{
    if(!_goods) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"shop.plist" ofType:nil];
        
        _goods = [shopCellModel goodsWithPath:path];
        //
    }
    return _goods;
}

#pragma mark - ============== 开始 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goods.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    shopCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath ];
    cell.good = _goods[indexPath.item];
    [cell setBackgroundColor:[UIColor redColor]];
    return cell;
    
}



#pragma mark - ============== 设置 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
