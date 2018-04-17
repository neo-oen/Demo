//
//  HB_CommonQuestion.m
//  HBZS_IOS
//
//  Created by zimbean on 15/12/8.
//
//

#import "HB_CommonQuestion.h"

@interface HB_CommonQuestion ()

@end

@implementation HB_CommonQuestion

-(void)dealloc{
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenTabBar];
    self.url =[NSURL URLWithString:questionUrl];
    self.title=@"常见问题";
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

@end
