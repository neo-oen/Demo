//
//  HB_MemberCenterHeadview.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/7.
//
//

#import "HB_MemberCenterHeadview.h"
#import "HB_MyCardNameAndPicModel.h"
@implementation HB_MemberCenterHeadview


- (IBAction)memberClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(memberHeaderView:clickWithIndex:)]) {
        [self.delegate memberHeaderView:self clickWithIndex:0];
        
    }
    
}
- (IBAction)VIPbtnClikc:(id)sender {
    if ([self.delegate respondsToSelector:@selector(memberHeaderView:clickWithIndex:)]) {
        [self.delegate memberHeaderView:self clickWithIndex:1];
        
    }
}

-(void)setMemberViewDataWithMemberInfo:(MemberInfoResponse *)memberInfo
{

    NSString * endTime = @"永久";
    NSString * level = @"普通会员";
    NSString * btntitle = @"免费体验";
    NSString * bottontext = @"VIP会员免费体验，马上开启";
    
    if (memberInfo.memberLevel == MemberLevelCommon) {
        endTime = @"永久";
        level = @"普通会员";
        if (memberInfo.isExperience) {
            btntitle = @"立即订购";
            bottontext = @"VIP会员优惠内测中,马上加入";
        }
        else
        {
            btntitle = @"免费体验";
            bottontext = @"VIP会员免费体验中,马上加入";
        }
        self.bottomView.hidden = NO;
    }
    else if (memberInfo.memberLevel == MemberLevelVip)
    {
        level = @"VIP会员";
        if (memberInfo.memberType == MemberTypeBuy) {
            endTime = @"会员包月中";
            self.bottomView.hidden = YES;
        }
        else if (memberInfo.memberType == MemberTypeFree ||memberInfo.memberType == MemberTypeTuiding)
        {
            NSInteger vipday = [self daysTotime:memberInfo.endTime];
            endTime = [self timeformat:memberInfo.endTime];
            if (vipday <=7) {
                bottontext = [NSString stringWithFormat:@"您的VIP服务还有%ld天到期",(long)vipday];
                btntitle = @"立即订购";
                self.bottomView.hidden = NO;
            }
            else
            {
                self.bottomView.hidden = YES;
            }
        }
    }
    
    [self.memberChangeRecode setTitle:level forState:UIControlStateNormal];
    
    self.bottonLabel.text = bottontext;
    
    [self.membtn setTitle:btntitle forState:UIControlStateNormal];
    
    self.endTimeLabel.text = endTime;
    
    
    HB_MyCardNameAndPicModel * model = [[HB_MyCardNameAndPicModel alloc] init];
    self.nameLabel.text = [NSString stringWithFormat:@"Hi %@",model.name];
    self.headerImageView.image = model.headerImage;
    
    
    
    
    
}
-(NSInteger)daysTotime:(NSString *)time
{
    NSDate * nowdate = [NSDate date];
    
    NSTimeInterval nowTimeInterval = [nowdate timeIntervalSince1970];
    
    NSInteger timeDifference = time.integerValue -nowTimeInterval;
    
    NSInteger days = timeDifference/(3600*24);
    
    return days;
}

-(NSString *)timeformat:(NSString *)timedata
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timedata.longLongValue];
    
    NSString * dateString  = [formatter stringFromDate:date];
    
    
    return dateString;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.headerImageView.layer.borderWidth = 2;
    self.headerImageView.layer.borderColor = [UIColor colorFromHexString:@"FBC08C"].CGColor;
    
    //底部label宽度自适应
    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
    CGSize expectSize = [_bottonLabel sizeThatFits:maximumLabelSize];
    _bottomLabelWidth.constant = expectSize.width;
    
    //
    
    CGFloat bomWidth = _bottomView.frame.size.width;
    CGFloat membtnwidth = _membtn.frame.size.width;
    
    CGFloat leftTrailing = (bomWidth-_bottomLabelWidth.constant-5-membtnwidth)/2;
    
    _bottomLabelLeftTrailing.constant = leftTrailing;
    
    
}
- (void)dealloc {
    [_headerImageView release];
    [_levelLabel release];
    [_endTimeLabel release];
    [_nameLabel release];
    [_bottonLabel release];
    [_membtn release];
    [_memberChangeRecode release];
    [_bottomLabelWidth release];
    
    [_bottomLabelLeftTrailing release];
    [_bottomView release];
    [super dealloc];
}
@end
