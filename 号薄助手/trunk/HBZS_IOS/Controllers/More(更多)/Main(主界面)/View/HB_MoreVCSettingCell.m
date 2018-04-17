//
//  HB_MoreVCSettingCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/11.
//
//
#define Padding 15 //间距
#import "HB_MoreVCSettingCell.h"
#import "HB_MoreVCCollectionCell.h"
@interface HB_MoreVCSettingCell ()
/**
 *  图标
 */
@property(nonatomic,retain)UIImageView * iconImageView;
/**
 *  选项名字
 */
@property(nonatomic,retain)UILabel *nameLabel;
/**
 *  箭头
 */
@property(nonatomic,retain)UIImageView * arrowImageView;
/**
 *  底部细线
 */
@property(nonatomic,retain)UILabel *lineLabel;

@end
@implementation HB_MoreVCSettingCell
-(void)dealloc{
//    [_iconImageView release];
//    [_nameLabel release];
//    [_arrowImageView release];
//    [_model release];
//    [_lineLabel release];
    
    [super dealloc];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_MoreVCSettingCell";
    HB_MoreVCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[HB_MoreVCSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
        [cell setupSubViews];
    }
    return cell;
    
}
/**
 *  添加子控件
 */
-(void)setupSubViews{
    
    
    return;
    //icon
    UIImageView * iv=[[UIImageView alloc]init];
    iv.image=[UIImage imageNamed:@"详情"];//这个是示例图片
    iv.contentMode=UIViewContentModeCenter;
    [self addSubview:iv];
    self.iconImageView=iv;
    [iv release];
    //名字
    UILabel * label=[[UILabel alloc]init];
    label.textColor=COLOR_D;
    label.font=[UIFont systemFontOfSize:15];
    [self addSubview:label];
    self.nameLabel=label;
    [label release];
    //箭头
    UIImageView * arrowIV=[[UIImageView alloc]init];
    arrowIV.image=[UIImage imageNamed:@"普通箭头-List"];
    arrowIV.contentMode=UIViewContentModeCenter;
    [self addSubview:arrowIV];
    self.arrowImageView=arrowIV;
    [arrowIV release];
    //细线
    UILabel * line=[[UILabel alloc]init];
    line.backgroundColor=COLOR_H;
    [self addSubview:line];
    self.lineLabel=line;
    [line release];
}
/**
 *  setter方法
 *
 */
-(void)setModel:(HB_MoreCellModel *)model{
    _model=model;
    //图标
    if (model.icon) {
        self.iconImageView.image=model.icon;
    }
    //name
    self.nameLabel.text=model.nameStr;
}
-(void)layoutSubviews{
    [self stepCollection];
    return;
    [super layoutSubviews];
    //图标
    CGFloat icon_W=20;
    CGFloat icon_H=self.contentView.bounds.size.height;
    CGFloat icon_X=Padding;
    CGFloat icon_Y=0;
    self.iconImageView.frame=CGRectMake(icon_X, icon_Y, icon_W, icon_H);
    //箭头
    CGFloat arrow_W=20;
    CGFloat arrow_H=icon_H;
    CGFloat arrow_X=SCREEN_WIDTH-Padding-arrow_W;
    CGFloat arrow_Y=0;
    self.arrowImageView.frame=CGRectMake(arrow_X, arrow_Y, arrow_W, arrow_H);
    //name
    CGFloat nameLabel_X=CGRectGetMaxX(_iconImageView.frame)+Padding;
    CGFloat nameLabel_Y=0;
    CGFloat nameLabel_W=arrow_X-Padding-nameLabel_X;
    CGFloat nameLabel_H=self.contentView.bounds.size.height;
    self.nameLabel.frame=CGRectMake(nameLabel_X, nameLabel_Y, nameLabel_W, nameLabel_H);
    //细线
    CGFloat line_W=SCREEN_WIDTH;
    CGFloat line_H=0.5;
    CGFloat line_X=0;
    CGFloat line_Y=self.contentView.bounds.size.height-line_H;
    self.lineLabel.frame=CGRectMake(line_X, line_Y, line_W, line_H);

}



#pragma mark 4.3.0版 与更多界面调整
-(void)stepCollection
{
    UICollectionViewFlowLayout * laout = [[UICollectionViewFlowLayout alloc] init];
    //同一行间相邻的2个cell的最小距离
    laout.minimumLineSpacing = 1;
    laout.minimumInteritemSpacing = 1;
    
    UICollectionView * collect = [[UICollectionView alloc] initWithFrame:self.contentView.frame collectionViewLayout:laout];
    collect.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
    collect.delegate = self;
    collect.dataSource = self;
    
    [self.contentView addSubview:collect];
    UINib *cellNib=[UINib nibWithNibName:@"HB_MoreVCCollectionCell" bundle:nil];
    [collect registerNib:cellNib forCellWithReuseIdentifier:@"MoreVCCollectionCell"];
//    [laout release];
//    [collect release];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellModelArr.count;
}


//定义每一个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Device_Width/2-0.5, 72);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(Device_Width, 16);
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HB_MoreVCCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MoreVCCollectionCell" forIndexPath:indexPath];
    HB_MoreCellModel * model = [self.cellModelArr objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(MoreVCSettingCell:selectedAtIdexPath:)]) {
        [self.delegate MoreVCSettingCell:self selectedAtIdexPath:indexPath];
    }
}
@end
