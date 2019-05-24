import {NativeModules, Platform} from 'react-native'

export default class XPay {


    /**
     * 设置微信APPID
     * @param id
     */
    static setWxId(id) {
        NativeModules.RNWechatPay.setWxId(id);
    }


    /**
     * 微信支付
     * 传入参数示例
     * {
        partnerId:data.partnerId,
        prepayId: data.prepayId,
        packageValue: data.data.packageValue,
        nonceStr: data.data.nonceStr,
        timeStamp: data.data.timeStamp,
        sign: data.data.sign,
       }
     *
     *
     * @param params  参数
     * @param callBack 回调结果码 0:支付成功,
     *                          -1:原因：支付错误,可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
     *                          -2: 原因 用户取消,无需处理。发生场景：用户不支付了，点击取消，返回APP
     */
    static wxPay(params, callBack) {
        NativeModules.RNWechatPay.wxPay(params, callBack)
    }
}
