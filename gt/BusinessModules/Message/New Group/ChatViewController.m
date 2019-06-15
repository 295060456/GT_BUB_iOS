//
//  ChatViewController.m
//  gt
//
//  Created by cookie on 2018/12/29.
//  Copyright © 2018 GT. All rights reserved.
//

#import "ChatViewController.h"
#import "TimeTableViewCell.h"
#import "PromptTableViewCell.h"
#import "AutoTableViewCell.h"
#import "FromTableViewCell.h"
#import "ToTableViewCell.h"
#import "ChatBaseCell.h"
#import "SSAddImage.h"
#import "SSImageGroupView.h"
#import "ChatKeyBoardInputView.h"
#import "SSChatLocationController.h"
#import "SSChatMapController.h"
#import "ChatMessage.h"
#import <RongIMKit/RongIMKit.h>



@interface ChatViewController ()<ChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ChatBaseCellDelegate>
@property (nonatomic,strong) UITableView * tableView;
//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;
//数据
@property(nonatomic,strong)NSMutableArray *datas;

//底部输入框 携带表情视图和多功能视图
@property(nonatomic,strong)ChatKeyBoardInputView *mInputView;

//访问相册 摄像头
@property(nonatomic,strong)SSAddImage *mAddImage;
@end

@implementation ChatViewController
-(instancetype)init{
    if(self = [super init]){
        _chatType = ChatConversationTypeChat;
        _datas = [NSMutableArray new];
        
        // 设置消息接收监听
        [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.navigationController.navigationBar.translucent = YES;

    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
//        清除未读消息数量          lib
        RCIMClient * client = [[RCIMClient alloc] init];
    [client clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:self.sessionId];
}
-(void)initView{
    self.navigationItem.title = _titleString;
    self.view.backgroundColor = COLOR_RGB(242, 241, 246, 1);
    [self getLatestChatData];

    
    _mInputView = [ChatKeyBoardInputView new];
    _mInputView.delegate = self;
    [self.view addSubview:_mInputView];
    
    _backViewH = MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - SSChatKeyBoardInputViewH;
    if ([YBFrameTool statusBarHeight] > 21) {
        _backViewH = _backViewH - 34;
    }else{
        _backViewH = _backViewH - 0;
    }
    
    _mBackView = [UIView new];
    _mBackView.frame = CGRectMake(0,[YBFrameTool statusBarHeight] + [YBFrameTool navigationBarHeight], MAINSCREEN_WIDTH, _backViewH);
    _mBackView.backgroundColor = COLOR_RGB(242, 241, 246, 1);
    [self.view addSubview:self.mBackView];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, _backViewH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = COLOR_RGB(242, 241, 246, 1);
    self.tableView.backgroundView.backgroundColor = COLOR_RGB(242, 241, 246, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mBackView addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    [self.tableView registerClass:NSClassFromString(@"ChatTextCell") forCellReuseIdentifier:ChatTextCellId];
    [self.tableView registerClass:NSClassFromString(@"ChatImageCell") forCellReuseIdentifier:ChatImageCellId];
    [self.tableView registerClass:NSClassFromString(@"ChatVoiceCell") forCellReuseIdentifier:ChatVoiceCellId];
    [self.tableView registerClass:NSClassFromString(@"ChatMapCell") forCellReuseIdentifier:ChatMapCellId];
    [self.tableView registerClass:NSClassFromString(@"ChatVideoCell") forCellReuseIdentifier:ChatVideoCellId];
    
//    //单聊
//    if(_chatType == ChatConversationTypeChat){

//        [_datas addObjectsFromArray:[ChatDatas LoadingMessagesStartWithChat:_sessionId]];
//    }
//    //群聊
//    else{
//        [_datas addObjectsFromArray:[ChatDatas LoadingMessagesStartWithGroupChat:_sessionId]];
//    }

    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

//获取历史聊天数据
-(void) getLatestChatData{
    
    RCIMClient * client = [[RCIMClient alloc] init];
    NSArray * arr = [client getLatestMessages:ConversationType_PRIVATE targetId:self.sessionId count:20];
    NSLog(@"%@",arr);
    
    for (int i = arr.count - 1; i>=0; i--) {
        RCMessage *message =arr[i];
        RCTextMessage * messageText = [[RCTextMessage alloc] init];
        messageText = message.content;
        NSDictionary *dic1 = @{@"text":messageText.content,
                               @"date":@"2018-10-10 09:20:15",
                               @"from":message.senderUserId,
                               @"messageId":message.messageUId,
                               @"type":[NSString stringWithFormat:@"%luld",(unsigned long)message.conversationType],
                               @"sessionId":self.sessionId,
                               @"headerImg":@"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg"
                               };
        
        ChatMessageLayout *layout = [ChatDatas getMessageWithDic:dic1];
        [self.datas addObject:layout];

    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count==0?0:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(ChatMessageLayout *)_datas[indexPath.row] cellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatMessageLayout *layout = _datas[indexPath.row];
    ChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layout.message.cellString];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.layout = layout;
    return cell;
    
}

//视图归位
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];

}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];

}
#pragma SSChatKeyBoardInputViewDelegate 底部输入框代理回调
//点击按钮视图frame发生变化 调整当前列表frame
-(void)SSChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime{

    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.mBackView.frame = CGRectMake(0, [YBFrameTool statusBarHeight] + [YBFrameTool navigationBarHeight], MAINSCREEN_WIDTH, height);
        self.tableView.frame = self.mBackView.bounds;
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } completion:^(BOOL finished) {

    }];
    
//    [_mInputView SetSSChatKeyBoardInputViewEndEditing];


}


//发送文本 列表滚动至底部
-(void)SSChatKeyBoardInputViewBtnClick:(NSString *)string{

    NSDictionary *dic = @{@"text":string};
    [self sendMessage:dic messageType:ChatMessageTypeText];
}


//发送语音
-(void)SSChatKeyBoardInputViewBtnClick:(ChatKeyBoardInputView *)view sendVoice:(NSData *)voice time:(NSInteger)second{

    NSDictionary *dic = @{@"voice":voice,
                          @"second":@(second)};
    [self sendMessage:dic messageType:ChatMessageTypeVoice];
}


//多功能视图点击回调  图片10  视频11  位置12
-(void)SSChatKeyBoardInputViewBtnClickFunction:(NSInteger)index{

    if(index==10 || index==11){
        if(!_mAddImage) _mAddImage = [[SSAddImage alloc]init];

        [_mAddImage getImagePickerWithAlertController:self modelType:SSImagePickerModelImage + index-10 pickerBlock:^(SSImagePickerWayStyle wayStyle, SSImagePickerModelType modelType, id object) {

            if(index==10){
                UIImage *image = (UIImage *)object;
                NSLog(@"%@",image);
                NSDictionary *dic = @{@"image":image};
                [self sendMessage:dic messageType:ChatMessageTypeImage];
            }

            else{
                NSString *localPath = (NSString *)object;
                NSLog(@"%@",localPath);
                NSDictionary *dic = @{@"videoLocalPath":localPath};
                [self sendMessage:dic messageType:ChatMessageTypeVideo];
            }
        }];

    }else{
        SSChatLocationController *vc = [SSChatLocationController new];
        vc.locationBlock = ^(NSDictionary *locationDic, NSError *error) {
            [self sendMessage:locationDic messageType:ChatMessageTypeMap];
        };
        [self.navigationController pushViewController:vc animated:YES];

    }
}

//发送消息
-(void)sendMessage:(NSDictionary *)dic messageType:(ChatMessageType)messageType{
    
    [ChatDatas sendMessage:dic sessionId:_sessionId messageType:messageType messageBlock:^(ChatMessageLayout *layout, NSError *error, NSProgress *progress) {
        
        
        NSString * dicstr = dic[@"text"];
        // 构建消息的内容，这里以文本消息为例。
        RCTextMessage *testMessage = [RCTextMessage messageWithContent:dicstr];
        // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                          targetId:self.sessionId
                                           content:testMessage
                                       pushContent:nil
                                          pushData:nil
                                           success:^(long messageId) {
                                               NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                           } error:^(RCErrorCode nErrorCode, long messageId) {
                                               NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                                           }];
        
        
        
        
        [self.datas addObject:layout];
        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }];
}


//收到一条消息
- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
        NSDictionary *dic1 = @{@"text":testMessage.content,
                               @"date":@"2018-10-10 09:20:15",
                               @"from":self.sessionId,
                               @"messageId":@"20181010092015",
                               @"type":@"1",
                               @"sessionId":self.sessionId,
                               @"headerImg":@"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg"
                               };
        
        ChatMessageLayout *layout = [ChatDatas getMessageWithDic:dic1];
        [self.datas addObject:layout];
        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}





#pragma SSChatBaseCellDelegate 点击图片 点击短视频
-(void)SSChatImageVideoCellClick:(NSIndexPath *)indexPath layout:(ChatMessageLayout *)layout{
    
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    
    for(int i=0;i<self.datas.count;++i){
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        ChatBaseCell *cell = [_tableView cellForRowAtIndexPath:ip];
        ChatMessageLayout *mLayout = self.datas[i];
        
        SSImageGroupItem *item = [SSImageGroupItem new];
        if(mLayout.message.messageType == ChatMessageTypeImage){
            item.imageType = SSImageGroupImage;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.image;
        }
        else if (mLayout.message.messageType == ChatMessageTypeVideo){
            item.imageType = SSImageGroupVideo;
            item.videoPath = mLayout.message.videoLocalPath;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.videoImage;
        }
        else continue;
        
        item.contentMode = mLayout.message.contentMode;
        item.itemTag = groupItems.count + 10;
        if([mLayout isEqual:layout])currentIndex = groupItems.count;
        [groupItems addObject:item];
        
    }
    
    SSImageGroupView *imageGroupView = [[SSImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
    [self.navigationController.view addSubview:imageGroupView];
    
    __block SSImageGroupView *blockView = imageGroupView;
    blockView.dismissBlock = ^{
        [blockView removeFromSuperview];
        blockView = nil;
    };
    
    [self.mInputView SetSSChatKeyBoardInputViewEndEditing];
}

#pragma ChatBaseCellDelegate 点击定位
-(void)SSChatMapCellClick:(NSIndexPath *)indexPath layout:(ChatMessageLayout *)layout{
//
    SSChatMapController *vc = [SSChatMapController new];
    vc.latitude = layout.message.latitude;
    vc.longitude = layout.message.longitude;
    [self.navigationController pushViewController:vc animated:YES];
}

//不采用系统的旋转
- (BOOL)shouldAutorotate{
    return NO;
}





@end
