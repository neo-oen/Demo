//
//  ProgressBar.m
//  HBZS_IOS
//
//  Created by yingxin on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProgressBar.h"
#import "Public.h"
@implementation ProgressBar

@synthesize progressView;
@synthesize progressLabel;
@synthesize fprogress;

-(void)dealloc{
  
    if (progressView) {
        [progressView release];
        
        progressView = nil;
    }
    
    if (progressLabel) {
        [progressLabel release];
        
        progressLabel = nil;
    }
    
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.clipsToBounds = YES;
      progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,frame.size.height)];
      [self addSubview:progressView];
        
      
//      progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x,frame.origin.y,LABEL_WIDTH,frame.size.height)];
//        
//      [progressLabel setBackgroundColor:[UIColor clearColor]];
//      [progressLabel setTextAlignment:1];
//      [progressLabel setTextColor:[UIColor blackColor]];
//      [progressLabel setFont:[UIFont systemFontOfSize:16]];
//      [self addSubview:progressLabel];
        
//      UIImageView* imageBackView = [[UIImageView alloc] initWithFrame:frame];
////      self.backgroundColor = [UIColor clearColor];
//      [Public setImageviewBackgroundImage:@"huise" imageview:imageBackView];
//      [self addSubview:imageBackView];
//      [imageBackView release];
//      
      fprogress = 0.0f;
    }
    
    return self;
}

- (void)setProgressMin {
  fprogress = 0.0f;
    
  [progressLabel setText:@""];
    
  [progressView setFrame:CGRectMake(progressView.frame.origin.x, 
                                    progressView.frame.origin.y,
                                    0,
                                    progressView.frame.size.height
                                    )];
}

- (void)setProgressMax {
  fprogress = 1.0f;
    
  [progressLabel setText:@"100%%"];
    
  [progressView setFrame:CGRectMake(progressView.frame.origin.x, 
                                    progressView.frame.origin.y,
                                    self.frame.size.width,
                                    progressView.frame.size.height
                                    )];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated animateTime:(CGFloat)ntime {
  
  if (self.progressView==nil/*||self.progressLabel==nil*/)
    return;
    
  fprogress = progress;
      
  if (animated) {
      [UIView animateWithDuration:ntime animations:^{
          progressView.frame =CGRectMake(
                                    progressView.frame.origin.x,
                                    progressView.frame.origin.y,
                                    self.frame.size.width*progress,
                                    progressView.frame.size.height
                                    );
      }];
  }
  else {
    progressView.frame =CGRectMake(progressView.frame.origin.x, 
                                   progressView.frame.origin.y,
                                   self.frame.size.width*progress,
                                   progressView.frame.size.height
                                   );
  }
}

-(void)setProgressType:(ProcType)type {
  switch (type) {
      case PROC_YELLOW:{
          [Public setImageviewBackgroundImage:@"huangse" imageview:progressView];
          break;
      }
      case PROC_GREEN:{
          [Public setImageviewBackgroundImage:@"lvse" imageview:progressView];

          break;
      }
      case PROC_BLUE:{
          [Public setImageviewBackgroundImage:@"lanse" imageview:progressView];

          break;
      }
    default:
      break;
  }
}
-(void)sd123
{
    UIProgressView * pro = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
}

@end
