//
//  GuidePageViewController.h
//  HBZS_IOS
//
//  Created by zimbean on 14-7-18.
//
//

#define userNoticeUrl @"http://pim.189.cn/About/Agreement.html"

#import <UIKit/UIKit.h>
#import "HB_PrivacyNoticeVC.h"
@interface GuidePageViewController : UIViewController<UIGestureRecognizerDelegate>{
    NSArray *guideImgNames;
}

@property (nonatomic, retain)IBOutlet UIScrollView *guideScrollView;

@end
