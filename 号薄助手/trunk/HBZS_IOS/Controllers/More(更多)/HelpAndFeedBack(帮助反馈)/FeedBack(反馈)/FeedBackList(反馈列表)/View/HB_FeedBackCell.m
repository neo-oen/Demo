//
//  HB_FeedBackCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/5.
//
//

#import "HB_FeedBackCell.h"

@interface HB_FeedBackCell ()
/**
 *  问题内容
 */
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  提问时间
 */
@property (retain, nonatomic) IBOutlet UILabel *time;
/**
 *  反馈状态
 */
@property (retain, nonatomic) IBOutlet UILabel *status;
/**
 *  底部细线
 */
@property(nonatomic,retain)UILabel *line;


@end

@implementation HB_FeedBackCell
- (void)dealloc {
    [_contentLabel release];
    [_time release];
    [_status release];
    [_line release];
    [_model release];
    [super dealloc];
}
-(void)awakeFromNib{
    [self addSubview:self.line];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString * identifier=@"HB_FeedBackCell";
    HB_FeedBackCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"HB_FeedBackCell" owner:self options:nil]lastObject];
    }
    return cell;
}
-(void)setModel:(HB_FeedBackInfoModel *)model{
    if (_model != model) {
        [_model release];
        _model=[model retain];
    }
    //控件赋值
    _contentLabel.text=_model.feedBackContent;
    _time.text=_model.time;
    _status.text=_model.replayStatus;
}
-(UILabel *)line{
    if (!_line) {
        _line=[[UILabel alloc]init];
        _line.frame=CGRectMake(15, self.bounds.size.height-0.5, self.bounds.size.width-30, 0.5);
        _line.backgroundColor=COLOR_H;
    }
    return _line;
}


@end
