//
//  MenuItemButton.m
//  HBZS_IOS
//
//  Created by zimbean on 14-6-16.
//
//

#import "MenuItemButton.h"

@implementation MenuItemButton
@synthesize imgView;
@synthesize btnTitleLabel;

- (void)dealloc{
    if (imgView) {
        [imgView release];
    }
    
    if (btnTitleLabel) {
        [btnTitleLabel release];
    }
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(27.5, 5, 30, 30)];
        [self addSubview:imgView];
        imgView.userInteractionEnabled = NO;
        
        btnTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, 20)];
        btnTitleLabel.backgroundColor = [UIColor clearColor];
        btnTitleLabel.textAlignment = NSTextAlignmentCenter;
        btnTitleLabel.textColor = [UIColor grayColor];
        btnTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:btnTitleLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
