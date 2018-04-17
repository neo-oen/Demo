//
//  ContactListCell.m
//  CTPIM
//
//  Created by Kevin Zhang、 scanmac on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ContactListCell.h"
#import "ContactData.h"
#import <QuartzCore/QuartzCore.h>
#import "GobalSettings.h"
#import "Public.h"
#import "UtilMacro.h"

@implementation ContactListCell

@synthesize headImageView;

@synthesize topLabel;

@synthesize bottomLabel;

@synthesize groupSelectBtn;

- (void)dealloc{
    
//    if (topLabel) {
//        [topLabel release];
//        
//        topLabel = nil;
//    }
//    
//    if (bottomLabel) {
//        [bottomLabel release];
//        
//        bottomLabel = nil;
//    }
//    
//    if (headImageView) {
//        [headImageView release];
//        
//        headImageView = nil;
//    }
//    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        topLabel = [[AttributedLabel alloc] initWithFrame:CGRectZero];
        
        bottomLabel = [[AttributedLabel alloc] initWithFrame:CGRectZero];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11.25, 37.5, 37.5)] ;
        
        [topLabel setBackgroundColor:[UIColor clearColor]];
 
        [bottomLabel setBackgroundColor:[UIColor clearColor]];
        
        [headImageView setBackgroundColor:[UIColor clearColor]];
        
        [bottomLabel setTextColor:COLOR(150, 150, 150, 1.0)];
        
        groupSelectBtn = [[CellButton alloc] initWithFrame:CGRectMake(245,7,65, 46)];
        
        [self.contentView addSubview:topLabel];
        
        [topLabel release];
        
        [self.contentView addSubview:bottomLabel];
        
        [bottomLabel release];
        
        [self.contentView addSubview:headImageView];
        
        [headImageView release];
        
        [self.contentView addSubview:groupSelectBtn];
    }
    
    return self;
}

- (void)setImageViewCornerRadius:(UIImageView*)imageView borderWidth:(CGFloat)nFloat {
    
    if(imageView != nil ) {
        imageView.layer.masksToBounds = YES;
        
        imageView.layer.borderWidth = 1.0;
        
        imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
}

- (void)setHeadImage:(NSInteger) contaceID{
    if (contaceID == -1){
        [self setImageViewCornerRadius:headImageView borderWidth:0.0];
        
        [Public setImageviewBackgroundImage:@"default_head_s" imageview:headImageView];
    }
    else{
        CFDataRef dataRef = [ContactData getPersonImageByID:contaceID];
        
        UIImage *image = nil;
        
        if (dataRef != nil){
            image = [UIImage imageWithData:(NSData*)dataRef];
            
            [self setImageViewCornerRadius:headImageView borderWidth:0.0];
            
            [headImageView setImage:image];
        }
        else{
            [self setImageViewCornerRadius:headImageView borderWidth:0.0];
        
            [Public setImageviewBackgroundImage:@"default_head_s" imageview:headImageView];
        }
    }
}

//copy to here
- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (void)setLabelTop:(NSString*)textContent lableFrame:(CGRect)lableFrame highLightRange:(NSMutableArray*)rangeArray{
   
    [topLabel setText:textContent];

    [topLabel setBackgroundColor:[UIColor clearColor]];
    [topLabel setFrame:lableFrame];
    
    [topLabel setColor:[UIColor blackColor] fromIndex:0 length:textContent.length];
    
    [topLabel setFont:[UIFont systemFontOfSize:16] fromIndex:0 length:textContent.length];
    
    for (int i = 0; i < [rangeArray count]; i++) {
        int len = [[[[rangeArray objectAtIndex:i] allKeys] objectAtIndex:0] intValue];
        
        int loc = [[[[rangeArray objectAtIndex:i] allValues] objectAtIndex:0] intValue];
        // 设置is为黄色
       // [topLabel setColor:[UIColor colorWithRed:0.0 green:120.0/255.0 blue:205.0/255.0 alpha:1.0]fromIndex:loc length:len];
        [topLabel setColor:UIColorWithRGB(0, 120, 205) fromIndex:loc length:len];
    }
}

- (void)setLabelBottom:(NSString*) textContent lableFrame:(CGRect)lableFrame highLightRange:(NSMutableArray*)rangeArray{
    if (bottomLabel.text) {
        bottomLabel.text = nil;
    }
    
    [bottomLabel setText:textContent];
    
    [bottomLabel setFrame:lableFrame];
    
    [bottomLabel setColor:[UIColor grayColor] fromIndex:0 length:textContent.length];
    // 设置this字体为加粗16号字
    [bottomLabel setFont:[UIFont systemFontOfSize:12] fromIndex:0 length:textContent.length];
    
    // 给this加上下划线
    //  [label setStyle:kCTUnderlineStyleDouble fromIndex:0 length:4];
    for (int i = 0; i < [rangeArray count]; i++) {
        int len = [[[[rangeArray objectAtIndex:i] allKeys] objectAtIndex:0] intValue];
        
        int loc = [[[[rangeArray objectAtIndex:i] allValues] objectAtIndex:0] intValue];
        // 设置is为黄色
      //  [bottomLabel setColor:[UIColor colorWithRed:0.0 green:120.0/255.0 blue:205.0/255.0 alpha:1.0]fromIndex:loc length:len];
         [bottomLabel setColor:UIColorWithRGB(0, 120, 205) fromIndex:loc length:len];
    }
    
    bottomLabel.backgroundColor = [UIColor clearColor];
}

- (void)setGroupSelBtnTag:(NSUInteger) btnTag{
    [groupSelectBtn setTag:btnTag];
}

//selected是否代表在组里
- (void)setGroupSelBtnSelected:(BOOL)bSelected{
    groupSelectBtn.selected = bSelected ;
    
    if(bSelected){
        [Public setButtonBackgroundImage:@"ct_remove" highlighted:@"ct_remove_over" button:groupSelectBtn];
    }
    else{

        [Public setButtonBackgroundImage:@"ct_addto" highlighted:@"ct_addto_over" button:groupSelectBtn];
    }
}

//设置隐藏显示
- (void)setGroupSelBtnHidden:(BOOL)bHidden{
    
    [groupSelectBtn setHidden:bHidden];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    HBZSAppDelegate *appDelegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.mainViewController touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    HBZSAppDelegate *appDelegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.mainViewController touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    HBZSAppDelegate *appDelegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.mainViewController touchesMoved:touches withEvent:event];
}

@end
