//
//  HB_slectphoneNumView.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/12/21.
//

#import "HB_slectphoneNumView.h"
#define sureBtnWigth 100
@implementation HB_slectphoneNumView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)setupbtn
{
    CGFloat btn_x = (self.tableview.frame.size.width-sureBtnWigth)/2;
    CGFloat btn_y = self.tableview.frame.origin.y+self.tableview.frame.size.height;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btn_x, btn_y,sureBtnWigth, 25);
    
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)btnClick:(UIButton *)btn
{
    
}
-(UITableView * )tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 180, 320) style:UITableViewStylePlain];
        _tableview.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
    }
    return _tableview;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        
    }
    
    return cell;
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
