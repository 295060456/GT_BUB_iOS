//
//  OTCConversationListVC.m
//  OTC
//
//  Created by Dodgson on 1/17/19.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import "OTCConversationListVC.h"
#import "OTCConversionVC.h"
#import "OTCConversationListCellTableViewCell.h"
#import "RongCloudManager.h"
#import "IQKeyboardManager.h"

#define kHeight_Scale MAINSCREEN_HEIGHT/667.0

@interface OTCConversationListVC ()

@property(nonatomic,assign)BOOL isClick;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic ,strong) UIView *emptyIMGView;

@end

@implementation OTCConversationListVC

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = kWhiteColor;
    
    self.isClick = 0;
    
    [self.conversationListTableView reloadData];// 更新未读消息角标
}

-(UIView*)emptyIMGView{
    if (_emptyIMGView == nil) {
        float top = YBSystemTool.isIphoneX ? 88 : 64;
        float buttom =  [YBFrameTool tabBarHeight];
        _emptyIMGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, self.view.bounds.size.height  - 88.f - buttom - top)];
        _emptyIMGView.backgroundColor = kWhiteColor;
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 143*SCALING_RATIO)/2 ,  115*kHeight_Scale , 143*SCALING_RATIO, 143*SCALING_RATIO)];
        im.image = kIMG(@"notMsgImageX");
        [_emptyIMGView addSubview:im];

        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 165*SCALING_RATIO, 153*SCALING_RATIO, 18*SCALING_RATIO)];
        la.textAlignment = NSTextAlignmentCenter;
        la.textColor = HEXCOLOR(0xCCCCCC);
        [im addSubview:la];
        la.text = @"暂无对话消息~";
        la.font = [UIFont systemFontOfSize:16*SCALING_RATIO];
        [im addSubview:la];
        
    } return _emptyIMGView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    self.navigationItem.title = @"消息";
    
    // 设置需要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
    //设置聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    //设置聊天头像为圆形
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    
    // 设置没有消息时显示的bgView
    
    [self.view addSubview:self.emptyIMGView];
    // 是否显示 无网络时的提示（默认：true）
    [self setIsShowNetworkIndicatorView:false];
    

    
    // 置顶Cell bgColor
    [self setTopCellBackgroundColor:[UIColor redColor]];
    
    
    // conversationListTableView继承自UITableView
    // 设置 头、尾视图
    [self.conversationListTableView setTableHeaderView:[UIView new]];
    [self.conversationListTableView setTableFooterView:[UIView new]];
    // 分割线
    [self.conversationListTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    // bgColor
    [self.conversationListTableView setBackgroundColor:[UIColor whiteColor]];//grayColor
    // 内间距
    [self.conversationListTableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    // 自定义CELL
    [self.conversationListTableView registerClass:[OTCConversationListCellTableViewCell class] forCellReuseIdentifier:NSStringFromClass([OTCConversationListCellTableViewCell class])];
    
    
    /*
     // 头像style (默认；矩形，圆形)
     [[RCIM sharedRCIM]setGlobalMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
     // 头像size（默认：46*46，必须>36*36）
     [[RCIM sharedRCIM]setGlobalMessagePortraitSize:CGSizeMake(46, 46)];
     
     // 个人信息,自定义后不再有效。没自定义CELL时可使用，并实现getUserInfoWithUserId代理方法（详见聊天页）
     [[RCIM sharedRCIM]setUserInfoDataSource:self];
     */
    
    // 推送
    [self setupPush];
}

// 如果关闭推送，弹框去设置推送
-(void)setupPush{
    //
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            
            //
            NSLog(@"推送关闭 8.0");
//            YTRecommendView *recV=[YTRecommendView ViewWithTitle:@"您关闭了系统通知" withContent:@"开启系统通知，以免错过重要消息" withImgName:@"orderG" withButtonTitle:@"去开启"];
//            recV.goBlock=^{
//
//                // 跳手机系统的 通知设置
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//            };
            
        }else{
            NSLog(@"推送打开 8.0");
        }
    }else{
        //
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            NSLog(@"推送关闭");
//            YTRecommendView *recV=[YTRecommendView ViewWithTitle:@"您关闭了系统通知" withContent:@"开启系统通知，以免错过重要消息" withImgName:@"orderG" withButtonTitle:@"去开启"];
//            recV.goBlock=^{
//
//                // 跳手机系统的 通知设置
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//            };
            
        }else{
            NSLog(@"推送打开");
        }
    }
}

#pragma mark 自定义CELL 以下方法按需求去实现
// dataSource (修改数据源来修改UI)（在上方新增自定义cell)
// 要更换为RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION否则不调用覆写方法）
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    
//    for (int t = 0; t < dataSource.count;t ++) {
//
//    RCConversationModel *model; //= dataSource[t];
//
//        [model setConversationModelType:RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION];
//    }
    return dataSource;
}

// height
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}
// 每行的编辑格式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(self);
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"%@",self.conversationListDataSource);
        
        // 服务器删除
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE
                                                 targetId:model.targetId];
        
        // UI本地删除
        [weakself.conversationListDataSource removeObjectAtIndex:indexPath.row];
        [weakself.conversationListTableView reloadData];
        
        NSLog(@"%@",self.conversationListDataSource);
        if (self.conversationListDataSource.count == 0) {
            [self.view addSubview:self.emptyIMGView];
        }
        
        NSLog(@"w");
    }];

    return @[delete];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

/*!
 左滑删除自定义会话时的回调
 
 @param tableView       当前TabelView
 @param editingStyle    当前的Cell操作，默认为UITableViewCellEditingStyleDelete
 @param indexPath       该Cell对应的会话Cell数据模型在数据源中的索引值
 
 @discussion 自定义会话Cell在删除时会回调此方法，您可以在此回调中，定制删除的提示UI、是否删除。
 如果确定删除该会话，您需要在调用RCIMClient中的接口删除会话或其中的消息，
 并从conversationListDataSource和conversationListTableView中删除该会话。
 */
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 服务器删除
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE
                                             targetId:model.targetId];
    
    // UI本地删除
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

/*!
 删除会话的回调
 
 @param model   会话Cell的数据模型
 */
- (void)didDeleteConversationCell:(RCConversationModel *)model{
    
    NSLog(@"111");
}

/*!
 点击Cell头像的回调
 
 @param model   会话Cell的数据模型
 */
- (void)didTapCellPortrait:(RCConversationModel *)model{
    
    
}

/*!
 长按Cell头像的回调
 
 @param model   会话Cell的数据模型
 */
- (void)didLongPressCellPortrait:(RCConversationModel *)model{
    NSLog(@"---");
}

// cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // model-dataSource
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
   
    // 请求个人信息---自己的服务器
//    __weak OTCConversationListVC *weakSelf = self;
//    if(!model.extend && model.lastestMessage){
//        //
////        [LHAFNetWork POST:YTBaseUrl(kCustomerMessage) params:@{@"userId":model.targetId} success:^(NSURLSessionDataTask *task, id responseObject) {
////
////            if(SUCCESS){
////
////                //
////                NSDictionary *dic=(NSDictionary *)responseObject[@"data"];
////                if([dic isEqual:[NSNull null]]){
////                    //
////                    return;
////                }
////                //
////                YTAccount *acount=[YTAccountTool account];
////                acount.userId=dic[@"id"];
////                acount.name=dic[@"name"];
////                acount.iconurl=YTImgBaseUrl(dic[@"photo"]);
////                //
////                RCUserInfo *userInfo = [[RCUserInfo alloc]init];
////                userInfo.userId=acount.userId;
////                userInfo.name=acount.name;
////                userInfo.portraitUri=acount.iconurl;
////
////                model.extend=userInfo;
////
////                [weakSelf.conversationListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
////            }
////        } fail:^(NSURLSessionDataTask *task, NSError *error) {
////            NSLog(@"%@",error);
////        }];
//    }
    
    //
    OTCConversationListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OTCConversationListCellTableViewCell class])];
    
    [cell setConvM:model
       withIsFirst:indexPath.row==0?true:false
      withUserInfo:model.extend];
    
    return cell;
}

// will display
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // 选中不高亮（在cell中设置无效）
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.emptyIMGView removeFromSuperview];
    // 获取Model会话类型，做其它处理
    RCConversationModel *model=cell.model;
    
    
    if(model.conversationModelType != RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION){
        // 必须强制转换
        RCConversationCell *RCcell = (RCConversationCell *)cell;
        
        // 是否未读消息数（头像右上角，默认：true）
        [RCcell setIsShowNotificationNumber:true];
        
//        RCcell.conversationTitle.text = @"conversationTitle";
//        RCcell.messageContentLabel.text =@"messageContentLabel";
//        RCcell.messageCreatedTimeLabel.text = @"RCcell.messageCreatedTimeLabel";
        
        RCcell.conversationTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
        RCcell.messageContentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        RCcell.messageCreatedTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
}

//点击消息列表进行跳转
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {

    if (self.isClick == 0) {
    
        [RongCloudManager jumpNewSessionWithSessionId:model.targetId
                                                title:@"在线客服"
                                         navigationVC:self.navigationController];
    
        self.isClick = 1;
    }

    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
}

// onRCIMReceiveMessage 收到消息 --- 更新未读角标
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
    //
    [self.conversationListTableView reloadData];
}

@end
