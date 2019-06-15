//
//  YBTrendsViewController.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//消息列表

#import "YBMsgViewController.h"
#import "OrderNotificationViewController.h"
#import "ContactCustomerServiceViewController.h"
#import "SystemNotificationViewController.h"
#import "MsgListTableViewCell.h"
#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>


@interface YBMsgViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray * nickNameArr;
    NSMutableArray * listMArry;
}
@property (nonatomic, strong) UITableView * tableView;
@property(nonatomic,strong)NSMutableArray *datas;

@end

@implementation YBMsgViewController

-(instancetype)init{
    if(self = [super init]){
        _datas = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    listMArry = [[NSMutableArray alloc] init];
    [self GetChatListData];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    // 设置消息接收监听
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];       //imkit
    
    //    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];    //imlib
    
    //    //定时更新列表
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getNewTimeChatList) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    
}
-(void)loginSuccessBlockMethod{
    [self GetChatListData];
}
-(void)netwoekingErrorDataRefush{
    [self GetChatListData];
}

//获取新的列表
-(void)getNewTimeChatList{
    NSLog(@"%f",self.tableView.contentOffset.y);
    [self GetChatListData];
    
}

//新消息通知         lib
- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
        [self GetChatListData];
        
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}
-(void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    [self GetChatListData];
    
    
}


//获取聊天列表数据
-(void)GetChatListData{
    
    [listMArry removeAllObjects];
    [self.tableView reloadData];
    NSArray *conversationList = [[RCIMClient sharedRCIMClient]
                                 getConversationList:@[@(ConversationType_PRIVATE),
                                                       @(ConversationType_DISCUSSION),
                                                       @(ConversationType_GROUP),
                                                       @(ConversationType_SYSTEM),
                                                       @(ConversationType_APPSERVICE),
                                                       @(ConversationType_PUBLICSERVICE)]];
    for (RCConversation *conversation in conversationList) {
        NSLog(@"会话类型：%lu，目标会话ID：%@,目标最后消息:%@", (unsigned long)conversation.conversationType, conversation.targetId,[RCKitUtility formatMessage:conversation.lastestMessage]
              );
        [listMArry addObject:conversation];
    }
    
    [self.tableView reloadData];
    
    
    
}

-(void)initView{
    
    NSArray * imgArr = @[@"icon_mess_order",@"icon_mess_service",@"icon_mess_system"];
    NSArray * titleArr = @[@"订单通知",@"联系客服",@"系统通知"];
    
    
    for (int i = 0; i < 3; i++) {
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(60 * SCALING_RATIO + i * (112 * SCALING_RATIO), 17, 32 * SCALING_RATIO, 32 * SCALING_RATIO)];
        imgView.image = [UIImage imageNamed:imgArr[i]];
        [self.view addSubview:imgView];
        
        UILabel * titleLb = [[UILabel alloc] initWithFrame:CGRectMake(50 * SCALING_RATIO + i * (112 * SCALING_RATIO) , CGRectGetMaxY(imgView.frame) + 6, 52 * SCALING_RATIO, 18)];
        titleLb.font = [UIFont systemFontOfSize:13 * SCALING_RATIO];
        titleLb.text = titleArr[i];
        [titleLb sizeToFit];
        [self.view addSubview:titleLb];
        
        UIButton * msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * MAINSCREEN_WIDTH/3, 0, MAINSCREEN_WIDTH/3, 55+18)];
        msgBtn.tag = 2000 + i;
        [msgBtn addTarget:self action:@selector(msgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:msgBtn];
        
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 88 * SCALING_RATIO, MAINSCREEN_WIDTH, 5)];
    lineView.backgroundColor = COLOR_RGB(246, 245, 250, 1);
    [self.view addSubview:lineView];
    
    float h = MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 93 * SCALING_RATIO;
    if (YBSystemTool.isIphoneX) {
        h = h - [YBFrameTool tabBarHeight] - [YBFrameTool iphoneBottomHeight];
    }else{
        h = h - [YBFrameTool tabBarHeight];
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 93 * SCALING_RATIO, MAINSCREEN_WIDTH, h)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.estimatedRowHeight = 0;
    //    self.tableView.estimatedSectionHeaderHeight = 0;
    //    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

-(void)msgBtnClick:(UIButton *)btn{
    
    if (btn.tag == 2000) {
        OrderNotificationViewController * orderVc = [[OrderNotificationViewController alloc] init];
        [self.navigationController pushViewController:orderVc animated:YES];
    }else if (btn.tag == 2001){
        ContactCustomerServiceViewController * contactVc = [[ContactCustomerServiceViewController alloc] init];
        [self.navigationController pushViewController:contactVc animated:YES];
    }else if (btn.tag == 2002){
        SystemNotificationViewController * systemVc = [[SystemNotificationViewController alloc] init];
        [self.navigationController pushViewController:systemVc animated:YES];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listMArry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80 * SCALING_RATIO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"msgListCell";
    MsgListTableViewCell *cell = (MsgListTableViewCell*)[_tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MsgListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    RCConversation *conversation = listMArry[indexPath.row];
    cell.nickLb.text = conversation.targetId;
    cell.msgLb.text =[RCKitUtility formatMessage:conversation.lastestMessage];
    cell.timeLb.text =  [self UTCchangeDate:conversation.sentTime];
    //    cell.timeLb.text = [NSString stringWithFormat:@"%lld",conversation.sentTime];
    if (conversation.unreadMessageCount == 0) {
        cell.numLb.hidden = YES;
    }else{
        cell.numLb.hidden = NO;
        
        cell.numLb.text = [NSString stringWithFormat:@"%d",conversation.unreadMessageCount];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //融云UI
    //    RCConversation *conversation = listMArry[indexPath.row];
    //    RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:conversation.targetId];
    //    //设置聊天会话界面要显示的标题
    //    chat.title = conversation.targetId;
    //    //显示聊天会话界面
    //    [self.navigationController pushViewController:chat animated:YES];
    
    
    //自定义UI
    RCConversation *conversation = listMArry[indexPath.row];
    ChatViewController *vc = [ChatViewController new];
    vc.chatType = ChatConversationTypeChat;
    vc.sessionId = conversation.targetId;
    vc.titleString = conversation.targetId;
    //    清除未读消息数量          lib
    //    RCIMClient * client = [[RCIMClient alloc] init];
    //    [client clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:conversation.targetId];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//时间转换
-(NSString *)UTCchangeDate:(double)time {
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time / 1000.0];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    NSString *staartstr=[dateformatter stringFromDate:date];
    return staartstr;
}


//新消息通知   kit
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
    NSLog(@"%d",left);
    [self GetChatListData];
    
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
