//
//  BannerView.h
//  bannerView
//
//  Created by neo on 2017/10/10.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIBannerViewStyle) {
    UIBannerViewStyleScrollView,
    UIBannerViewStyleCollection
};

typedef NS_ENUM(NSUInteger, ChangeType) {
    NextChange = 0,
    PreviousChange = 1,
};

typedef void (^BannerClickAction)(NSString * imageUrl);

@interface BannerView : UIView

@property(nonatomic,copy)BannerClickAction bannerCA ;//向view类外，索要非本类的工作的接口
@property(nonatomic,strong)NSArray * models;//向本类输入资源的接口
@property(nonatomic,assign)UIBannerViewStyle style;
@property(assign)NSInteger timeInt;

+ (BannerView *)bannerWithFrame:(CGRect)frame updateWithModels:(NSArray *)models andTime:(NSInteger)time andBannerViewStyle:(UIBannerViewStyle) style;

+ (BannerView *)bannerAutoLayoutWithModels:(NSArray *)models andTime:(NSInteger)time andBannerViewStyle:(UIBannerViewStyle)style;

- (void)updateBannerViewWith:(NSArray *)models;//加载资源

-(BOOL)addBanner:(NSString *) title;//视图的输入接口，通过她来调用视图的某些功能
//scrollView使用
-(void)changeNextPicture;
//collectionView使用
-(BOOL)changePictureWithChangeType:(ChangeType)type;

@end
