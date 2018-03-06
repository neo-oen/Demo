//
//  CollectionViewController4.m
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/28.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "CollectionViewController4.h"
#import "CollectionViewCell.h"
#import "CollectionViewLayout.h"
#import "ProjuctModel.h"
#import "SwipLockViewController.h"

@interface CollectionViewController4 ()

@property(nonatomic,strong)NSArray * projects;

@end

@implementation CollectionViewController4

static NSString * const reuseIdentifier = @"CellIdentifier";

#pragma mark - ============== 懒加载 ==============
-(NSArray *)projects
{
    if(!_projects) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"product.plist" ofType:nil];
        
        _projects = [ProjuctModel  projuctsWithPath:path];
    }
    return _projects;
}

#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============




#pragma mark - ============== 代理 ==============

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return self.projects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ProjuctModel *model = self.projects[indexPath.row];
    
    cell.product = model;
    cell.imageCA = ^BOOL(NSString *key) {
        
        id viewController = [[NSClassFromString(key) alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
        return YES;
    };
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
 }
 */

#pragma mark - ============== 设置 ==============


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CollectionViewLayout * flowLayout = [[CollectionViewLayout alloc]init];

    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 10, 20, 30)];
    [flowLayout setMinimumLineSpacing:10];
    [flowLayout setMinimumInteritemSpacing:5];
    [flowLayout setItemSize:CGSizeMake(80, 80)];
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) collectionViewLayout:flowLayout];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    // Register cell classes
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    
//    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
