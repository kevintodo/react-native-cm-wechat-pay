//
//  RNWechatPay.m
//  RNWechatPay
//
//  Created by kang on 2019/5/21.
//  Copyright © 2019 chenmai. All rights reserved.
//

#import "RNWechatPay.h"

@implementation RNWechatPay
{
    NSString *wxOpenId;
    RCTResponseSenderBlock wxCallBack;
}
RCT_EXPORT_MODULE(RNWechatPay)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:@"RCTOpenURLNotification" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)handleOpenURL:(NSNotification *)aNotification
{
    NSString * aURLString =  [aNotification userInfo][@"url"];
    NSURL * aURL = [NSURL URLWithString:aURLString];
    
    if ([WXApi handleOpenURL:aURL delegate:self])
    {
        return YES;
    } else {
        return NO;
    }
}

RCT_EXPORT_METHOD(setWxId:(NSString *)wxid){
    wxOpenId = wxid;
    [WXApi registerApp:wxid];
}

RCT_EXPORT_METHOD(wxPay:(NSDictionary *)params  callback:(RCTResponseSenderBlock)callback)
{
    
    NSLog(@"wxPay:%@", params);
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = wxOpenId;
    // 商家id，在注册的时候给的
    req.partnerId = params[@"partnerId"];
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId= params[@"prepayId"];
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package= params[@"packageValue"];
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = params[@"nonceStr"];
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = params[@"timeStamp"];
    req.timeStamp = stamp.intValue;
    // 这个签名也是后台做的
    req.sign = params[@"sign"];
    //发送请求到微信，等待微信返回onResp
    dispatch_async(dispatch_get_main_queue(), ^{
        [WXApi sendReq:req];
    });
    wxCallBack = callback;
}

- (void)onReq:(BaseReq *)req{
    NSLog(@"onReq%@",req);
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        if (wxCallBack != nil) {
            NSMutableDictionary *data = [NSMutableDictionary new];
            [data setValue:resp.errStr forKey:@"errStr"];
            [data setValue:@(resp.type) forKey:@"type"];
            [data setValue:@(resp.errCode) forKey:@"errCode"];
            wxCallBack([[NSArray alloc] initWithObjects:data, nil]);
            wxCallBack = nil;
        }
    }
}

@end
