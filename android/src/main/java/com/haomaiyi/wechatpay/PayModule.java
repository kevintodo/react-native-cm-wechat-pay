package com.haomaiyi.wechatpay;


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.util.Map;



public class PayModule extends ReactContextBaseJavaModule {


    public static String WX_APPID = "";
    public static IWXAPI wxApi = null;


    public PayModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNWechatPay";
    }


    @ReactMethod
    public void setWxId(String id) {
        WX_APPID = id;
        wxApi = WXAPIFactory.createWXAPI(getCurrentActivity(), WX_APPID);
    }

    @ReactMethod
    public void wxPayIsIntall(final Callback callback)
    {

        boolean isInstall = wxApi.isWXAppInstalled();
        callback.invoke(isInstall);
    }

    @ReactMethod
    public void wxPay(ReadableMap params, final Callback callback) {
        //data  根据服务器返回的json数据创建的实体类对象
        PayReq req = new PayReq();
        req.appId = WX_APPID;
        req.partnerId = params.getString("partnerId");
        req.prepayId = params.getString("prepayId");
        req.packageValue = params.getString("packageValue");
        req.nonceStr = params.getString("nonceStr");
        req.timeStamp = params.getString("timeStamp");
        req.sign = params.getString("sign");
        wxApi.registerApp(WX_APPID);
        XWXPayEntryActivity.callback = new WXPayCallBack() {
            @Override
            public void callBack(WritableMap result) {
                callback.invoke(result);
            }
        };
        //发起请求
        wxApi.sendReq(req);
    }

    @ReactMethod
        public void wxLogin(ReadableMap params, final Callback callback) {

            wxApi.registerApp(WX_APPID);
        //建议动态监听微信启动广播进行注册到微信
//        getCurrentActivity().registerReceiver(new BroadcastReceiver() {
//            @Override
//            public void onReceive(Context context, Intent intent) {
//
//                // 将该app注册到微信
//                wxApi.registerApp(WX_APPID);
//            }
//        }, new IntentFilter(ConstantsAPI.ACTION_REFRESH_WXAPP));

        String authScope = params.getString("authScope");
            final SendAuth.Req req = new SendAuth.Req();
            req.scope = authScope;
            req.state = "com.hmy_app";
            XWXPayEntryActivity.callback = new WXPayCallBack() {
                            @Override
                            public void callBack(WritableMap result) {
                                callback.invoke(result);
                            }
                        };
            wxApi.sendReq(req);
        }

}
