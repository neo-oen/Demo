//
//  LaunchViewController.h
//  HBZS_IOS
//
//  Created by zimbean on 14-6-17.
//
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController{
    UIImageView *launchImgView;
}

@property (nonatomic, retain)NSData *lanuchImgData;
@property(nonatomic,assign)int playCountdouw;
@property (nonatomic,strong)NSTimer * playtimer;


@property(nonatomic,copy)void(^skipBlock)();

+ (BOOL)isInEndDate;

- (id)initWithLauchImgData:(NSData *)data;

@end
