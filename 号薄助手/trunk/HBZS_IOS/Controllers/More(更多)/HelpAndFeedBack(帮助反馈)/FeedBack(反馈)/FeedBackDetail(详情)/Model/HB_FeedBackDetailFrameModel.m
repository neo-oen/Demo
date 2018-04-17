//
//  HB_FeedBackDetailFrameModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#define Padding 15.0f;//间距

#import "HB_FeedBackDetailFrameModel.h"

@implementation HB_FeedBackDetailFrameModel
-(void)dealloc{
    [_model release];
    [super dealloc];
}
#pragma mark - setter and getter
/**
 *  传入数据模型，根据模型，算出frame
 */
-(void)setModel:(HB_FeedBackDetailModel *)model{
    if (_model != model) {
        [_model release];
        _model=[model retain];
    }
    //控件的frame
    //1.‘Q’
    CGFloat charQ_W=25;
    CGFloat charQ_H=15;
    CGFloat charQ_X=Padding;
    CGFloat charQ_Y=Padding;
    self.characterQFrame=CGRectMake(charQ_X, charQ_Y, charQ_W, charQ_H);
    //2.问题内容
    CGFloat question_X=CGRectGetMaxX(self.characterQFrame);
    CGFloat question_Y=charQ_Y;
    CGFloat question_W=SCREEN_WIDTH - question_X - Padding;
    NSMutableDictionary *questionAttributes=[NSMutableDictionary dictionary];
    questionAttributes[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    CGFloat question_H = [_model.question boundingRectWithSize:CGSizeMake(question_W, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:questionAttributes context:nil].size.height;
    self.questionFrame=CGRectMake(question_X, question_Y, question_W, question_H);
    //3.问题时间
    CGFloat questionTime_W=question_W;
    CGFloat questionTime_H=15;
    CGFloat questionTime_X=question_X;
    CGFloat questionTime_Y=CGRectGetMaxY(self.questionFrame)+5;
    self.questionTimeFrame=CGRectMake(questionTime_X, questionTime_Y, questionTime_W, questionTime_H);
    //4.‘A’
    CGFloat charA_W=charQ_W;
    CGFloat charA_H=charQ_H;
    CGFloat charA_X=charQ_X;
    CGFloat charA_Y=CGRectGetMaxY(self.questionTimeFrame)+Padding;
    self.characterAFrame=CGRectMake(charA_X, charA_Y, charA_W, charA_H);
    //5.回复内容
    CGFloat answer_X=question_X;
    CGFloat answer_Y=charA_Y;
    CGFloat answer_W=questionTime_W;
    NSMutableDictionary *answerAttribute=[NSMutableDictionary dictionary];
    answerAttribute[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    CGFloat answer_H=[_model.answer boundingRectWithSize:CGSizeMake(answer_W, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:answerAttribute context:nil].size.height;
    self.answerFrame=CGRectMake(answer_X, answer_Y, answer_W, answer_H);
    //6.回复时间
    CGFloat answerTime_W=answer_W;
    CGFloat answerTime_H=15;
    CGFloat answerTime_X=answer_X;
    CGFloat answerTime_Y=CGRectGetMaxY(self.answerFrame)+5;
    self.answerTimeFrame=CGRectMake(answerTime_X, answerTime_Y, answerTime_W, answerTime_H);
    //7.底部细线
    self.bottomLineFrame=CGRectMake(15, CGRectGetMaxY(self.answerTimeFrame) + 15, SCREEN_WIDTH-2*15, 0.5);
    //8.cell高度
    self.cellHight=CGRectGetMaxY(self.bottomLineFrame);
}


@end
