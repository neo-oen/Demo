//
//  TimeMachineCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/12/2.
//
//

#import "TimeMachineCell.h"
@implementation TimeMachineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataWithModel:(HB_MachineDataModel *)model
{
    self.timeLabel.text = [self timeFormatterWith:model.syncTime];
    self.contactCountLabel.text = [NSString stringWithFormat:@"%ld个联系人",model.contactsCount];
    self.typeLabel.text = [self getTypeStringWith:(int)model.syncTypecode];
    
}

-(NSString * )timeFormatterWith:(NSInteger)timestanp
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timestanp];
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy/MM/dd  HH:MM:ss"];
    
    
    return [formatter stringFromDate:date];
}

-(NSString *)getTypeStringWith:(SyncTaskType)typeCode
{
    NSString * str = nil;
    switch (typeCode) {
        case TASK_ALL_DOWNLOAD:
            str = [NSString stringWithFormat:@"覆盖下载"];
            break;
        case TASK_SYNC_DOANLOAD:
            str = [NSString stringWithFormat:@"增量下载"];
            break;
        case TASK_DIFFER_SYNC:
        case TASK_MERGE_SYNC:
            str = [NSString stringWithFormat:@"同步"];
            break;
        case 0:
            str = [NSString stringWithFormat:@"批量删除"];
            break;
        default:
            break;
    }
    return str;
}

- (void)dealloc {
    [_timeLabel release];
    [_typeLabel release];
    [_contactCountLabel release];
    [super dealloc];
}
@end
