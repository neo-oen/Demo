//
//  HB_MemberModelCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/27.
//
//

#import "HB_MemberModelCell.h"
#import "SettingInfo.h"
@implementation HB_MemberModelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initdataWithDictionary:(NSDictionary *)dic
{
    if (!dic) {
        return;
    }
    NSArray * temparr = [dic objectForKey:@"data"];
    self.models = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * tempdic in temparr) {
        HB_MemberModel * model = [[HB_MemberModel alloc] init];
        [model setValuesForKeysWithDictionary:tempdic];
        
        [self.models addObject:model];
        [model release];
    }
    
    [self stepInterface];
}

-(void)stepInterface
{
    MemberInfoResponse * myMemberInfo = [MemberInfoResponse parseFromData:[SettingInfo getMemberInfo]];
    
    for (NSInteger i=0; i<self.models.count;i++) {
        HB_ModelItemView * item = [[HB_ModelItemView alloc] initwithModel:self.models[i] andItemIndex:i andmemberLevel:myMemberInfo.memberLevel];
        
        item.delegate = self;
        [self.contentView addSubview:item];
        
        [item release];
    }
    
    
}

-(void)itemClickWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(memberModelCell:ClickModel:)]) {
        [self.delegate memberModelCell:self ClickModel:[self.models objectAtIndex:index]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
