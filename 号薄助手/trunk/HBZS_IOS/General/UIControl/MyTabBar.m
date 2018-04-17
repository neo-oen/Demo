//
//  MyTabBar.m
//  HBZS_IOS
//
//  Created by yingxin on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTabBar.h"
#import "Public.h"
#import "SettingInfo.h"

static MyTabBar * manager;
@implementation MyTabBar

@synthesize currentType;

@synthesize delegate  = _delegate;

@synthesize dialKbdHide;

- (void)dealloc{
   [btnImagesNormal release];
    
   [btnImagesHighlight release];
    
   [super dealloc];
}
+(MyTabBar *)shareManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MyTabBar alloc] initWithShowFrame:CGRectMake(0,Device_Height- 49 , Device_Width, 49) hideFrame:CGRectMake(0, Device_Height, Device_Width, 49)];
            });
    return manager;
}
- (id)initWithShowFrame:(CGRect)sframe hideFrame:(CGRect)hframe{
    
    self = [super initWithFrame:sframe];
    if (self) {
        showFrame = sframe;
        hideFrame = hframe;
        
        //设置阴影
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowRadius = 1;
        self.layer.shadowOffset = CGSizeMake(0, -0.8);
        
        //初始化按钮状态标识
        firstBoot = YES;
        NSInteger firstPageNum = [SettingInfo getFirstPageNum];
        if (firstPageNum == 3) {
            currentType = (int)[SettingInfo getLastPageNum];
        }
        else if(firstPageNum>0)
        {
            currentType = firstPageNum+100-1;
        }
        else
        {
            currentType  = CONTACT_BTN_TYPE;
            [SettingInfo setFirstPageNum:2];
        }
        
        
        //初始化弹出拨号键
        dialKbdHide = YES;
        CGFloat tabbarItemWight = Device_Width/4;
        btnFrames[0] = CGRectMake(0, 0, tabbarItemWight, 49);
        btnFrames[1] = CGRectMake(tabbarItemWight, 0, tabbarItemWight, 49);
        btnFrames[2] = CGRectMake(2*tabbarItemWight, 0, tabbarItemWight, 49);
        btnFrames[3] = CGRectMake(3*tabbarItemWight, 0, tabbarItemWight, 49);
        
        btnImagesNormal = [[NSArray alloc] initWithObjects:@"tabBar_拨号",
                            @"tabBar_联系人",
                            @"tabBar_生活",
                            @"tabBar_我的", nil];
        
        btnImagesHighlight = [[NSArray alloc] initWithObjects:@"tabBar_收起拨号盘_selected",@"tabBar_联系人_selected",@"tabBar_生活_selected",
                            @"tabBar_我的_selected",nil];
        UIView * shadowlin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, 0.5)];
        shadowlin.backgroundColor = [UIColor lightGrayColor];
        shadowlin.alpha = 0.5;
        [self addSubview:shadowlin];
        
        self.backgroundColor = [UIColor whiteColor];
            }
    
    return self;
}

- (void)createTabViewandShowSelected{
    
    for (int i = 0; i < MAXBTNNUM; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.exclusiveTouch = YES;
        button.frame = btnFrames[i];

        [Public setButtonBackgroundImage:[btnImagesNormal objectAtIndex:i] highlighted:[btnImagesHighlight objectAtIndex:i] button:button];
        [button addTarget:self
                   action:@selector(setButtonSelected:)
         forControlEvents:UIControlEventTouchDown];
        
        button.tag = 100+i;
        
        [self addSubview:button];
        
        if (button.tag == currentType) {
            [self setButtonSelected:button];
        }
    }
}

- (void)setButtonSelected:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    
    if(firstBoot){
        firstBoot = NO;
        
        
        [Public setButtonBackgroundImage:[btnImagesHighlight objectAtIndex:button.tag-100]
                             highlighted:nil
                                  button:button];
        
        //向代理发送一个视图选择的消息 默认选项
        if (_delegate) {
            [_delegate didSelectIndex:button.tag-100];
        }
        
        return;
    }
    
    if (button.tag == currentType)
    {
        if (currentType == DIAL_BTN_TYPE) {
            [self setDialKbdHide:!dialKbdHide];
        }
    }
    else
    {
        UIButton *lastbutton = (UIButton*)[self viewWithTag:currentType];
        
        [Public setButtonBackgroundImage:[btnImagesNormal objectAtIndex:currentType-100]
                             highlighted:nil button:lastbutton];
        if (button.tag == DIAL_BTN_TYPE) {
            if (dialKbdHide) {
                [Public setButtonBackgroundImage:@"tabBar_展开拨号盘_selected"
                                     highlighted:nil button:button];
                [self setDialKbdHide:NO];
            }
            else{
                [Public setButtonBackgroundImage:@"tabBar_收起拨号盘_selected"
                                     highlighted:nil button:button];
                [self setDialKbdHide:YES];
            }
        }
        else {
            [Public setButtonBackgroundImage:[btnImagesHighlight objectAtIndex:button.tag-100] highlighted:nil button:button];
            dialKbdHide = YES;
        }
        
        currentType = button.tag;
        
        if (_delegate) {
            [_delegate didSelectIndex:currentType - 100];
        }
    }
}

- (void)setDialKbdHide:(BOOL)bhide{
    dialKbdHide = bhide;
    
    if (dialKbdHide) {
        UIButton *dialbutton = (UIButton*)[self viewWithTag:DIAL_BTN_TYPE];
        
        [Public setButtonBackgroundImage:@"tabBar_展开拨号盘_selected" highlighted:@"tabBar_展开拨号盘_selected" button:dialbutton];
    }
    else{
        UIButton *dialbutton = (UIButton*)[self viewWithTag:DIAL_BTN_TYPE];

        [Public setButtonBackgroundImage:@"tabBar_收起拨号盘_selected" highlighted:@"tabBar_收起拨号盘_selected" button:dialbutton];
    }
    
    if (_delegate) {
        [_delegate dialKbdHide:dialKbdHide];
    }
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated{
    
    if (animated)
    {
 
       [UIView animateWithDuration:0.5f animations:^{
            if (hidden) {
                self.frame = hideFrame;
                self.hidden = YES;
            }
            else{
                self.hidden = NO;
                self.frame = showFrame;
            }
        }];
    }
    else
    {
        self.hidden = hidden;
    }
}

@end
