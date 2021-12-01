//csy-player.js
var { default: ChuangLiveEngine } = require('../../lib/MiniAPP-1.0.0.1.js');

const Utils = require("../../utils/util.js");
const log = require('../../utils/logs.js');
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    width: {
      type: Number,
      value: 0
    },
    height: {
      type: Number,
      value: 0
    },
    x: {
      type: Number,
      value: 0
    },
    y: {
      type: Number,
      value: 0
    },
    debug: {
      type: Boolean,
      value: !1
    },
    /**
     * 0 - loading, 1 - ok, 2 - error
     */
    status: {
      type: String,
      value: "loading",
      observer: function (newVal, oldVal) {
        Utils.log(`player status changed from ${oldVal} to ${newVal}`);
      }
    },
    orientation: {
      type: String,
      value: "vertical"
    },
    name: {
      type: String,
      value: ""
    },
    uid: {
      type: String,
      value: ""
    },
    muteAudio: {
      type: Boolean,
      value: !1
    },
    url: {
      type: String,
      value: "",
      observer: function (newVal, oldVal, changedPath) {
        // 属性被改变时执行的函数（可选），也可以写成在methods段中定义的方法名字符串, 如：'_propertyChange'
        // 通常 newVal 就是新设置的数据， oldVal 是旧数据
        // Utils.log(`player url changed from ${oldVal} to ${newVal}, path: ${changedPath}`);
      }
    },
    onlyaudio: {
      type: Number,
      value: 0
    },

  },

  /**
   * 组件的初始数据
   */
  data: {
    playContext: null,
    detached: false,
    startTime: new Date(),
    endTime: new Date(),
    timeoutId: null,
  },

  /**
   * 组件的方法列表
   */
  methods: {
    /**
     * start live player via context
     * in most cases you should not call this manually in your page
     * as this will be automatically called in component ready method
     */

    start: function (uid) {
      var that = this;
      this.setData({
        startTime: new Date()
      })
      Utils.log(`starting player`);
      if (this.data.status === "ok") {
        Utils.log(`player already started`);
        return;
      }
      if (this.data.detached) {
        Utils.log(`try to start pusher while component already detached`);
        return;
      }
      this.data.playContext ? (this.data.playContext.play({
        success: function (res) {
          Utils.log(` playContext succeed- ${that.data.uid}`);
        }
      }
      )) :
        ((this.data.playContext = wx.createLivePlayerContext(`player-${this.data.uid}`, this), this.data.playContext.play({
          success: function (res) {
            Utils.log(`playstart Success- ${that.data.uid}`)
            wx.showToast({
              title: 'live-player start succeed',
              icon: 'none',
              duration: 2000
            })
          }
        })));
    },

    /**
     * stop live pusher context
     */
    stop: function () {
      const uid = this.data.uid;
      Utils.log(`stopping player ${uid}`);
      this.data.playContext.stop({
        success: function (res) {
          Utils.log(`stopsuccess, ${uid}, ${res}`);
        }
      });
    },

    /**
     * rotate video by rotation
     */
    rotate: function (rotation) {
      let orientation = rotation === 90 || rotation === 270 ? "horizontal" : "vertical";
      Utils.log(`rotation: ${rotation}, orientation: ${orientation}, uid: ${this.data.uid}`);
      this.setData({
        orientation: orientation
      });
    },

    /**
     * 播放器状态更新回调
     */
    playerStateChange: function (e) {
      Utils.log(`live-player id: ${e.target.id}, code: ${e.detail.code}，message:${e.detail.message}`);
      var uid = e.target.id.split("-")[1].toString();
      if (e.detail.code === 2004) {
        log.info(`live-player:${uid} 视频播放开始`);
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        Utils.log(`live-player: ${uid} started playing`);

        if (this.data.status === "loading") {
          this.setData({
            status: "ok"
          });
          wx.showToast({
            title: '播放开始',
            icon: 'none',
            duration: 2000
          })
        }
      } else if (e.detail.code === -2301) {
        log.error(`live-player:${uid} 播流网络断连，抢救无效，手动重连 ${this.data.url}`);
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url })
        Utils.error(`live-player:${uid} 播流网络断连，抢救无效，手动重连 ${this.data.url}`);
        // Utils.log(`live-player ${uid} stopped`, "error");
        this.setData({
          status: "error",
        });
        // ChuangLiveEngine.playNextConn(uid);
        this.stop();
      } else if (e.detail.code === -2302) {
        log.warn(`live-player:${uid} 获取加速拉流地址失败 ${this.data.url}`);
        // ChuangLiveEngine.statusNotification(uid, e.detail.code,{url:this.data.url,msg:e.detail.message})
        Utils.log(`live-player ${uid} 获取加速拉流地址失败 ${this.data.url}`);
        this.setData({
          status: "error",
        });
      } else if (e.detail.code === 2003) {
        clearTimeout(this.data.timeoutId);
        log.info(`live-player:${uid} 收到首个视频包`);
        Utils.log(`${uid} + 收到首个视频包*****`);
        this.setData({
          endTime: new Date()
        })
        var keepTime = this.data.endTime - this.data.startTime;
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url, time: keepTime });
        // wx.showToast({
        //   title: uid + '收到首个视频包',
        //   icon: 'none',
        //   duration: 2000
        // })
        ChuangLiveEngine.sendStartPlaySingal(uid);
      } else if (e.detail.code == 2002) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.info(` live-plyer : ${uid} 已连接服务器，开始拉流 ${this.data.url}`);
        Utils.log(`live-player: ${uid} 已连接服务器，开始拉流 ${this.data.url}`);
      } else if (e.detail.code == 2001) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        this.data.timeoutId = setTimeout(() => { ChuangLiveEngine.statusNotification(uid, '001', { url: this.data.url }) }, 1e4);

        log.info(` live-plyer : ${uid} 已经连接服务器 ${this.data.url}`);
        Utils.log(` live-plyer : ${uid} 已经连接服务器 ${this.data.url}`);
      } else if (e.detail.code == 2009) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(` live-plyer : ${uid}视频分辨率改变`);
        Utils.log(` live-plyer : ${uid} 视频分辨率改变`);
      } else if (e.detail.code == 3001) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.error(`RTMP -DNS解析失败 ${uid}：${this.data.url} `);
        Utils.log(` RTMP -DNS解析失败 ${uid} ：${this.data.url}`);
        this.stop();
      } else if (e.detail.code == 3002) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.error(`rtmp 服务器连接失败 ${uid}：${this.data.url} `);
        Utils.log(` rtmp 服务器连接失败 ${uid} ：${this.data.url}`);
        this.stop();
      } else if (e.detail.code == 3003) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.error(`rtmp 服务器握手失败 ${uid} ：${this.data.url}`);
        Utils.log(` rtmp 服务器握手失败 ${uid} ：${this.data.url}`);
        this.stop();
      } else if (e.detail.code == 3005) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.error(`RTMP 读/写失败，之后会发起网络重试 ${uid} ：${this.data.url}`);
        Utils.log(` RTMP 读/写失败，之后会发起网络重试 ${uid}：${this.data.url} `);
        this.stop();
      } else if (e.detail.code == 2101) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(`当前视频帧解码失败  ${uid} `);
        Utils.log(` 当前视频帧解码失败 ${uid} `);
      } else if (e.detail.code == 2102) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(`当前音频帧解码失败  ${uid} `);
        Utils.log(` 当前音频帧解码失败 ${uid} `);
      } else if (e.detail.code == 2103) {
        console.log('$$$$4$$$$$$$$$$$$$$', uid);
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(`播流网络断连, 已启动自动重连  ${uid} ：${this.data.url}`);
        Utils.log(` 播流网络断连, 已启动自动重连 ${uid} ：${this.data.url}`);
        this.stop();
      } else if (e.detail.code == 2104) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(`网络来包不稳：可能是下行带宽不足，或由于主播端出流不均匀  ${uid} `);
        Utils.log(` 网络来包不稳：可能是下行带宽不足，或由于主播端出流不均匀 ${uid} `);
      } else if (e.detail.code == 2105) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(`当前视频播放出现卡顿  ${uid} `);
        Utils.log(` 当前视频播放出现卡顿 ${uid} `);
      } else if (e.detail.code == 2106) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(`硬解启动失败，采用软解  ${uid} `);
        Utils.log(` 硬解启动失败，采用软解 ${uid} `);
      }
      else if (e.detail.code == 2107) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(`当前视频帧不连续，可能丢帧  ${uid} `);
        Utils.log(` 当前视频帧不连续，可能丢帧 ${uid} `);
      }
      else if (e.detail.code == 2108) {
        ChuangLiveEngine.statusNotification(uid, e.detail.code, { url: this.data.url });
        log.warn(`当前流硬解第一个I帧失败，SDK自动切软解  ${uid} `);
        Utils.log(` 当前流硬解第一个I帧失败，SDK自动切软解 ${uid} `);
      }
    },

    //网络变化通知
    recorderNetChange: function (e) {
      Utils.log(`pullurl:${this.data.url} network: ${JSON.stringify(e.detail)}`);
    },
    //播放声音大小通知
    audioVolumeChange: function (e) {
      // Utils.log(`pullurl:${this.data.url} audiovolume: ${JSON.stringify(e.detail)}`);
    }
  },
  /**
   * 组件生命周期
   */
  attached: function () {
    Utils.log(`player attached`);
  },
  ready: function () {
    Utils.log(`player ready`);
    this.data.playContext || (this.data.playContext = wx.createLivePlayerContext(`player-${this.data.uid}`, this));
    // if we already have url when component mounted, start directly
    if (this.data.url) {
      if (this.data.url.indexOf('onlyaudio = 1') != -1) {
        this.setData({
          onlyaudio: 1
        })
      }
      this.start(this.data.uid);
    }
  },
  moved: function () {
    Utils.log(`player ${this.data.uid} moved`);
  },
  detached: function () {
    Utils.log(`player ${this.data.uid} detached`);
    // auto stop player when detached
    this.data.playContext && this.data.playContext.stop();
    this.data.detached = true;
  }
})
