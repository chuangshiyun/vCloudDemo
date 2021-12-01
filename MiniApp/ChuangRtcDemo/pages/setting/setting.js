// pages/setting.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    switchChecked: app.globalData.onlyaudio,
    version: null
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.setData({
      switchChecked: app.globalData.onlyaudio,
      version: options.version
    })
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () { },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {

  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {

  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {

  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {

  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {

  },

  switchChange: function (e) {
    this.setData({
      switchChecked: e.detail.value
    });
    app.globalData.onlyaudio = e.detail.value ? 1 : 0;

  },

  ShowAbout: function () {
    wx.navigateTo({
      url: `../about/about?version= ${this.data.version}`
    })
  }
})