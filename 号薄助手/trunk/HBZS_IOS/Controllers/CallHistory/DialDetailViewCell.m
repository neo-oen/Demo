//
//  DialDetailViewCell.m
//  HBZS_IOS
//
//  Created by Kevin Zhang on 13-6-4.
//
//

#import "DialDetailViewCell.h"
#import "UtilMacro.h"
@implementation DialDetailViewCell



@synthesize dateLabel;

- (void)dealloc{
    if (_numberLabel) {
        [_numberLabel release];
        _numberLabel = nil;
    }
    
    if (dateLabel) {
        [dateLabel release];
        dateLabel  = nil;
    }
    
    if (_timeLabel) {
        [_timeLabel release];
        _timeLabel = nil;
    }
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawDateLabel];
        [self createTimeLabel];
        [self createDialTypeLabel];
    }
    
    return self;
}



- (void)drawDateLabel{
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 20)];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel release];
}

- (void)createTimeLabel
{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 100, 20)];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel release];
}

-(void)createDialTypeLabel
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
