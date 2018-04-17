//
//  HB_textViewController.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/21.
//
//

#import "HB_textViewController.h"

@interface HB_textViewController ()<UITextViewDelegate>

@end

@implementation HB_textViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self hiddenTabBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.detailText.text = self.detailString;
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog(@"%@",URL);
    return YES;
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_detailText release];
    [super dealloc];
}
@end
