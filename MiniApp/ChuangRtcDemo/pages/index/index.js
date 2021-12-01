//index.js

var { default: ChuangLiveEngine } = require('../../lib/MiniAPP-1.0.0.1.js');

//微信控制台打印
const { log } = require('../../utils/logs.js');
const Utils = require('../../utils/util.js');
var app = getApp();
Page({
  /**
   * 页面的初始数据
   */
  data: {
    // used to store user info like portrait & nickname
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    canIUseGetUserProfile: false,
    canIUseOpenData: wx.canIUse('open-data.type.userAvatarUrl') && wx.canIUse('open-data.type.userNickName'), // 如需尝试获取用户信息可改为false
    // whether to disable join btn or not
    disableJoin: false,
    //true为隐藏
    loadingHidden: true,
    version: '',
    env: 'beta',
    // environs: [{
    //     value: 'online',
    //     name: '线上53L '
    //   },
    //   {
    //     value: 'beta',
    //     name: 'beta',
    //     checked: 'true'
    //   },
    //   {
    //     value: 'test',
    //     name: '测试 '
    //   },
    // ],

    // streamType: [{
    //     value: 'video',
    //     name: '音视频',
    //     checked: 'true'
    //   },
    //   {
    //     value: 'audio',
    //     name: '纯音频'
    //   }
    // ],

    // trans: [
    //   { value: 'local', name: '本地 ' },
    //   { value: 'all', name: '全流程', checked: 'true' },
    // ],
    onlyaudio: false,
    local: false,
    appid: '',
    appkey: '',
    top: 0,
    inputChannelValue: null,
    inputStreamlValue: null
  },

  /**
   * 生命周期函数--监听页面加载
   * uid赋值，设置获取userInfo
   */
  onLoad: function (options) {
    var res = wx.getMenuButtonBoundingClientRect();
    this.setData({
      top: res.top + 10
    })
    Utils.log('index onLoad')
    // this.channel = "";
    // this.uid = '';
    this.role = ChuangLiveEngine.ChuangUserRole.INTER_ACTION;
    this.lock = false;
    //该方法必须通过点击按钮才可触发，如果需要显示，添加一个按钮来触发

    // if (wx.getUserProfile) {
    //   this.setData({
    //     canIUseGetUserProfile: true
    //   })
    // }

  },

  getUserProfile(e) {
    // 推荐使用wx.getUserProfile获取用户信息，开发者每次通过该接口获取用户个人信息均需用户确认，开发者妥善保管用户快速填写的头像昵称，避免重复弹窗
    wx.getUserProfile({
      desc: '展示用户信息', // 声明获取用户个人信息后的用途，后续会展示在弹窗中，请谨慎填写
      success: (res) => {
        console.log(res)
        this.setData({
          userInfo: res.userInfo,
          hasUserInfo: true
        })
      }
    })
  },
  getUserInfo(e) {
    // 不推荐使用getUserInfo获取用户信息，预计自2021年4月13日起，getUserInfo将不再弹出弹窗，并直接返回匿名的用户个人信息
    console.log(e)
    this.setData({
      userInfo: e.detail.userInfo,
      hasUserInfo: true
    })
  },

  /**
   * 生命周期函数--监听页面
   * 初次渲染完成，进行初始化ChuangLiveEngine.init()
   */
  onReady: function () {
    Utils.log('页面渲染完成进行初始化');
    wx.clearStorage({
      success: (res) => {
        Utils.log('clearStorage')
      },
    })
    var date = ChuangLiveEngine.getSDKVersion();
    this.setData({
      version: date
    })

  },

  /**
   * 只有提供了该回调才会出现转发选项
   */
  onShareAppMessage() {
    Utils.log('index onShareAppMessage');
  },

  onShow: function () {
    Utils.log(`index onShow`);
    this.setData({
      inputChannelValue: null,
      inputStreamlValue: null
    })
    this.setData({
      appid: app.globalData.appid,
      appkey: app.globalData.appkey,
      onlyaudio: app.globalData.onlyaudio
    })
  },
  /**
   * 生命周期函数--监听页面隐藏
   * 
   */
  onHide: function () {
    Utils.log('index onHide');

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
    Utils.log('index onUnload');
  },

  /**
   * callback to get user info
   * using wechat open-type
   * 点击加入房间按钮触发，接收触发获取用户信息回调的结果作为参数，并将用户信息存进缓存
   */
  onGotUserInfo: function (e) {
    Utils.log('getUserInfo success');
    let userInfo = e.detail.userInfo || {};
    wx.setStorage({
      key: 'userInfo',
      data: userInfo,
    })
    this.onJoin(userInfo);

  },
  /**
   * check if join is locked now, this is mainly to prevent from clicking join btn to start multiple new pages
   */
  checkJoinLock: function () {
    return !(this.lock || false);
  },

  lockJoin: function () {
    this.lock = true;
  },

  unlockJoin: function () {
    this.lock = false;
  },
  generalFailure: function (errorCode) {
    Utils.log(`${errorCode}`);
  },
  /**
   * @description 加入房间，该处channel表示房间号
   */
  onJoin: function () {
    // wx.getUserProfile({
    //   desc: 'desc',
    // success(res){
    //   console.log('systemInfo------',res)
    // }});
    Utils.log(`${this.data.appid} appkey ${this.data.appkey}`)
    ChuangLiveEngine.initEngine(this.data.appid, this.data.appkey, this.generalFailure)

    // userInfo = userInfo || {};
    // var value = this.channel || "";
    var value = this.data.inputChannelValue || "";
    // var uid = this.uid || '';
    var uid = this.data.inputStreamlValue || '';
    if (!value || !uid) {
      wx.showToast({
        title: '请提供一个有效的房间名或流名',
        icon: 'none',
        duration: 2000
      })
    } else {
      if (this.checkJoinLock()) {
        this.lockJoin();
        if (value === "csy") {
          // go to test page if channel name is csy
          wx.navigateTo({
            url: `../test/test`
          });
        } else {
          var that = this;
          wx.showModal({
            title: '是否推流',
            content: '选择取消则作为观众加入，观众模式不推流',
            showCancel: true,
            success: function (res) {
              that.role = ChuangLiveEngine.ChuangUserRole.AUDIENCE;
              if (res.confirm) {
                that.role = ChuangLiveEngine.ChuangUserRole.INTER_ACTION;
              }
              wx.navigateTo({
                url: `../meeting/meeting?channel=${that.data.inputChannelValue}&uid=${that.data.inputStreamlValue}&role=${that.role}&onlyaudio=${app.globalData.onlyaudio}`,

              });

            }
          })
        }
      }
    }
  },
  onInputChannel: function (e) {
    let value = e.detail.value;
    this.setData({
      inputChannelValue: value
    })
  },
  onInputStream: function (e) {
    let value = e.detail.value;
    this.setData({
      inputStreamlValue: value
    })
    // this.uid = value;
  },

  setCon() {
    wx.navigateTo({
      url: `../setting/setting?version= ${this.data.version}`,
    })
  }

})