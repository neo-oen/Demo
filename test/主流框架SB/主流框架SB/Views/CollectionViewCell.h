//
//  CollectionViewCell.h
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/28.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjuctModel.h"

typedef BOOL (^ImageAction)(NSString * key);


@interface CollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)ProjuctModel * product;
@property(nonatomic,copy)ImageAction imageCA ;
@property (strong, nonatomic)  UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeView;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
