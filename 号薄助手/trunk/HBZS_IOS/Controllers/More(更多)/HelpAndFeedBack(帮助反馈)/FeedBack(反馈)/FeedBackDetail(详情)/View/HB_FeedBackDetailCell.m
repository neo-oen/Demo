//
//  HB_FeedBackDetailCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#import "HB_FeedBackDetailCell.h"

@interface HB_FeedBackDetailCell ()
/** ‘Q’ */
@property(nonatomic,retain)UILabel *characterQ;
/** ‘A’ */
@property(nonatomic,retain)UILabel *characterA;
/** 问题内容 */
@property(nonatomic,retain)UILabel *question;
/** 回复内容 */
@property(nonatomic,retain)UILabel *answer;
/** 问题的时间 */
@property(nonatomic,retain)UILabel *questionTime;
/** 回复的时间 */
@property(nonatomic,retain)UILabel *answerTime;
/** 底部细线 */
@property(nonatomic,retain)UILabel *bottomLine;
/** 数据模型model */
@property(nonatomic,retain)HB_FeedBackDetailModel *model;

@end


@implementation HB_FeedBackDetailCell
#pragma mark - life cycle
-(void)dealloc{
    [_characterQ release];
    [_characterA release];
    [_question release];
    [_answer release];
    [_questionTime release];
    [_answerTime release];
    [_bottomLine release];
    [_model release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * identify=@"HB_FeedBackDetailCell";
    HB_FeedBackDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell=[[[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //添加自控件
        [cell.contentView addSubview:cell.characterQ];
        [cell.contentView addSubview:cell.characterA];
        [cell.contentView addSubview:cell.question];
        [cell.contentView addSubview:cell.questionTime];
        [cell.contentView addSubview:cell.answer];
        [cell.contentView addSubview:cell.answerTime];
        [cell.contentView addSubview:cell.bottomLine];
    }
    return cell;
}
#pragma mark - setter and getter
-(void)setFrameModel:(HB_FeedBackDetailFrameModel *)frameModel{
    if (_frameModel != frameModel) {
        [_frameModel release];
        _frameModel=[frameModel retain];
    }
    //1.设置每个控件的frame
    self.characterQ.frame = _frameModel.characterQFrame;
    self.characterA.frame = _frameModel.characterAFrame;
    self.question.frame = _frameModel.questionFrame;
    self.questionTime.frame = _frameModel.questionTimeFrame;
    self.answer.frame = _frameModel.answerFrame;
    self.answerTime.frame = _frameModel.answerTimeFrame;
    self.bottomLine.frame = _frameModel.bottomLineFrame;
    //2.设置数据模型
    self.model = frameModel.model;
}
-(void)setModel:(HB_FeedBackDetailModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    //给每个控件赋值
    self.characterQ.text=@"Q：";
    self.characterA.text=@"A：";
    self.question.text=model.question;
    self.questionTime.text=model.questionTime;
    self.answer.text=model.answer;
    self.answerTime.text=model.answerTime;
}
-(UILabel *)characterA{
    if (!_characterA) {
        _characterA=[[UILabel alloc]init];
        _characterA.textColor=COLOR_D;
        _characterA.font=[UIFont systemFontOfSize:14];
    }
    return _characterA;
}
-(UILabel *)characterQ{
    if (!_characterQ) {
        _characterQ=[[UILabel alloc]init];
        _characterQ.textColor=COLOR_D;
        _characterQ.font=[UIFont systemFontOfSize:14];
    }
    return _characterQ;
}
-(UILabel *)question{
    if (!_question) {
        _question=[[UILabel alloc]init];
        _question.textColor=COLOR_D;
        _question.numberOfLines=0;
        _question.font=[UIFont systemFontOfSize:14];
    }
    return _question;
}
-(UILabel *)questionTime{
    if (!_questionTime) {
        _questionTime=[[UILabel alloc]init];
        _questionTime.textColor=COLOR_F;
        _questionTime.font=[UIFont systemFontOfSize:14];
    }
    return _questionTime;
}
-(UILabel *)answer{
    if (!_answer) {
        _answer=[[UILabel alloc]init];
        _answer.textColor=COLOR_D;
        _answer.numberOfLines=0;
        _answer.font=[UIFont systemFontOfSize:14];
    }
    return _answer;
}
-(UILabel *)answerTime{
    if (!_answerTime) {
        _answerTime=[[UILabel alloc]init];
        _answerTime.textColor=COLOR_F;
        _answerTime.font=[UIFont systemFontOfSize:14];
    }
    return _answerTime;
}
-(UILabel *)bottomLine{
    if (!_bottomLine) {
        _bottomLine=[[UILabel alloc]init];
        _bottomLine.backgroundColor=COLOR_H;
    }
    return _bottomLine;
}

@end
