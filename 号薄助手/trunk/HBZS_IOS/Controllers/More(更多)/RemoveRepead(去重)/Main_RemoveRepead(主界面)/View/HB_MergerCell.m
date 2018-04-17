//
//  HB_MergerCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/17.
//
//
#define Padding 15;//间距

#import "HB_MergerCell.h"
#import "HB_MergerCellSubView.h"
#import "HB_ContactModel.h"
#import "HB_ContactDataTool.h"
#import "HB_PhoneNumModel.h"

@interface HB_MergerCell ()
/**  添加到contentView上的HB_MergerCellSubView 数组 */
@property(nonatomic,retain)NSMutableArray *subViewsArr;
/**  底部细线 */
@property(nonatomic,retain)UILabel *lineLabel;
/**  "合并"按钮 */
@property(nonatomic,retain)UIButton *mergerBtn;
/**  显示重复联系人姓名以及电话号码的容器 */
@property(nonatomic,retain)UIView *stackView;


@end

@implementation HB_MergerCell
#pragma mark - life cycle
-(void)dealloc{
    [_contactArr release];
    [_stackView release];
    [_lineLabel release];
    [_subViewsArr release];
    [super dealloc];
}
-(void)layoutSubviews{
    [super layoutSubviews];

    //容器视图
    self.stackView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width - 60, self.contentView.bounds.size.height);
    for ( int i=0; i<self.subViewsArr.count; i++) {
        HB_MergerCellSubView * view = _subViewsArr[i];
        CGFloat view_W=200;
        CGFloat view_H=60;
        CGFloat view_X=0;
        CGFloat view_Y=view_H * i ;
        view.frame=CGRectMake(view_X, view_Y, view_W, view_H);
    }
    //底部细线
    CGFloat label_W=SCREEN_WIDTH - 2 * Padding;
    CGFloat label_H=0.5;
    CGFloat label_X=Padding;
    CGFloat label_Y=self.contentView.bounds.size.height-label_H;
    self.lineLabel.frame=CGRectMake(label_X, label_Y, label_W, label_H);
    //右侧“合并”按钮
    CGFloat btn_W=44;
    CGFloat btn_H=22;
    CGFloat btn_X=self.contentView.bounds.size.width-btn_W-Padding;
    CGFloat btn_Y=self.contentView.bounds.size.height*0.5 - btn_H *0.5;
    [self.mergerBtn setFrame:CGRectMake(btn_X, btn_Y, btn_W, btn_H)];
}
#pragma mark - public methods
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_MergerCell";
    HB_MergerCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[HB_MergerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:cell.stackView];
        [cell.contentView addSubview:cell.mergerBtn];
        [cell.contentView addSubview:cell.lineLabel];
    }
    return cell;
}
#pragma mark - private methods
/**
 *  去除所有子控件（加载在stackView上的）
 */
-(void)removeAllSubViewsInStackView{
    NSArray *arr = self.stackView.subviews;
    for (int i=0; i<arr.count; i++) {
        UIView *view = arr[i];
        [view removeFromSuperview];
    }
}
/**
 *  根据一个联系人模型数组，返回一个联系人名字数组
 */
-(NSArray * )getNameArrWithModelArr:(NSArray *)contactArr{
    NSMutableArray * nameArr=[[[NSMutableArray alloc]init] autorelease];
    for (int i=0; i<contactArr.count; i++) {
        HB_ContactModel * model=contactArr[i];
        NSString * nameStr=[HB_ContactDataTool contactGetFullNameWithModel:model];
        [nameArr addObject:nameStr];
    }
    return nameArr;
}
/**
 *  根据一个联系人模型数组，返回一个联系人电话模型数组
 */
-(NSArray *)getPhoneArrWithModelArr:(NSArray * )contactArr{
    NSMutableArray * phoneArr=[[[NSMutableArray alloc]init] autorelease];
    for (int i=0; i<contactArr.count; i++) {
        HB_ContactModel * model = contactArr[i];
        NSMutableArray * tempPhoneArr=[[NSMutableArray alloc]init];
        for (int j=0; j<model.phoneArr.count; j++) {
            HB_PhoneNumModel *phoneModel = model.phoneArr[j];
            [tempPhoneArr addObject:phoneModel.phoneNum];
        }
        [phoneArr addObject:tempPhoneArr];
        [tempPhoneArr release];
    }
    return phoneArr;
}
#pragma mark - event response
-(void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(mergerCelldidMergerBtnClick:)]) {
        [self.delegate mergerCelldidMergerBtnClick:self];
    }
}

#pragma mark - setter and getter
-(void)setContactArr:(NSArray *)contactArr{
    if (_contactArr != contactArr) {
        [_contactArr release];
        _contactArr = [contactArr retain];
    }
    [self removeAllSubViewsInStackView];
    [self.subViewsArr removeAllObjects];
    //根据数组内容，添加子控件
    for (int i=0; i<contactArr.count; i++) {
        HB_MergerCellSubView * view=[[HB_MergerCellSubView alloc]init];
        HB_ContactModel * model = contactArr[i];
        //名字赋值
        NSString * fullNameStr=[HB_ContactDataTool contactGetFullNameWithModel:model];
        view.nameLabel.text = fullNameStr;
        //判断这个mode的名字，和数组中其它mode的名字是否重复,如果重复，置为红色
        //1.复制一份可变数组
        NSMutableArray * tempContactArr = [contactArr mutableCopy];
        //2.删除当前Model
        [tempContactArr removeObject:model];
        //3.获取联系人数组中，剩余的联系人的名字
        NSArray * tempNameArr = [self getNameArrWithModelArr:tempContactArr];
        //4.看剩余联系人名字有没有和这个名字重复的
        if ([tempNameArr containsObject:fullNameStr]) {
            //5.如果有重复的，则变红
            view.nameLabel.textColor=COLOR_B;
        }
        
        //如果联系人有一样的电话号码，则显示相同的电话号码；
        //如果号码都不相同，那么显示第一个号码，并且后面加上总个数
        if (model.phoneArr.count > 0) {
            //1.定义将要显示的号码
            NSString * phontStr = nil;
            //2.比较是否有重复号码
            for (int j=0; j<model.phoneArr.count; j++) {
                HB_PhoneNumModel *phoneModel = model.phoneArr[j];
                //和其他号码比较
                NSArray * otherPhoneArr=[self getPhoneArrWithModelArr:tempContactArr];
                for (int k=0; k<otherPhoneArr.count; k++) {
                    NSArray * oneArr = otherPhoneArr[k];
                    if ([oneArr containsObject:phoneModel.phoneNum]) {
                        phontStr = phoneModel.phoneNum;
                        view.phoneLabel.textColor=COLOR_B;
                        break;
                    }
                }
            }
            if (phontStr == nil) {
                HB_PhoneNumModel *phoneModel = model.phoneArr[0];
                phontStr = [NSString stringWithFormat:@"%@",phoneModel.phoneNum];
            }
            phontStr = [phontStr stringByAppendingString:[NSString stringWithFormat:@"(%d)",model.phoneArr.count]];
            view.phoneLabel.text=phontStr;
        }else{
            //view.phoneLabel.text=@"无电话号码";
        }
        
        [self.stackView addSubview:view];
        [self.subViewsArr addObject:view];
        [tempContactArr release];
        [view release];
    }
    
}
-(UIButton *)mergerBtn{
    if (!_mergerBtn) {
        _mergerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mergerBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_mergerBtn setTitle:@"合并" forState:UIControlStateNormal];
        [_mergerBtn setTitleColor:COLOR_A forState:UIControlStateNormal];
        _mergerBtn.layer.masksToBounds=YES;
        _mergerBtn.layer.borderWidth=0.5;
        _mergerBtn.layer.borderColor=[COLOR_A CGColor];
        _mergerBtn.layer.cornerRadius=3;
        [_mergerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mergerBtn;
}
-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor=COLOR_H;
    }
    return _lineLabel;
}
-(NSMutableArray *)subViewsArr{
    if (_subViewsArr ==nil) {
        _subViewsArr=[[NSMutableArray alloc]init];
    }
    return _subViewsArr;
}
-(UIView *)stackView{
    if (!_stackView) {
        _stackView = [[UIView alloc]init];
        _stackView.backgroundColor = [UIColor clearColor];
    }
    return _stackView;
}

@end
