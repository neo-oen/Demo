//
//  ViewController.m
//  testAPP
//
//  Created by 王雅强 on 2018/3/28.
//  Copyright © 2018年 王雅强. All rights reserved.
//


#import "ViewController.h"
#import "ShareContactTableView.h"
#import "xxmodel.h"

#import "HB_ShareListView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet HB_ShareListView *shareLIstView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *kaiguan;

@property(nonatomic,strong)NSMutableArray * models;

@end

@implementation ViewController




- (IBAction)diyige:(UISegmentedControl *)sender {
    
//    switch ( sender.selectedSegmentIndex) {
//        case 0:
//
//            [_shareLIstView setShareListViewWith:@[]  andViewType:myShareListViewType withFirstBCA:^(ContactShareInfo *model) {
//
//            } withSecondBCA:^(ContactShareInfo *model) {
//
//            } withSendOtherBCA:^(ContactShareInfo *model) {
//
//            } withAccessorViewBCA:^(ContactShareInfo *model) {
//
//            }];
//            break;
//        case 1:
//            [_shareLIstView setShareListViewWith:[self.models copy] andViewType:myShareListViewType withFirstBCA:^(ContactShareInfo *model) {
//                 NSLog(@"----1111---");
//            } withSecondBCA:^(ContactShareInfo *model) {
//                 NSLog(@"----1111---");
//            } withSendOtherBCA:^(ContactShareInfo *model) {
//                 NSLog(@"----1111---");
//            } withAccessorViewBCA:^(ContactShareInfo *model) {
//                 NSLog(@"----1111---");
//            }];
//            break;
//        case 2:
//            [_shareLIstView setShareListViewWith:[self.models copy] andViewType:toMyShareListViewTypew withFirstBCA:^(ContactShareInfo *model) {
//                NSLog(@"----2222---");
//            } withSecondBCA:^(ContactShareInfo *model) {
//                NSLog(@"---222----");
//            } withSendOtherBCA:^(ContactShareInfo *model) {
//                NSLog(@"--2222----");
//            } withAccessorViewBCA:^(ContactShareInfo *model) {
//
//            }];
//            break;
//        default:
//            break;
//    }
//
    
    switch ( sender.selectedSegmentIndex) {
        case 0:
            
            [_shareLIstView setShareListViewWith:@[]  andViewType:myShareListViewType];
            break;
        case 1:
            [_shareLIstView setShareListViewWith:[self.models copy] andViewType:myShareListViewType];
            break;
        case 2:
            [_shareLIstView setShareListViewWith:[self.models copy] andViewType:toMyShareListViewTypew];
            break;
        default:
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
   1。实例化所需的对象，seg 和slv
     1.设置seg value为0
        1拉取自己创建的分享
        2传递给ShareListView 相应的页面
            1根据相应的页面和，传值的数量，隐藏显示相应转场相应界面
            2根据传值，显示相应的结果
     
     */
//    [_shareLIstView setShareListViewWith:nil andViewType:1];
    
//    ShareContactTableView * table = [[ShareContactTableView  alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:table];
//    [table setModels:self.models];
    
//    ShareTableView * table = [[ShareTableView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:table];
}
-(NSMutableArray *)models
{
    
    if(!_models) {
        _models = [[NSMutableArray alloc]init];
        for (int i=0; i<10; i++) {
            ContactShareInfo * model = [[ContactShareInfo alloc]init];
            model.shareurl = [NSString stringWithFormat:@"XXXXXXX-%d-XXXXXXXXX",i];
            model.extractcode = [NSString stringWithFormat:@"======x%dx=======",i+7];
            
            [_models addObject:model];
        }
        
    }
    return _models;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
