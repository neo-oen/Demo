//
//  BannerCell.h
//  bannerView
//
//  Created by neo on 2018/1/8.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

typedef void (^ImageClickAction)(NSString * imageUrl);

@interface BannerCell : UICollectionViewCell

@property(nonatomic,strong)BannerModel * model;

@property(nonatomic,copy)ImageClickAction imageCA ;//向view类外，索要非本类的工作的接口
@property(nonatomic,strong)UIButton * imageView;
@property(nonatomic,strong)NSString * imageUrl;



@end

