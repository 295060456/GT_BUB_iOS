//
//  ApiConfig.m
//  gtp
//
//  Created by Aalto on 2019/1/3.
//  Copyright © 2019 Aalto. All rights reserved.
//

#import "ApiConfig.h"

@implementation ApiConfig
+ (NSString *)getAppApi:(ApiType)type{
    NSString *api = nil;
    switch (type)
    {
        case ApiType_Home: api = @"mar/pbmts.do"; break;//查看火币行情信息 (首页)
        case ApiType_HomeBanner: api = @"fac/pbqbs.do"; break;//首页BANNER
            
        case ApiType_UserAssert: api = @"acc/pbads.do"; break;//用户资产查询
        case ApiType_UserAssertList: api = @"acc/pbahs.do"; break;//用户资产变更查询
            
        case ApiType_Transfer: api = @"acc/pbats.do"; break;//用户转账接口(扫码转账)
        case ApiType_MultiTransfer: api = @"acc/pbata.do"; break;//用户转账接口(多种)
            
        case ApiType_TransferBrokeageRate: api = @"fac/pbqps.do"; break;//?????
            
        case ApiType_TransferRecord:api = @"acc/pbtrs.do"; break;//用户转账记录
        case ApiType_TransferDetail:api = @"acc/pbtds.do"; break;//用户转账详情
            
        case ApiType_Transaction: api = @"mer/pbadv.do"; break;//广告列表
        case ApiType_TransactorInfo: api = @"mer/pbmms.do"; break;//商户信息查询
        case ApiType_TransactionPay: api = @"ord/pbpos.do"; break;//用户下单购买
        case ApiType_TransactionComfirmPay: api = @"ord/pbcfs.do"; break;//买家确认付款
        case ApiType_TransactionCancelPay: api = @"ord/pbcos.do"; break;//取消订单
        case ApiType_TransactionOrderDetail: api = @"ord/pbquo.do"; break;//订单详情查询
        case ApiType_TransactionOrderList: api = @"ord/pbuos.do"; break;//订单列表查询
        case ApiType_TransactionOrderSureDistribute: api = @"ord/pbcrs.do"; break;//商家确认收款
            
        case ApiType_NoReadMsgList: api = @"mes/pbqms.do"; break;//查看消息未读列表(联系商家)
        case ApiType_EventMsgList: api = @"ord/pbmls.do"; break;//消息分类列表
            
        case ApiType_SubmitAppeal: api = @"ord/pbaos.do"; break;//订单申诉
        case ApiType_CancelAppeal: api = @"ord/pbcls.do"; break;//取消申诉
            
        case ApiType_Register: api = @"usr/pbrus.do"; break;//注册
        case ApiType_Login: api = @"usr/pblin.do"; break;//登陆
            
        case ApiType_LoginOut: api = @"usr/pblou.do"; break;//登出
        case ApiType_FetchNickName: api = @"usr/pbqun.do"; break;//根据用户ID查询用户昵称(融云)
            
        case ApiType_CheckUserInfo: api = @"usr/pbpis.do"; break;//个人信息查询
        case ApiType_ChangeNickname: api = @"usr/pbmns.do"; break;//用户修改昵称
            
        case ApiType_IdentityApply: api = @"usr/pbvcs.do"; break;//实名认证申请
        case ApiType_IdentitySaveFacePlusResult: api = @"fac/pbsrs.do"; break;//保存face++成功结果
            
        case ApiType_IdentityVertify: api = @"usr/pbrps.do"; break;//找回密码
            
        case ApiType_Vertify: api = @"usr/pbggc.do"; break;//校验谷歌验证码
        case ApiType_YanZlongPW: api = @"usr/pbcpw.do"; break;// 校验登录名密码
        case ApiType_RongCloudToken: api = @"usr/pbqus.do"; break;//获取用户融云token
            
        case ApiType_SettingFundPW: api = @"usr/pbstg.do"; break;//交易密码设置
        case ApiType_ChangeFundPW: api = @"usr/pbvcs.do"; break;//实名认证申请
        case ApiType_ChangeLoginPW: api = @"usr/pbvcs.do"; break;//实名认证申请  ???
        case ApiType_AboutUs: api = @"sys/pbqis.do"; break;//关于我们和APP版本号
        case ApiType_MyTransferCode: api = @"acc/pbaas.do"; break;//账户地址查询
        case ApiType_FaceIdentity: api = @"fac/pbfrs.do"; break;//保存人脸识别结果
       
        case ApiType_HelpCentre: api = @"fac/pbpcs.do"; break;//获取平台联系方式

        case ApiType_GoogleSecret: api = @"usr/pbggg.do"; break;//生成谷歌验证码
        case ApiType_BindingGoogle: api = @"usr/pbbgg.do";break;//绑定谷歌验证
        case ApiType_DismissGoogle:api = @"usr/pbrgc.do";break;//解除谷歌验证
        case ApiType_SwitchGoogle:api = @"usr/pbsvs.do";break;//谷歌验证开关
            
            
        case ApiType_AddAccount: api = @"mer/pbapw.do"; break;//添加收款方式
        case ApiType_EditAccount: api = @"mer/pbupw.do"; break;//修改收款方式
        case ApiType_DeleteAccount: api = @"mer/pbdpw.do"; break;//删除收款方式
        case ApiType_PayMentAccountList: api = @"mer/pbpws.do"; break;//收款方式列表
            
        case ApiType_TransactionsOptionsCheck: api = @"fac/pbacs.do"; break;//固定金额和限额范围(条件)
        case ApiType_PostAdsCheck: api = @"mer/pbadl.do"; break;//获取广告限制
        case ApiType_PostAds: api = @"mer/pbpas.do"; break;//????
        case ApiType_ModifyAds: api = @"mer/pbuas.do"; break;//商家广告修改
            
        case ApiType_AdsDetail: api = @"mer/pbqad.do"; break;//查询广告详情
        case ApiType_AdsList: api = @"mer/pbmas.do"; break;//商家广告列表
        case ApiType_OutlineAds: api = @"mer/pbcas.do"; break;//下架广告
        case ApiType_OnlineAds: api = @"mer/pbsas.do"; break;//上架广告
            
            
        case ApiType_BTCCheck: api = @"btc/pbers.do"; break;//BTC汇率查询
        case ApiType_BTCApply: api = @"btc/pbebs.do"; break;//BTC兑换申请
        case ApiType_BTCList: api = @"btc/pbels.do"; break;//BTC兑换申请列表
        case ApiType_BTCDetail: api = @"btc/pbeds.do"; break;//兑换BTC申请详情
        case ApiType_BTCBack: api =@"btc/pbces.do"; break;//撤销兑换BTC申请
            
        case ApiType_Homes: api = @"itemApi/searchIndexSourceList"; break;//??????
        case ApiType_AppealComplete: api =@"ord/pbods.do"; break;   // 查询订单申诉结果
            
        case ApiType_AppealAgree: api =@"ord/pbaao.do"; break;   // 认同申诉原因
            
        case ApiType_AppealAnti: api =@"ord/pbdao.do"; break;   // 反驳申诉 或 订单关闭
            
        case ApiType_AppealCancelAnti: api =@"ord/pbcat.do"; break;   // 取消反驳申诉
            
        case ApiType_FeacIDToken: api =@"usr/pbgtk.do"; break;   // 获取高级认证Token
            
        case ApiType_FaceIDResults: api =@"usr/pbgfr.do"; break;   // s识别结果查询
        /* 登录更新 */
        case ApiType_SendMessageAuthenticationCode: api = @"mes/pbsmc.do";break;//发送短信验证码
        case ApiType_CheckMessageAuthenticationCode:api = @"mes/pbvsc.do";break;//校验短信验证码是否正确
        case ApiType_ResetPassword:api = @"usr/pbrpd.do";break;//根据手机号重置密码 单独一个接口
        case ApiType_NoeBuyBubType:api = @"ord/pbokb.do";break;
        case ApiType_ChengeIphoneNumber:api = @"usr/pbrph.do";break;//修改手机号码
        
        //xc
        case ApiType_XC_VersionUpdate:api = @"cli/pbver.do?model=IOS";break;//检查版本号
    }
    
    return api;
}

@end

