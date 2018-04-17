//
//  HB_CardQRImageCollectionCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/7/6.
//
//

#import <UIKit/UIKit.h>
#import "HB_ContactModel.h"

@class HB_CardQRImageCollectionCell;
@protocol CardQRImageCollectionCelldelegate <NSObject>

-(void)celllongPressClick;

@end

@interface HB_CardQRImageCollectionCell : UICollectionViewCell

@property(nonatomic,strong)HB_ContactModel * contactmodel;

@property(nonatomic,assign)id<CardQRImageCollectionCelldelegate>delegate;

@property(nonatomic,strong)UIImageView * QRImageView;

@property(nonatomic,strong)UILabel * nameLabel;

@property(nonatomic,strong)UILabel * PhoneLabel;

@property(nonatomic,strong)UIView * CardBgview;

@property(nonatomic,strong)UIImage * cardImage;

@property(nonatomic,strong)UIImage * UrlImage;

@property(nonatomic,strong)NSMutableString * showPhoneNum;


/*显示的二维码类型，0-名片 1-名片活码*/
@property(nonatomic,assign)NSInteger QRimageType;

@property(nonatomic,strong)NSString * UrlString;


@end
