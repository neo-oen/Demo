//
//  UIViewController+TitleView.m
//  HBZS_IOS
//
//  Created by zimbean on 13-10-27.
//
//

#import "UIViewController+TitleView.h"

@implementation UIViewController (TitleView)

- (void)setVCTitle:(NSString *)title{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = 1;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
}

- (NSString *)vcTitle{
   UILabel *titleLabel = (UILabel *)(self.navigationItem.titleView);
    
   return titleLabel.text;
}

@end
