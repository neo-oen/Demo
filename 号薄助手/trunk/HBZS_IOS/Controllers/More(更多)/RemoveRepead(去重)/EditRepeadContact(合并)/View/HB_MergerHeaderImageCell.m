//
//  HB_MergerHeaderImageCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/9/11.
//
//

#import "HB_MergerHeaderImageCell.h"
#import "HB_MergerHeaderCollectionItemCell.h"

@interface HB_MergerHeaderImageCell ()<UICollectionViewDataSource,
                                       UICollectionViewDelegate>

/**
 *  collectionView九宫格视图
 */
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation HB_MergerHeaderImageCell
- (void)dealloc {
    [_iconArr release];
    [_collectionView release];
    [super dealloc];
}

- (void)awakeFromNib {
    //设置代理
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    //注册
    static NSString * identify=@"HB_MergerHeaderCollectionItemCell";
    UINib * nib=[UINib nibWithNibName:@"HB_MergerHeaderCollectionItemCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identify];
    
}
-(void)drawRect:(CGRect)rect{
    //默认选中第0个头像
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    HB_MergerHeaderCollectionItemCell * cell=(HB_MergerHeaderCollectionItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.bgImageView.hidden=NO;
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}
#pragma mark - 设置cell的frame
-(void)setFrame:(CGRect)frame{
    //1.算出当前设备，一行可以放几个item
    NSInteger count = (SCREEN_WIDTH - 15*2 + 8)/(46+8);
    //2.算出当前的头像数组，需要放几行
    NSInteger rowCount= _iconArr.count%count?_iconArr.count/count+1 : _iconArr.count/count;
    //3.算出高度
    CGFloat height = rowCount * (46+8) ;
    
    frame.size.height=height;
    [super setFrame:frame];
}
#pragma mark - UICollectionViewCell代理方法
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify=@"HB_MergerHeaderCollectionItemCell";
    HB_MergerHeaderCollectionItemCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.headerImageView.image=[UIImage imageWithData:_iconArr[indexPath.row]];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _iconArr.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HB_MergerHeaderCollectionItemCell * cell=(HB_MergerHeaderCollectionItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgImageView.hidden=NO;
    //更新当前选中的头像
    NSIndexPath * currentIndexPath=collectionView.indexPathsForSelectedItems[0];
    //告诉代理，选中的头像
    if ([self.delegate respondsToSelector:@selector(mergerHeaderImageCell:didSelectHeaderImageViewWithIndex:)]) {
        [self.delegate mergerHeaderImageCell:self didSelectHeaderImageViewWithIndex:currentIndexPath.row];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    HB_MergerHeaderCollectionItemCell * cell=(HB_MergerHeaderCollectionItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgImageView.hidden=YES;
}

@end
