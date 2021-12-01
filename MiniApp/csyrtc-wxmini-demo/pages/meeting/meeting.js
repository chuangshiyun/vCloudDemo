// meeting.js
var { default: ChuangLiveEngine } = require('../../lib/MiniAPP-1.0.0.1.js');
const Utils = require('../../utils/util.js')
const max_user = 10;
const Layouter = require("../../utils/layout.js");
const log = require('../../utils/logs.js')
/**
 * log relevant, remove these part and relevant code if not needed
 */

Page({

  /**
   * 页面的初始数据
   */
  data: {
    /**
     * media objects array
     * this involves both player & pusher data
     * we use type to distinguish
     * a sample media object
     * {
     *   key: **important, change this key only when you want to completely refresh your dom**,
     *   type: 0 - pusher, 1 - player,
     *   uid: uid of stream,
     *   holding: when set to true, the block will stay while native control hidden, used when needs a placeholder for media block,
     *   url: url of pusher/player
     *   left: x of pusher/player
     *   top: y of pusher/player
     *   width: width of pusher/player
     *   height: height of pusher/player
     * }
     */
    media: [],
    /**
     * muted
     */
    enablemic: false,
    enablecamera: true,
    /**
     * beauty 0 - 10
     */
    beauty: 5,
    totalUser: 1,
    onlyAudio: false,
    yes: true,
    /**
     * debug
     */
    debug: false,
    loadingHidden: true,
    isbindEngineEvents: 0,
    islogin: 0,
    ispublish: true,
    hide: false,
    role: '互动',
    front: true,
    enablecam: false,
    top: 0,
    height: 0,
    titleMessage: '',
    makeupUrl: '../../images/makeup.png',
    cameraUrl: '../../images/camera.png',
    logUrl: '../../images/hang up.png',
    micUrl: '../../images/voice@3x.png',
    camUrl: '../../images/videon.png'

  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    Utils.log(` metting onLoad ${options}`);
    // get channel from page query param
    this.channel = options.channel;
    // default role to broadcaster
    this.role = options.role || ChuangLiveEngine.ChuangUserRole.INTER_ACTION;
    // var res = wx.getMenuButtonBoundingClientRect();
    if (this.role == ChuangLiveEngine.ChuangUserRole.AUDIENCE) {
      this.setData({
        yes: false,
        hide: true,
        role: '观众'
      })
    }

    // get pre-gened uid, this uid will be different every time the app is started
    this.uid = options.uid;
    // store layouter control
    this.layouter = null;
    // prevent user from clicking leave too fast
    this.leaving = false;
    this.env = options.env;
    // this.streamId = 'Chua' + parseInt(Math.random() * 100);
    this.streamId = options.uid;
    this.setData({
      loadingHidden: false
    })
    this.onlyaudio = options.onlyaudio;
    this.setData({
      onlyAudio: this.onlyaudio == 1 ? true : false
    })
    this.local = options.local == 'false' ? false : true;
    // page setup
    var title = `房间ID : ${this.channel} `;
    // var conTitle
    wx.setNavigationBarTitle({
      title: `房间ID : ${this.channel} \xa0 身份 ：${this.data.role}`
    });
    wx.setKeepScreenOn({
      keepScreenOn: true
    });

    if (this.data.onlyaudio) {
      this.setData({
        makeupUrl: '../../images/makeupn.png',
        cameraUrl: '../../images/cameran.png',
        logUrl: '../../images/hang up.png',
        micUrl: '../../images/voice@3x.png',
      })
    }
  },

  //开始推流
  bindEngineEvents() {
    var that = this;
    ChuangLiveEngine.on('RoomStateUpdate', function (roomId, state, errorCode) {
      if (state == ChuangLiveEngine.ChuangRoomState.CONNECTED && errorCode == 0) {
        log.info('登录房间成功');
        that.setData({
          islogin: !that.data.islogin
        });
        Utils.log(`loginroom succeed ${roomId}`);
        that.setData({
          // loadingHidden: true
        });
        if (that.role != ChuangLiveEngine.ChuangUserRole.AUDIENCE) {
          that.publish();

        }
      } else if (state == ChuangLiveEngine.ChuangRoomState.DISCONNECTED && errorCode == 0) {
        log.info('登出房间成功');
        that.setData({
          islogin: !that.data.islogin
        });
        Utils.log(`logout succeed ${roomId}`);
        that.role = ChuangLiveEngine.ChuangUserRole.AUDIENCE;
        if (getCurrentPages().length > 1) {

          that.navigateBack();
        }
        if (!that.leaving) {
          that.leaving = true;
        }

        that.setData({
          loadingHidden: true
        })
      }
    }).on('PublishStreamStateUpdate', function (stream, state, errorCode) {

      if (state == ChuangLiveEngine.ChuangPublishState.CONNECTED && errorCode == 0) {
        wx.showToast({
          title: '推流地址获取成功',
          icon: 'none',
          duration: 2000
        })
        Utils.log(`stream-published-${stream.streamId} ${stream.url}`);
        let ts = new Date().getTime();
        var pushUrl = stream.url + that.onlyaudio;
        log.info(`推流地址获取成功 ${pushUrl}：${stream.status}`);
        // ChuangLiveEngine.statusNotification(stream.streamId, 3005,{url:pushUrl});
        if (!that.hasMedia(0, stream.streamId)) {
          that.addMedia(0, stream.streamId, pushUrl, {
            key: ts
          })
        } else {
          that.updateMedia(stream.streamId, {
            url: pushUrl,
            key: ts
          })
        }
        Utils.log(`pusherURL ${pushUrl}`)
        Utils.log('PusherComponent start');

        that.setData({
          loadingHidden: true,
          ispublish: true
        })
        // pusher.start();
      } else if (state == ChuangLiveEngine.ChuangPublishState.DISCONNECTED && errorCode == 0) {
        Utils.log(`unpublished ${stream.streamId}`);
        log.info('停推sdk成功');
        wx.showToast({
          title: '停推sdk成功',
          icon: 'none',
          duration: 2000
        })
        var pusher = that.getPusherComponent(stream.streamId);
        pusher.stop();
        that.removeMedia(stream.streamId);
        that.setData({
          loadingHidden: true
        })
      } else if (state == ChuangLiveEngine.ChuangPublishState.CONNECTING && errorCode == 12013) {
        log.info(`推流断开重连中 ${stream.streamId}: ${stream.status}`);
        Utils.log(`pushreconn${stream.streamId}`);
      }

    }).on('RoomStreamUpdate', function (roomId, type, streamList) {
      var users = streamList;
      for (let i = 0, l = users.length; i < l; i++) {
        if (type == ChuangLiveEngine.ChuangStreamUpdateType.ADD) {
          let user = users[i];
          let streamId = user.streamId;
          ChuangLiveEngine.startPlayStream(streamId);

        } else if (type == ChuangLiveEngine.ChuangStreamUpdateType.DELETE) {
          Utils.log(`removed${users}`);
          for (let i = 0, l = users.length; i < l; i++) {
            let user = users[i];
            let streamId = user.streamId;
            ChuangLiveEngine.stopPlayStream(streamId);
          }
        }
      }
    }).on('PlayStreamStateUpdate', function (stream, state, errorCode) {
      if (stream.streamType == '1') {
        return;
      }
      if (state == ChuangLiveEngine.ChuangPlayState.CONNECTED && errorCode == 0) {
        log.info(`播流地址获取成功 ${stream.streamId}`);
        Utils.log(`播流地址获取成功 ${stream.streamId}`);
        wx.showToast({
          title: '播流地址获取成功',
          icon: 'none',
          duration: 2000
        })

        that.setData({
          loadingHidden: true
        })
        let ts = new Date().getTime();
        var playUrl = stream.url;
        if (!that.hasMedia(1, stream.streamId)) {
          that.addMedia(1, stream.streamId, playUrl, {
            key: ts
          })
        } else {
          that.updateMedia(stream.streamId, {
            url: playUrl,
            key: ts
          })
        }
        var onlyaudio = 0;
        if (Number(stream.streamstat) == 1) {
          onlyaudio = 1;
        } else if ((stream.streamstat) == 2) {

        }
        var Puller = that.getPlayerComponent(stream.streamId, onlyaudio);
        Utils.log(`playstartuid ${stream.streamId}`);
        Puller && Puller.start();

      } else if (state == ChuangLiveEngine.ChuangPlayState.DISCONNECTED && errorCode == 0) {
        log.info('停播成功');
        Utils.log(`unplayed ${stream.streamId}`);
        that.hasMedia(1, stream.streamId) && that.removeMedia(stream.streamId);
      } else if (state == ChuangLiveEngine.ChuangPlayState.CONNECTING && errorCode == 12013) {
        log.info(`播流断开重连中 ${stream.streamId}`);
        Utils.log(`playrecon ${stream.streamId}`);

      }
    })
  },
  unbindEngineEvents() {
    ChuangLiveEngine.off('RoomStateUpdate').off('PublishStreamStateUpdate').off('PlayStreamStateUpdate')
      .off('RoomStreamUpdate');
  },
  /**
   * 只有提供了该回调才会出现转发选项
   */

  onShareAppMessage() {

  },

  /**
   * calculate size based on current media length
   * sync the layout info into each media object
   */
  syncLayout(media) {
    let sizes = this.layouter.getSize(media.length);
    if (sizes > max_user) {
      return
    }
    for (let i = 0; i < sizes.length; i++) {
      let size = sizes[i];
      let item = media[i];

      if (item.holding) {
        //skip holding item
        continue;
      }
      item.left = parseFloat(size.x).toFixed(2);
      item.top = parseFloat(size.y).toFixed(2);
      item.width = parseFloat(size.width).toFixed(2);
      item.height = parseFloat(size.height).toFixed(2);
    }
    return media;
  },

  /**
   * check if current media list has specified uid & mediaType component
   */
  hasMedia(mediaType, uid) {
    let media = this.data.media || [];
    return media.filter(item => {
      return item.type === mediaType && `${item.uid}` === `${uid}`
    }).length > 0
  },

  /**
   * add media to view
   * type: 0 - pusher, 1 - player
   * *important* here we use ts as key, when the key changes
   * the media component will be COMPLETELY refreshed
   * this is useful when your live-player or live-pusher
   * are in a bad status - say -1307. In this case, update the key
   * property of media object to fully refresh it. The old media
   * component life cycle event detached will be called, and
   * new media component life cycle event ready will then be called
   */
  addMedia(mediaType, uid, url, options) {
    Utils.log(`add media- ${mediaType} ${uid} `);
    let media = this.data.media || [];

    if (mediaType === 0) {
      //pusher
      media.splice(0, 0, {
        key: options.key,
        type: mediaType,
        uid: `${uid}`,
        holding: false,
        url: url,
        left: 0,
        top: 0,
        width: 0,
        height: 0
      });
    } else {
      //player
      media.push({
        key: options.key,
        rotation: options.rotation,
        type: mediaType,
        uid: `${uid}`,
        holding: false,
        url: url,
        left: 0,
        top: 0,
        width: 0,
        height: 0
      });
    }

    media = this.syncLayout(media);

    return this.refreshMedia(media, 1);
  },

  /**
   * remove media from view
   */
  removeMedia: function (uid) {
    Utils.log(`remove media ${uid}`);
    let media = this.data.media || [];
    media = media.filter(item => {
      return `${item.uid}` !== `${uid}`
    });

    if (media.length !== this.data.media.length) {
      media = this.syncLayout(media);
      this.refreshMedia(media, 0);
    } else {
      Utils.log(`media not changed: ${JSON.stringify(media)}`)
      return Promise.resolve().catch(function (error) {
        Utils.log(`出现错误 when removeMedia`, 'error');
      });
    }
  },

  updateMedia: function (uid, options) {
    Utils.log(`update media ${uid} ${JSON.stringify(options)}`);
    let media = this.data.media || [];
    let changed = false;
    for (let i = 0; i < media.length; i++) {
      let item = media[i];
      if (`${item.uid}` === `${uid}`) {
        media[i] = Object.assign(item, options);
        changed = true;
        Utils.log(`after update media ${uid} ${JSON.stringify(item)}`)
        break;
      }
    }

    if (changed) {
      return this.refreshMedia(media);
    } else {
      Utils.log(`media not changed: ${JSON.stringify(media)}`)
      return Promise.resolve();
    }
  },

  /**
   * call setData to update a list of media to this.data.media
   * this will trigger UI re-rendering
   */
  refreshMedia: function (media, add) {
    return new Promise((resolve) => {
      for (let i = 0; i < media.length; i++) {
        if (i < max_user) {
          //show
          media[i].holding = false;
        } else {
          //hide 
          media[i].holding = true;
        }
      }
      if (media.length > max_user && add) {
        wx.showToast({
          title: '房间最多显示10人,超出者不显示',
          icon: 'none',
          duration: 5000
        });
      }

      // Utils.log(`updating media: ${JSON.stringify(media)}`);
      this.setData({
        media: media
      });
    }).catch(function (error) {
      Utils.log(`发生错误 wehen refreshMedia！`, 'error');
    });
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {

    this.initLayouter();

    this.bindEngineEvents();
    Utils.log('meeting start to loginRoom');
    if (this.data.islogin) {
      ChuangLiveEngine.logoutRoom();
    }
    Utils.log('preloginRoom');
    ChuangLiveEngine.loginRoom(this.channel, this.streamId, this.role);

  },
  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
    Utils.log(`metting onHide`);
  },
  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    Utils.log('metting onshow');

    //可能需要添加逻辑
    let media = this.data.media || [];
    media.forEach(item => {
      if (item.type === 0) {
        //return for pusher
        return;
      }
      let player = this.getPlayerComponent(item.uid);
      if (!player) {
        Utils.log(`player ${item.uid} component no longer exists`, "error");
      } else {
        // while in background, the player maybe added but not starting
        // in this case we need to start it once come back
        player.start();
      }
    });
  },

  onError: function (e) {
    Utils.log(`error: ${JSON.stringify(e)}`);
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
    Utils.log(`onUnload`);
    this.unbindEngineEvents();
    clearInterval(this.logTimer);
    clearTimeout(this.reconnectTimer);
    this.logTimer = null;
    this.reconnectTimer = null;
    // unlock index page join button
    let pages = getCurrentPages();
    if (pages.length > 1) {
      //unlock join
      let indexPage = pages[0];
      indexPage.unlockJoin();
      // ChuangLiveEngine.logoutRoom();
      ChuangLiveEngine.uninitEngine()
    }
    this.setData({
      loadingHidden: true
    })
  },

  /**
   * navigate to previous page
   * if started from shared link, it's possible that
   * we have no page to go back, in this case just redirect
   * to index page
   */
  navigateBack: function () {
    Utils.log(`attemps to navigate back`);
    if (getCurrentPages().length > 1) {
      //have pages on stack
      wx.navigateBack({});
    } else {
      //no page on stack, usually means start from shared links
      wx.redirectTo({
        url: '../index/index',
      });
    }
  },

  /**~
   * 推流状态更新回调
   */
  onPusherFailed: function () {
    Utils.log('pusher failed completely', "error");
    wx.showModal({
      title: '发生错误',
      content: '推流发生错误，请重新进入房间重试',
      showCancel: false,
      success: () => {
        this.navigateBack();
      }
    })
  },
  /**~
   * 播流状态更新回调
   */
  onPlayerFailed: function () {
    Utils.log('player failed completely', "error");
    wx.showModal({
      title: '发生错误',
      content: '播流发生错误，请重新进入房间重试',
      showCancel: false,
      success: () => {
        this.navigateBack();
      }
    })
  },
  /**
   *音频静音 需要的话再加一个视频静音
   */
  onMute: function () {
    log.info('推流静音');
    var enablemic = !this.data.enablemic;
    if (!enablemic) {
      this.setData({
        enablemic: !this.data.enablemic,
        micUrl: '../../images/voice@3x.png'
      })
    } else {
      this.setData({
        enablemic: !this.data.enablemic,
        micUrl: '../../images/voicex.png'
      })

    }
    Utils.log("this.data.enable");
  },

  /**
   * 摄像头方向切换
   */
  onSwitchCamera: function () {
    Utils.log(`switching camera`);
    // get pusher component via id

    var front = !this.data.front;
    if (front) {
      this.setData({
        front: front,
        cameraUrl: '../../images/camera.png',
      })
    } else {
      this.setData({
        front: front,
        cameraUrl: '../../images/camerax.png',
      })
    }
    const csyPusher = this.getPusherComponent(this.streamId);
    csyPusher && csyPusher.switchCamera();
  },

  /**
   * 美颜
   */
  onMakeup: function () {
    let beauty = this.data.beauty == 5 ? 0 : 5;
    if (!beauty) {
      this.setData({
        beauty: beauty,
        makeupUrl: '../../images/makeupx.png'
      })
    } else {
      this.setData({
        beauty: beauty,
        makeupUrl: '../../images/makeup.png'
      })

    }
  },
  /**
   * 停推流点击事件
   */
  onSubmitLog: function () {
    if (this.data.ispublish) {
      if (this.isBroadcaster()) {
        ChuangLiveEngine.stopPublishStream(this.streamId);
        this.setData({
          loadingHidden: false,
          ispublish: false,
          logUrl: '../../images/hangdown.png'
        })

      } else {
        Utils.log(`this role is have no promise`);
      }
    } else {
      if (this.isBroadcaster()) {
        this.publish();
        this.setData({
          loadingHidden: false,
          ispublish: true,
          logUrl: '../../images/hang up.png'
        })

      } else {
        Utils.log(`this role is have no promise`);
      }
    }
  },

  /**
   * 获取屏幕尺寸以用于之后的视窗计算
   */
  initLayouter: function () {
    // get window size info from systemInfo
    const systemInfo = wx.getSystemInfoSync();
    // 64 is the height of bottom toolbar
    this.layouter = new Layouter(systemInfo.windowWidth, systemInfo.windowHeight);
    // this.layouter = new Layouter(systemInfo.windowWidth, systemInfo.windowHeight - 64);
  },

  /**
   * return player component via uid
   */
  getPlayerComponent: function (uid, onlyaudio) {
    const csyPlayer = this.selectComponent(`#rtc-player-${uid}`) || '';
    csyPlayer.setData({
      onlyaudio: onlyaudio
    });
    return csyPlayer;
  },

  /**
   * return pusher component
   */
  getPusherComponent: function (uid) {
    const csypusher = this.selectComponent(`#rtc-pusher-${uid}`);
    return csypusher;
  },
  publish() {
    Utils.log(`start to CCLive publish ${this.onlyaudio}`);
    let streamConfig = ChuangLiveEngine.newStreamConfig(ChuangLiveEngine.ChuangStreamMode.BOTH);
    streamConfig.setVideoBitrate(500);
    if (Number(this.onlyaudio)) {
      streamConfig.setStreamstat(ChuangLiveEngine.ChuangStreamMode.AUDIO);
    }
    ChuangLiveEngine.startPublishStream(this.streamId, streamConfig)
  },

  /**
   * 判断是否是主播或者互动
   */
  isBroadcaster: function () {
    return this.role === ChuangLiveEngine.ChuangUserRole.INTER_ACTION || ChuangLiveEngine.ChuangUserRole.ANCHOR;
  },

})