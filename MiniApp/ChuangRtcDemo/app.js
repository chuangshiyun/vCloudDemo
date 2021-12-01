//app.js
var { default: ChuangLiveEngine } = require('./lib/MiniAPP-1.0.0.1.js');
const Utils = require("./utils/util.js");
App({

  onHide: function () {
    wx.onAppHide((res) => {
      ChuangLiveEngine.statusNotification('', 401);
    })
  },
  onShow: function () {
    wx.onAppShow((result) => {
      ChuangLiveEngine.statusNotification('', 402);

    })
  },

  onLaunch: function () {
    // 展示本地存储能力
    Utils.checkSystemInfo(this);

    wx.authorize({
      scope: 'scope.record',
    });

    // 登录
    wx.login({
      success: res => {
        // 发送 res.code 到后台换取 openId, sessionKey, unionId
      }
    })
  },
  globalData: {
    userInfo: null,

    appid: '',
    appkey: '',

    onlyaudio: 0,
    appVersion: '1.0.0.0'
  }
})