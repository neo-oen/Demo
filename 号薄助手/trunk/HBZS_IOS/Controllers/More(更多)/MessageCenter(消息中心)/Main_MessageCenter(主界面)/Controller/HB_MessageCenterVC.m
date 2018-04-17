//
//  HB_MessageCenterVC.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/13.
//
//

#import "HB_MessageCenterVC.h"
#import "UIViewController+TitleView.h"
#import "PushManager.h"
#import "SVProgressHUD.h"
#import "MessageCell.h"
#import "UIImageView+WebCache.h"
#import "MessageDetailVC.h"
@interface HB_MessageCenterVC ()

@end

@implementation HB_MessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenTabBar];

    [self setVCTitle:@"消息中心"];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self fetchNewMessageFromServer];

    [self createView];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [super dealloc];
    
    if (tableview) {
        [tableview release];
        tableview = nil;
    }
    
}

-(void)createView
{
    tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    
    
        
        NomessImageView = [[UIImageView alloc] init];
        NomessImageView.frame = CGRectMake(0, 0, 100, 130);
        NomessImageView.center = CGPointMake(self.view.center.x, self.view.center.y-64-50);
    [self.view addSubview:NomessImageView];
    
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无新的消息";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.alpha = 0.3;
        [NomessImageView addSubview:label];
        
        UIImageView * tempimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        tempimageView.image = [UIImage imageNamed:@"反馈-失败"];
        [NomessImageView addSubview:tempimageView];
        
        [tempimageView release];
        [label release];
    
    
}

- (void)fetchNewMessageFromServer{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PushManager * manager = [PushManager shareManager];
        [manager getMessgerforServer];//请求数据
        dispatch_async(dispatch_get_main_queue(), ^{
            //初始化控件
//            [SVProgressHUD dismiss];
            
            [self loadNewMessageFromDatabase];
        });
        
    });
}

- (void)loadNewMessageFromDatabase{
    
    if (dataArray) {
        [dataArray removeAllObjects];
    }
    
    
    FMDatabase * db = [[FMDatabase alloc] initWithPath:[self getMessageDbPath]];
    
    if (![db open]) {
        
        NSLog(@"Could not open db.");
        
        return ;
        
    }
    
    FMResultSet *newMessageResultSet = [db executeQuery:@"Select jobServerId,timestamp,isRead,iconUrl,title,content,imgTitleUrl,imgContentUrl1,imgContentUrl2,imgContentUrl3,urlDetail from NewMessage order by timestamp desc"];
    
    while ([newMessageResultSet next]) {
        NewMessage *message = [[NewMessage alloc]init];
        
        message.jobServerId = [newMessageResultSet intForColumnIndex:0];
        message.timestamp = [newMessageResultSet intForColumnIndex:1];
        message.isRead=[newMessageResultSet intForColumnIndex:2];
        message.iconUrl = [newMessageResultSet stringForColumnIndex:3];
        message.title = [newMessageResultSet stringForColumnIndex:4];
        message.content = [newMessageResultSet stringForColumnIndex:5];
        message.imgTitleUrl = [newMessageResultSet stringForColumnIndex:6];
        message.imgContentUrl1 = [newMessageResultSet stringForColumnIndex:7];
        message.imgContentUrl2 = [newMessageResultSet stringForColumnIndex:8];
        message.imgContentUrl3 = [newMessageResultSet stringForColumnIndex:9];
        message.urlDetail = [newMessageResultSet stringForColumnIndex:10];
        NSLog(@"jobSverId:%d, iconUrl:%@, title:%@, content:%@", message.jobServerId, message.iconUrl, message.title, message.content);
        
        [dataArray addObject:message];
        [message release];
    }
    
    [db close];
    
    [db release];
    
    
    [tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger MessageCount = dataArray.count;
    if (MessageCount > 0) {
        [self removeNoMessageLabel];
    }
    else
    {
        [self noMessage];
    }
    return MessageCount;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell * cell = [tableview dequeueReusableCellWithIdentifier:@"message"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] lastObject];
        
    }
    NewMessage *msg = [dataArray objectAtIndex:indexPath.row];
    if (msg.iconUrl.length > 0) {
        [cell.headImageView setImageWithURL:[NSURL URLWithString:msg.iconUrl]];
    }

    [cell setMessageType:msg.isRead];

    cell.titleLabel.text = msg.title;
    cell.contectLabel.text = msg.content;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMessage *msg = [dataArray objectAtIndex:indexPath.row];
    MessageDetailVC *detailVC = [[MessageDetailVC alloc]initWithMessage:msg];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}
- (NSString*)tableView:(UITableView*)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1) {//[[newMessageBtn titleColorForState:UIControlStateNormal] isEqual:[UIColor blueColor]]
        NewMessage *msg = [dataArray objectAtIndex:indexPath.row];
        FMDatabase * db = [[FMDatabase alloc] initWithPath:[self getMessageDbPath]];
        if (![db open]) {
            
            NSLog(@"Could not open db.");
            
            return ;
            
        }
        
        BOOL isSuccess = [db executeUpdate:@"Delete from NewMessage where jobServerId = ?", [NSNumber numberWithInt:msg.jobServerId]];
        
       
        if (!isSuccess) {
            NSLog(@"delete from Nesmessage failed...");
        }
        else{
            [dataArray removeObject:msg];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        }
        [db close];
        [db release];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadNewMessageFromDatabase];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)noMessage
{
    
    NomessImageView.hidden = NO;
    
}

-(void)removeNoMessageLabel
{
    NomessImageView.hidden = YES;
}

-(NSString *)getMessageDbPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MessageCenter.db"];
    return dbPath;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
