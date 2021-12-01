//csy-pusher.js

var { default: ChuangLiveEngine } = require('../../lib/MiniAPP-1.0.0.1.js');

const Utils = require("../../utils/util.js");
const log = require('../../utils/logs.js');
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    minBitrate: {
      type: Number,
      value: 200
    },
    maxBitrate: {
      type: Number,
      value: 500
    },
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
    muted: {
      type: Boolean,
      value: !1
    },
    debug: {
      type: Boolean,
      value: !1
    },
    beauty: {
      type: String,
      value: 0
    },
    aspect: {
      type: String,
      value: "3:4"
    },
    audioquality: {
      type: String,
      value: 'high'
    },
    onlyaudio: {
      type: Number,
      value: 0
    },

    name: {
      type: String,
      value: ""
    },
    uid: {
      type: String,
      value: ""
    },
    enablecamera: {
      type: Boolean,
      value: !0
    },

    /**
     * 0 - loading, 1 - ok, 2 - error
     */
    status: {
      type: String,
      value: "loading",
      observer: function (newVal, oldVal, changedPath) {
        Utils.log(`player status changed from ${oldVal} to ${newVal}`);
      }
    },
    camera: {
      type: Boolean,
      value: !0
    },
    url: {
      type: String,
      value: "",
      observer: function (newVal, oldVal, changedPath) {
        // 属性被改变时执行的函数（可选），也可以写成在methods段中定义的方法名字符串, 如：'_propertyChange'
        // 通常 newVal 就是新设置的数据， oldVal 是旧数据
        // Utils.log(`pusher url changed from ${oldVal} to ${newVal}, path: ${changedPath}`);
      }
    },
    videoConfig: {
      type: Object,
      value: {
        width: 360,
        height: 480,
        fps: 15,
        bitrate: 200
      }
    }

  },

  /**
   * 组件的初始数据
   */
  data: {
    pusherContext: null,
    detached: false,
    startTime: Date.parse(new Date()),
    timeoutId: null,
  },

  /**
   * 组件的方法列表
   */
  methods: {
    /**
     * start live pusher via context
     * in most cases you should not call this manually in your page
     * as this will be automatically called in component ready method
     */
    start() {

      var startTime = Date.parse(new Date());
      this.triggerEvent({ startTime: startTime });
      Utils.log(`starting pusher ${this.data.width} ${this.data.height}`);
      if (this.data.detached) {
        Utils.log(`try to start pusher while component already detached`);
        return;
      }
      this.data.pusherContext ? this.data.pusherContext.start({
        success: function (res) {
          Utils.log(`pusherContext succeed ${res}`);
          wx.showToast({
            title: 'live-pusher start complete',
            icon: 'none',
            duration: 2000
          })
        }
      }) : (this.data.pusherContext = wx.createLivePusherContext(`pusher-${this.data.uid}`, this), this.data.pusherContext.start({
        success: function (res) {
          Utils.log(`pusherContext succeed `);
          wx.showToast({
            title: 'live-pusher start complete',
            icon: 'none',
            duration: 2000

          })
        }
      }));
    },

    /**
     * stop live pusher context
     */
    stop() {
      Utils.log(`stopping pusher`);
      this.data.pusherContext.stop({
        success: function (res) {
          Utils.log(`stopsuccess, ${res}`);
        }
      });
    },
    pause() {
      Utils.log('pause pusher');
      this.data.pusherContext.pause({
        success: function () {
          Utils.log('pause pusher success')
        },
        complete: function (res) {
          Utils.log(`complete pusher ${res}`)
        }

      })
    },

    /**
     * switch camera direction
     */
    switchCamera() {
      this.data.pusherContext.switchCamera();
    },

    setMICVolume(volume) {
      this.data.pusherContext.setMICVolume({
        volume: volume, success: function (res) {
          Utils.log(`设置推流麦克风声音成功 ${volume}`);
        }
      })
    },

    /**
     * 推流状态更新回调
     */
    recorderStateChange: function (e) {
      // Utils.log(`camera ${this.data.camera}`);
      Utils.log(`'推流状态回调${e.detail.code} ${e.detail.message}`);
      var backTime = Date.parse(new Date());
      if (backTime - this.startTime > 10) {
        log.warn('推流组件执行之间过长,返回主界面');
        wx.showModal({
          title: '运行过慢',
          content: '推流组件执行之间过长，请重新推流',
          showCancel: false,
          success: () => {
            this.navigateBack();
          }
        })
      }
      Utils.log(`live-pusher code: ${e.detail.code} - ${e.detail.message}`);
      if (e.detail.code === -1307) {
        log.warn('推流网路断连，抢救无效，即将重新启动live-pusher推流');
        //re-push
        Utils.log(`推流网路断连，抢救无效，即将重新启动live-pusher推流`);
        this.setData({
          status: "error"
        })
        this.stop();
        // ChuangLiveEngine.pushNextConn(this.data.uid);
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, e.detail.message)
      } else if (e.detail.code === 1008) {
        //started
        log.info(`live-pusher 编码器启动 `);
        Utils.log(`live-pusher 编码器启动 `);
      } else if (e.detail.code == 1001) {
        log.info(`live-pusher已连接到推流服务器 `);
        Utils.log(`live-pusher已连接到推流服务器 `);
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, e.detail.message, this.data.url)
      } else if (e.detail.code == 1002) {
        this.data.timeoutId = setTimeout(() => { ChuangLiveEngine.statusNotification(this.data.uid, '002', { url: this.data.url }) }, 1e4);
        log.info(` live-pusher与服务器握手完成，开始推流 `);
        Utils.log(` live-pusher与服务器握手完成，开始推流 `);
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, { msg: e.detail.message, url: this.data.url })
      } else if (e.detail.code == 1005) {
        log.info(`推流动态调整分辨率 `);
        Utils.log(`推流动态调整分辨率 `);
      } else if (e.detail.code == 1006) {
        log.info(` 码率动态调整 `);
        Utils.log(` 码率动态调整 `);
      } else if (e.detail.code == 1007) {
        clearTimeout(this.data.timeoutId);
        log.info(`live-pusher首帧画面采集完成 `);
        Utils.log(`live-pusher首帧画面采集完成 `);
        var url = this.data.url;
        var dataArray = url.split(/[/?]/);
        var streamId = dataArray[dataArray.length - 2];
        ChuangLiveEngine.sendStartPublishSignal(streamId);
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, { msg: e.detail.message, url: url })
        this.setData({
          status: 'ok'
        })
      } else if (e.detail.code == -1301) {
        this.stop();
        log.error('live-pusher摄像头启动失败');
        Utils.log('live-pusher摄像头启动失败', 'error');
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        wx.showToast({
          title: 'live-pusher摄像头启动失败',
          icon: 'none',
          duration: 2000
        })
      } else if (e.detail.code == -1302) {
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        log.error('live-pusher麦克风启动失败');
        Utils.log('live-pusher麦克风启动失败', 'error');
        wx.showToast({
          title: 'live-pusher麦克风启动失败',
          icon: 'none',
          duration: 2000
        })
      } else if (e.detail.code == -1303) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        log.error('视频编码失败');
        Utils.log(`视频编码失败 `);
      } else if (e.detail.code == -1304) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        log.error('音频编码失败');
        Utils.log(`音频编码失败 `);
      } else if (e.detail.code == -1305) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.message)
        log.error('live-pusher不支持的视频分辨率');
        Utils.log(`live-pusher不支持的视频分辨率 `);
      } else if (e.detail.code == -1306) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.message)
        log.error('live-pusher不支持的音频采样率');
        Utils.log(`live-pusher不支持的音频采样率 `);
      } else if (e.detail.code == -1311) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        log.error('live-pusher Android Mic打开成功，但是录不到音频数据');
        Utils.log(`live-pusher Android Mic打开成功，但是录不到音频数据 `);
      } else if (e.detail.code == 1101) {
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        log.info(`live-pusher网络状况不佳：上行带宽太小，上传数据受阻 `);
        Utils.log(`live-pusher网络状况不佳：上行带宽太小，上传数据受阻 `);
      } else if (e.detail.code == 1102) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, this.data.url)
        log.warn('live-pusher网络断连，已启动自动重连');
        Utils.log(`live-pusher网络断连，已启动自动重连`);
      } else if (e.detail.code == 1103) {
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, this.data.videoConfig)
        log.warn('硬编码启动失败,采用软编码');
        Utils.log(`硬编码启动失败,采用软编码`);
      } else if (e.detail.code == 1104) {
        this.stop()
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        log.error('视频编码失败');
        Utils.log(`视频编码失败`);
      } else if (e.detail.code == 1105) {
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        log.warn('新美颜软编码启动失败，采用老的软编码');
        Utils.log(`新美颜软编码启动失败，采用老的软编码`);
      } else if (e.detail.code == 1106) {
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code)
        log.warn('新美颜软编码启动失败，采用老的软编码');
        Utils.log(`新美颜软编码启动失败，采用老的软编码`);
      } else if (e.detail.code == 3001) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, { width: this.data.videoConfig.width, height: this.data.videoConfig.height, url: this.data.url });
        log.error(`RTMP -DNS解析失败 ${this.data.uid} : ${this.data.url}`);
        Utils.log(`RTMP -DNS解析失败 ${this.data.uid} : ${this.data.url}`);
      } else if (e.detail.code == 3002) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, { width: this.data.videoConfig.width, height: this.data.videoConfig.height, url: this.data.url });
        log.error(`live-pusherRTMP 服务器连接失败 ${this.data.uid} : ${this.data.url}`);
        Utils.log(`live-pusherRTMP 服务器连接失败 ${this.data.uid} : ${this.data.url}`);

      } else if (e.detail.code == 3003) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, { width: this.data.videoConfig.width, height: this.data.videoConfig.height, url: this.data.url });
        log.error(`live-pusherRTMP 服务器握手失败${this.data.uid}:${this.data.url}`);
        Utils.log(` live-pusherRTMP 服务器握手失败 ${this.data.uid}:${this.data.url}`);
      } else if (e.detail.code == 3004) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code);
        log.error(`RTMP服务器主动断开，请检查推流地址的合法性或防盗链有效期 ${this.data.uid} : ${this.data.url}`);
        Utils.log(`RTMP服务器主动断开，请检查推流地址的合法性或防盗链有效期 ${this.data.uid} : ${this.data.url}`);
      } else if (e.detail.code == 3005) {
        this.stop();
        ChuangLiveEngine.statusNotification(this.data.uid, e.detail.code, { width: this.data.videoConfig.width, height: this.data.videoConfig.height, url: this.data.url });
        log.error(`RTMP 读/写失败 ${this.data.uid} : ${this.data.url}`);
        Utils.log(`RTMP 读/写失败 ${this.data.uid} : ${this.data.url}`);
      }
    },
    /**
     * @description 网络状态回调
     */
    recorderNetChange: function (e) {
      Utils.log(`
      network: ${JSON.stringify(e.detail)}`);
      this.setData({
        videoConfig: {
          width: e.detail.info.videoWidth,
          height: e.detail.info.videoHeight,
          fps: e.detail.info.videoFPS,
          bitrate: e.detail.info.videoBitrate
        }
      })
      ChuangLiveEngine.statusNotification(this.data.uid, 1005, this.data.videoConfig);
    },
    recorderError: function (e) {
      Utils.log(`recorderError ${e.detail.errMsg} ${e.detail.errCode}`)
    }
  },

  /**
   * 组件生命周期
   */
  created: function () {

  },
  attached: function () {
    Utils.log(`pusher attached`);
    this.setData({
      startTime: Date.parse(new Date())
    })
  },
  ready: function () {
    Utils.log("pusher ready");
    this.data.pusherContext || (this.data.pusherContext = wx.createLivePusherContext(this));
    if (this.data.url) {
      if (this.data.url.indexOf('onlyaudio=1') != -1)
        this.setData({
          onlyaudio: 1
        })
      this.start(this.data.uid);
    }
  },
  moved: function () {
    Utils.log("pusher moved");
  },
  detached: function () {
    Utils.log("pusher detached");
    // auto stop pusher when detached
    this.data.pusherContext && this.data.pusherContext.stop();
    this.data.detached = true;
  }
})
