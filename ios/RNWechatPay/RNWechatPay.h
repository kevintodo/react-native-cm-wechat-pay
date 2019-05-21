//
//  RNWechatPay.h
//  RNWechatPay
//
//  Created by kang on 2019/5/21.
//  Copyright © 2019 chenmai. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import "WXApi.h"

@interface RNWechatPay : NSObject <RCTBridgeModule,WXApiDelegate>

@end
