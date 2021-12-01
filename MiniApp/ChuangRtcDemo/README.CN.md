# Chuang Miniapp Tutorial

*Read this in other languages [English](README.md)*

## 简介

本 Demo 基于 Chuang Miniapp SDK 开发，能帮助开发者在微信小程序中实现视频通话及互动直播等功能。

本页演示如下内容：

* 集成 Chuang Miniapp SDK
* 加入频道
* 推流
* 订阅远端流
* 离开频道

## 准备开发环境

1. 请确保本地已安装微信开发者工具
2. 请确保有一个支持 **live-pusher** 和 **live-player** 组件的微信公众平台账号。只有特定行业的认证企业账号才可使用这两个组件。详情请[点击这里](https://developers.weixin.qq.com/miniprogram/dev/component/live-player.html)
3. 请确保在微信公众平台账号的开发设置中，给予相应的域名请求权限。

## 运行示例程序
 
1. 下载本页示例程序
2. 向客服人员获取appId 和appKey    	
3. 下载 [Chuang Miniapp SDK](https://www.chuangcache.com/docs/vcloudDocs.html#SDKDownload)，并将 SDK 命名为 “MiniAPP-1.0.0.1.js"
4. 将更名后的 "MiniAPP-1.0.0.1.js" 文件保存在本示例程序的 *lib* 文件夹下
5. 启动微信开发者工具并导入该示例程序
6. 分别在app.js, index.js, meeting.js,csy-player.js, csy-pusher.js中导入MiniAPP-1.0.0.1.js文件
7. 获取appId和appKey,在app.js文件里面，globalData对象项目进行配置
8. 输入频道名，加入频道。邀请你的朋友加入同一个频道，就可以开始视频互通了


## 代码许可

MIT 许可 (MIT)
