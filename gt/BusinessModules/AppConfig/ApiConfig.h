//
//  ApiConfig.m
//  gtp
//
//  Created by Aalto on 2019/1/3.
//  Copyright © 2019 Aalto. All rights reserved.
//

#ifndef ApiConfig_h
#define ApiConfig_h


//正式发布环境
//#define URL_IP @"https://api.bubchain.com/ug/"



//阿里云测试环境
//#define URL_IP @"http://otctest.bubchain.com/ug/"



//开发环境
#define URL_IP @"http://192.168.15.157:8010/ug/"






//外包的环境
//#define URL_IP @"http://47.52.45.85:8010/ug/"
//Lewis的环境
//#define URL_IP @"http://192.168.21.180:8010/ug/"

#define LNURL_IP @"http://www.liniuyang.com/"
//请求Cookie接口
//#define API_GetCookie @"uuserApi/OKay"

#endif /* ApiConfig_h */

typedef NS_ENUM(NSInteger, ApiType)
{
    //    ApiTypeNone = 0,
    
    ApiType_Home,//查看火币行情信息 (首页)
    ApiType_HomeBanner,//首页BANNER
    ApiType_UserAssert,//用户资产查询
    ApiType_UserAssertList,//用户资产变更查询
    
    
    ApiType_Transfer,//用户转账接口(扫码转账)
    ApiType_MultiTransfer,//用户转账接口(多种)
    
    ApiType_TransferBrokeageRate,//?????
    
    ApiType_TransferRecord,//用户转账记录
    
    ApiType_TransferDetail,//用户转账详情
    
    ApiType_Transaction,//广告列表
    ApiType_TransactorInfo,//商户信息查询
    ApiType_TransactionPay,//用户下单购买
    ApiType_TransactionComfirmPay,//买家确认付款
    ApiType_TransactionCancelPay,//取消订单
    ApiType_TransactionOrderDetail,//订单详情查询
    ApiType_TransactionOrderList,//订单列表查询
    ApiType_TransactionOrderSureDistribute,//商家确认收款
    
    ApiType_NoReadMsgList,//查看消息未读列表(联系商家)
    ApiType_EventMsgList,//消息分类列表
    //    ApiType_CancelAppeal,
    
    ApiType_SubmitAppeal,//订单申诉
    ApiType_CancelAppeal,//取消申诉
    
    ApiType_Register,//注册
    ApiType_Login,//登陆
    ApiType_LoginOut,//登出
    ApiType_FetchNickName,//根据用户ID查询用户昵称(融云)
    
    ApiType_CheckUserInfo,//个人信息查询
    ApiType_ChangeNickname,//用户修改昵称
    
    
    ApiType_IdentityApply,//实名认证申请
    ApiType_IdentitySaveFacePlusResult,//保存face++成功结果
    ApiType_IdentityVertify,//找回密码
    ApiType_YanZlongPW,// 校验登录名密码
    ApiType_Vertify,//校验谷歌验证码
    
    ApiType_SettingFundPW,//交易密码设置
    ApiType_ChangeFundPW,//实名认证申请
    ApiType_ChangeLoginPW,//实名认证申请  ???
    ApiType_RongCloudToken,//获取用户融云token 登录状态
    
    ApiType_FaceIdentity,//保存人脸识别结果
    
    ApiType_AboutUs,//关于我们和APP版本号
    ApiType_MyTransferCode,//账户地址查询
    ApiType_HelpCentre,//获取平台联系方式
    
    ApiType_GoogleSecret,//生成谷歌验证码
    ApiType_BindingGoogle,//绑定谷歌验证
    ApiType_DismissGoogle,//解除谷歌验证
    ApiType_SwitchGoogle,//谷歌验证开关
    
    ApiType_AddAccount,//添加收款方式
    ApiType_EditAccount,//修改收款方式
    ApiType_DeleteAccount,//删除收款方式
    ApiType_PayMentAccountList,//收款方式列表
    
    ApiType_TransactionsOptionsCheck,//固定金额和限额范围(条件)
    ApiType_PostAdsCheck,//获取广告限制
    ApiType_PostAds,//发布商家广告
    ApiType_ModifyAds,//商家广告修改
    ApiType_AdsDetail,//查询广告详情
    ApiType_AdsList,//商家广告列表
    ApiType_OutlineAds,//下架广告
    ApiType_OnlineAds,//上架广告
    
    ApiType_BTCCheck,//BTC汇率查询
    ApiType_BTCApply,//BTC兑换申请
    ApiType_BTCList,//BTC兑换申请列表
    ApiType_BTCDetail,//兑换BTC申请详情
    ApiType_BTCBack,//撤销兑换BTC申请
    
    ApiType_Homes,//??????
    ApiType_AppealComplete, //申诉结果查询
    ApiType_AppealAgree,
    ApiType_AppealAnti,  // 反驳申诉 或 订单关闭
    ApiType_AppealCancelAnti,  // 取消反驳申诉
    
    ApiType_FeacIDToken, // s获取高级认证Token
    ApiType_FaceIDResults, // s识别结果查询
    ApiType_ChengeIphoneNumber, // 修改手机号码
    ApiType_SendMessageAuthenticationCode,//发送短信验证码
    ApiType_CheckMessageAuthenticationCode,//校验短信验证码是否正确
    ApiType_ResetPassword,//根据手机号重置密码
    ApiType_NoeBuyBubType,//一键购买
    ApiType_XC_VersionUpdate,//检查版本号
    
    
};
@interface ApiConfig : NSObject

+ (NSString *)getAppApi:(ApiType)type;

@end

