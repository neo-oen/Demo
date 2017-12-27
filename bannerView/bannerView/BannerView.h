//
//  BannerView.h
//  bannerView
//
//  Created by neo on 2017/10/10.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIBannerViewStyle) {
    UIBannerViewStyleDefault,
    UIBannerViewStyle1
};


typedef void (^BannerClickAction)(NSString * ImageUrl);

@interface BannerView : UIView

@property(nonatomic,copy)BannerClickAction BannerCA ;//向view类外，索要非本类的工作的接口
@property(nonatomic,strong)NSArray * models;//向本类输入资源的接口
@property(assign)NSInteger timeInt;

+ (BannerView *)bannerWithFrame:(CGRect)frame updateWithModels:(NSArray *)models andTime:(NSInteger)time;

+ (BannerView *)bannerAutoLayoutWithModels:(NSArray *)models andTime:(NSInteger)time;
- (void)updateBannerViewWith:(NSArray *)models;//加载资源

-(BOOL)addBanner:(NSString *) title;//视图的输入接口，通过她来调用视图的某些功能


@end
