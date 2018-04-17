//
//  DialListCell.m
//  HBZS_IOS
//
//  Created by Kevin Zhang、yingxin on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialListCell.h"
#import "Public.h"
#import "Util.h"
@implementation DialListCell

@synthesize midLabel;

@synthesize dialInfoBtn;

@synthesize rightLabel;

@synthesize locationLabel;

@synthesize  dateLabel;

- (void)dealloc{
    if (midLabel) {
        [midLabel release];
        midLabel = nil;
    }
    
    if (dialInfoBtn) {
        [dialInfoBtn release];
        dialInfoBtn = nil;
    }
    
    if (rightLabel) {
        [rightLabel release];
        rightLabel = nil;
    }
    
    if (locationLabel) {
        [locationLabel release];
        locationLabel = nil;
    }
    
    if (dateLabel) {
        [dateLabel release];
        dateLabel = nil;
    }
    
    [super dealloc];
}

- (void)allocMidLabel{
    midLabel = [[UILabel alloc] initWithFrame:CGRectMake(125*RATE, 20, 40*RATE, 12)];
    [midLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:midLabel];
}

- (void)allocRightLabel{
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.5,18, 25, 25)];
    [rightLabel setBackgroundColor:[UIColor clearColor]] ;
    [rightLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [rightLabel setTextColor:[UIColor whiteColor]];
    [rightLabel setTextAlignment:1];
}

#pragma mark Date UILabel
- (void)allocDateLabel{
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width-65-100-10,18,100, 15)];
    [dateLabel setBackgroundColor:[UIColor clearColor]] ;
    [dateLabel setFont:[UIFont systemFontOfSize:10]];
    [dateLabel setTextColor:[UIColor grayColor]];
    [dateLabel setTextAlignment:2];
    [self.contentView addSubview:dateLabel];
}

#pragma mark 归属地 UILabel
- (void)allocLocationLabel{         //归属地
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(Device_Width-150-65-10,33, 150, 15)];
    [locationLabel setBackgroundColor:[UIColor clearColor]] ;
    [locationLabel setFont:[UIFont systemFontOfSize:10]];
    [locationLabel setTextColor:[UIColor grayColor]];
    [locationLabel setTextAlignment:2];
    [self.contentView addSubview:locationLabel];
}

- (void)allocDialInfoBtn{
    dialInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(Device_Width-70, 0,65, 60)];
    dialInfoBtn.exclusiveTouch = YES;
    [dialInfoBtn addSubview:rightLabel];
    [self addSubview:dialInfoBtn];
}

#pragma mark  initWithStyle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){        
        [self allocMidLabel];
        
        [self allocRightLabel];
        
        [self allocDialInfoBtn];
        
        [self allocDateLabel];
        
        [self allocLocationLabel];
    }
    
    return self;
}

#pragma mark set UILabel   text
- (void)setLabelMid:(NSString*) textContent{
    [midLabel setText:textContent];
}

- (void)setDialInfoBtnTag:(NSUInteger) btnTag{
    [dialInfoBtn setTag:btnTag];
}

- (void)setDialInfoBtnImg:(NSString*)imageName{
   [dialInfoBtn setBackgroundImage:[Util allocImage:imageName] forState:UIControlStateNormal];    
}

- (void)setLabelRight:(NSString*)textContent{
    if (textContent){
        if (textContent.length > 2){
            [rightLabel setText:@"99+"];
        }
        else{
            [rightLabel setText:textContent];
        }
    }
}

- (void)setLabelDate:(NSString*)textContent{
    [dateLabel setText:textContent];
}

- (void)setLabelLocation:(NSString*)textContent{
    [locationLabel setText:textContent];
}

- (void)setDialInfoBtnHidden:(BOOL) bHidden{    
    [dialInfoBtn setHidden:bHidden];
}

@end
