package com.aocyun.chuangrtcdemo.activity;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintSet;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.VCloudApplication;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;
import com.aocyun.chuangrtcdemo.databinding.AcLiveRoomBinding;
import com.aocyun.chuangrtcdemo.external.AudioMixingHandler;
import com.aocyun.chuangrtcdemo.utils.DisplayUtil;
import com.aocyun.chuangrtcdemo.utils.LogCallback;
import com.aocyun.chuangrtcdemo.utils.Logging;
import com.aocyun.chuangrtcdemo.utils.NetworkUtil;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;
import com.aocyun.chuangrtcdemo.utils.ToastUtils;
import com.aocyun.chuangrtcdemo.views.PlayStreamView;
import com.aocyun.chuangrtcdemo.views.SettingsDialog;
import com.chuangcache.rtc.ChuangLiveEngine;
import com.chuangcache.rtc.IChuangEventHandler;
import com.chuangcache.rtc.IChuangMixStreamCallback;
import com.chuangcache.rtc.constants.ChuangLiveVideoError;
import com.chuangcache.rtc.entity.ChuangMixStreamConfig;
import com.chuangcache.rtc.entity.ChuangMixStreamInfo;
import com.chuangcache.rtc.entity.ChuangMixStreamWatermark;
import com.chuangcache.rtc.entity.ChuangNetworkSpeedQuality;
import com.chuangcache.rtc.entity.ChuangNetworkSpeedTestConfig;
import com.chuangcache.rtc.entity.ChuangPlayStreamQuality;
import com.chuangcache.rtc.entity.ChuangPublishStreamQuality;
import com.chuangcache.rtc.entity.ChuangSoundLevel;
import com.chuangcache.rtc.entity.ChuangStreamConfig;
import com.chuangcache.rtc.entity.ChuangStreamInfo;
import com.chuangcache.rtc.entity.ChuangVideoCanvas;
import com.chuangcache.rtc.entity.ChuangVideoConfig;
import com.chuangcache.rtc.enums.ChuangCameraType;
import com.chuangcache.rtc.enums.ChuangNetworkSpeedTestType;
import com.chuangcache.rtc.enums.ChuangPlayState;
import com.chuangcache.rtc.enums.ChuangPublishState;
import com.chuangcache.rtc.enums.ChuangRoomState;
import com.chuangcache.rtc.enums.ChuangStreamMode;
import com.chuangcache.rtc.enums.ChuangStreamRotation;
import com.chuangcache.rtc.enums.ChuangStreamState;
import com.chuangcache.rtc.enums.ChuangStreamType;
import com.chuangcache.rtc.enums.ChuangStreamUpdateType;
import com.chuangcache.rtc.enums.ChuangUserRole;
import com.chuangcache.rtc.enums.ChuangVideoMirrorMode;
import com.chuangcache.rtc.enums.ChuangVideoRenderMode;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.chuangcache.rtc.enums.ChuangUserRole.AUDIENCE;
import static com.chuangcache.rtc.enums.ChuangUserRole.INTERACTION;


public class LiveRoomActivity extends BaseActivity implements View.OnClickListener, LogCallback, Application.ActivityLifecycleCallbacks {
    private static final String TAG = LiveRoomActivity.class.getSimpleName();
    private ChuangLiveEngine mLiveEngine;
    private String roomId;
    private String userId;
    private String pushStreamId;
    private PlayStreamView mainView;
    private ChuangUserRole userRole;
    private List<String> playStreamList = new ArrayList<>();
    private Map<String, PlayStreamView> surfaceViewMap = new HashMap<>();
    private StringBuilder log = new StringBuilder();
    //perference
    private int mVideoBitrate;
    private int mVideoFps;
    private String rtmpAddress = "";
    private boolean enablePublishRtmp;
    private boolean enableOnlyAudio;
    private int mMixCanvasWidth;
    private int mMixCanvasHeight;
    private int mMixBitrate;
    private boolean enableQuality;
    private String mMixAddress;
    private boolean enableMixVideo;
    //mix
    private ChuangMixStreamConfig mixConfig;
    private List<ChuangMixStreamInfo> mixStreamInfoList = Collections.synchronizedList(new ArrayList<ChuangMixStreamInfo>());
    private SettingsDialog settingsDialog;
    private TextView logcatTv;
    private ChuangVideoCanvas localCanvas;
    private boolean enableRtcMix;
    private AcLiveRoomBinding binding;
    private boolean isFont = true;
    private boolean muteLocalAudio = false;
    private boolean muteLocalVideo = false;
    private int mWidth;//混流中每个view的宽
    private int mHeight;//混流中每个view高
    private boolean mixAudioSwitch;
    private ChuangPublishState chuangPublishState = ChuangPublishState.PUBLISH_CONNECTING;
    private boolean enableNetSpeed = false;
    private boolean enableSoundLevel = false;

    public enum CaptureAndRenderMode {
        RawData_NV21, RawData_RGBA, RawData_I420, EncodedRawData, Texture;

        public static CaptureAndRenderMode getCaptureAndRenderMode(String id) {
            switch (id) {
                case "RawData+NV21":
                    return RawData_NV21;
                case "RawData+RGBA":
                    return RawData_RGBA;
                case "RawData+I420":
                    return RawData_I420;
                case "EncodedRawData":
                    return EncodedRawData;
                case "Texture":
                    return Texture;
            }
            return null;
        }
    }

    @Override
    protected View createView() {
        binding = AcLiveRoomBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    protected void initData() {
        if (!NetworkUtil.isAvailable(this)) {
            ToastUtils.showShortToast("当前暂无网络");
        }
        getSpConfig();
        Intent intent = getIntent();
        pushStreamId = userId;
        userRole = (ChuangUserRole) intent.getSerializableExtra("enum");
        mLiveEngine = ChuangLiveEngine.initEngine((Application) getApplicationContext(), appId, appKey, new EventHandler());
        ((VCloudApplication) getApplicationContext()).registerActivityLifecycleCallbacks(this);
        com.chuangcache.rtc.livevideo.common.Logging.setLogLevel(0);
        com.chuangcache.rtc.livevideo.common.Logging.setPrintLogLevel(0);
    }


    private void logoutRoom() {
        playStreamList.clear();
        surfaceViewMap.clear();
        mLiveEngine.stopMixStream();
        mLiveEngine.stopPublishStream();
        mLiveEngine.logoutRoom();
        ChuangLiveEngine.uninitEngine();
        finish();
    }

    @Override
    protected void onResume() {
        super.onResume();
        binding.getRoot().post(() -> {
            if (DisplayUtil.isNavigationBarShow(LiveRoomActivity.this)) {
                DisplayUtil.setBottomNavbarTransparent(LiveRoomActivity.this);
                ConstraintSet set = new ConstraintSet();
                set.clone(binding.container);
                set.setMargin(binding.roomTitle.getRoot().getId(), ConstraintSet.TOP, DisplayUtil.getStatusBarHeight(LiveRoomActivity.this));
                set.applyTo(binding.container);
                RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) binding.roomToolbarBar.getRoot().getLayoutParams();
                layoutParams.bottomMargin = DisplayUtil.getNavigationBarHeight(LiveRoomActivity.this) + DisplayUtil.dp2pxInt(10);
                binding.roomToolbarBar.getRoot().setLayoutParams(layoutParams);
            }
        });
    }

    @Override
    protected void initView() {
        mainView = binding.localView;
        binding.roomToolbarBar.userBtn.setOnClickListener(this);
        binding.roomTitle.settingsBtn.setOnClickListener(this);
        binding.roomToolbarBar.micBtn.setOnClickListener(this);
        binding.roomToolbarBar.videoBtn.setOnClickListener(this);
        binding.roomToolbarBar.switchCameraBtn.setOnClickListener(this);
        binding.roomTitle.backBtn.setOnClickListener(this);
        binding.roomToolbarBar.hangUpBtn.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (!isChecked) {
                mLiveEngine.stopPublishStream();
                mLiveEngine.stopPreview();
            } else {
                mLiveEngine.startPreview();
                startPublishStream();
            }
        });
        Logging.setCallback(this);
        binding.roomTitle.userRoleTv.setText("身份：" + getUserRoleTxt());
        logcatTv = binding.logcatTv;
        logcatTv.setMovementMethod(ScrollingMovementMethod.getInstance());
        logcatTv.setGravity(Gravity.BOTTOM);
        mainView.setLargeScreen(true);
        mainView.setQualityVisibility(enableQuality);
        binding.roomTitle.roomIdTv.setText(roomId);
        mainView.setLiveEngine(mLiveEngine);

        int i = mLiveEngine.loginRoom(roomId, userId, userRole);
        Logging.d(TAG, "登录返回：" + i);
        if (enableOnlyAudio) {
            binding.roomToolbarBar.videoBtn.setActivated(true);
            binding.roomToolbarBar.videoBtn.setClickable(false);
            binding.roomToolbarBar.switchCameraBtn.setActivated(true);
            binding.roomToolbarBar.switchCameraBtn.setClickable(false);
        }
    }

    private void enableSoundLevel(boolean isChecked) {
        if (isChecked) {
            mLiveEngine.setSoundLevelMonitorInterval(2000);
            mLiveEngine.startSoundLevelMonitor();
        } else {
            mLiveEngine.stopSoundLevelMonitor();
        }
    }

    private void enableNetworkSpeed(boolean enable) {
        if (enable) {
            ChuangNetworkSpeedTestConfig speedTestConfig = new ChuangNetworkSpeedTestConfig();
            speedTestConfig.exceptedDownLinkBitrateKbps = 2000;
            speedTestConfig.expectedUpLinkBitrateKbps = 2000;
            speedTestConfig.testUpLink = true;
            speedTestConfig.testDownLink = true;
            mLiveEngine.startNetworkSpeedTest(speedTestConfig);
        } else {
            mLiveEngine.stopNetworkSpeedTest();
        }
    }

    private void getSpConfig() {
        mVideoBitrate = PreferenceUtils.getInt(this, PsKeyContants.VIDEO_BITRATE, 1200);
        mVideoFps = PreferenceUtils.getInt(this, PsKeyContants.VIDEO_FPS, 15);
        rtmpAddress = PreferenceUtils.getString(this, PsKeyContants.RTMP_ADDRESS, "");
        mMixAddress = PreferenceUtils.getString(mContext, PsKeyContants.MIX_ADDRESS, "");
        mMixBitrate = PreferenceUtils.getInt(mContext, PsKeyContants.MIX_BITRATE, 1000);
        enableOnlyAudio = PreferenceUtils.getBoolean(this, PsKeyContants.ONLY_AUDIO, false);
        enableQuality = PreferenceUtils.getBoolean(this, PsKeyContants.SHOW_DATA_QUALITY_STATUS, false);
        enablePublishRtmp = PreferenceUtils.getBoolean(mContext, PsKeyContants.PUBLISH_RTMP_ENABLE, false);
        roomId = PreferenceUtils.getString(this, PsKeyContants.ROOMID, "");
        userId = PreferenceUtils.getString(this, PsKeyContants.USERID, "");
        mMixCanvasWidth = PreferenceUtils.getInt(mContext, PsKeyContants.MIX_CANVAS_WIDTH, 800);
        mMixCanvasHeight = PreferenceUtils.getInt(mContext, PsKeyContants.MIX_CANVAS_HEIGHT, 600);
        enableMixVideo = PreferenceUtils.getBoolean(mContext, PsKeyContants.MIX_VIDEO_ENABLE, false);

        enableRtcMix = PreferenceUtils.getBoolean(mContext, PsKeyContants.MIX_RTC_VIDEO_ENABLE, false);
    }

    private String getUserRoleTxt() {
        switch (userRole) {
            case AUDIENCE:
                binding.roomToolbarBar.getRoot().setVisibility(View.INVISIBLE);
                binding.rlPerch2.setVisibility(View.VISIBLE);
                return "观众";
            case ANCHOR:
                initLocalView();
                initVideoConfig();
                return "主播";
            case INTERACTION:
                initVideoConfig();
                initMixVideoConfig();
                initLocalView();
                return "互动";
        }
        return "";
    }

    private void mixAudioSwitch(boolean enableMixAudio) {
        mLiveEngine.enableAudioMixing(enableMixAudio);
        if (enableMixAudio) {
            mLiveEngine.setAudioMixingHandler(new AudioMixingHandler(this));
        } else {
            mLiveEngine.setAudioMixingHandler(null);
        }
    }

    private void initLocalView() {
        //mLiveEngine.enableLandscape(true);
        setPreviewConfig(ChuangVideoMirrorMode.MIRROR_AUTO);
        mLiveEngine.startPreview();
        mainView.setPreview(true);
        mainView.setOnlyAudio(enableOnlyAudio);
    }

    private void setPreviewConfig(ChuangVideoMirrorMode chuangVideoMirrorMode) {
        localCanvas = new ChuangVideoCanvas();
        localCanvas.view = mainView.getSurfaceView();
        localCanvas.videoMirrorMode = chuangVideoMirrorMode;
        localCanvas.videoRenderMode = ChuangVideoRenderMode.ASPECT_FILL;
        mLiveEngine.setPreviewCanvas(localCanvas);
    }

    private void initVideoConfig() {
        ChuangVideoConfig videoConfig = new ChuangVideoConfig();
        videoConfig.encodeWidth = PreferenceUtils.getInt(this, PsKeyContants.VIDEO_WIDTH, 540);
        videoConfig.encodeHeight = PreferenceUtils.getInt(this, PsKeyContants.VIDEO_HEIGHT, 960);
        videoConfig.fps = mVideoFps;
        videoConfig.bitrateKbps = mVideoBitrate;
        videoConfig.videoRenderMode = ChuangVideoRenderMode.ASPECT_FILL;
        mLiveEngine.setVideoConfig(videoConfig);
    }

    private void startPublishStream() {
        ChuangStreamConfig chuangStreamConfig = new ChuangStreamConfig();
        chuangStreamConfig.streamId = pushStreamId;
        chuangStreamConfig.streamMode = enableOnlyAudio ? ChuangStreamMode.ONLY_AUDIO : ChuangStreamMode.NOMAL;
        if (enablePublishRtmp) {
            chuangStreamConfig.rtmpAddress = rtmpAddress;
        }
        int i = mLiveEngine.startPublishStream(chuangStreamConfig);
        surfaceViewMap.put(pushStreamId, mainView);
        Logging.d(TAG, "startPublishStream返回： " + i);
    }

    //开始混流
    private void mixStreamsSwitch() {
        if (enableMixVideo) {
            getStreamMixConfig();
            int mixCode = mLiveEngine.startMixStream(mixConfig, new IChuangMixStreamCallback() {
                @Override
                public void mixStreamCallback(int i) {
                    Logging.d("startMix", "mixStreamCallback: ：" + i);
                }
            });
            Logging.d(TAG, "startMixStream返回: " + mixCode);
        } else {
            mLiveEngine.stopMixStream();
        }
    }

    private void getStreamMixConfig() {
        List<ChuangMixStreamInfo> streamMixConfigItems = setDstConfig(mixStreamInfoList, mMixCanvasWidth, mMixCanvasHeight);
        mixConfig.mixStreams = mixStreamInfoList.toArray(new ChuangMixStreamInfo[streamMixConfigItems.size()]);
    }

    private void initMixVideoConfig() {
        mixConfig = new ChuangMixStreamConfig();
        mixConfig.videoBitrateKbps = mMixBitrate;
        mixConfig.width = mMixCanvasWidth;
        mixConfig.height = mMixCanvasHeight;
        mixConfig.noticeStream = enableRtcMix;
        mixConfig.target = mMixAddress;
        ChuangMixStreamWatermark chuangMixStreamWatermark = new ChuangMixStreamWatermark();
        chuangMixStreamWatermark.image ="preset-id://chuang_icon";
        chuangMixStreamWatermark.left = 0;
        chuangMixStreamWatermark.top = 0;
        chuangMixStreamWatermark.right = 162;
        chuangMixStreamWatermark.bottom = 43;
        mixConfig.mixStreamWatermark = chuangMixStreamWatermark;//162*43   800 600
        mixConfig.backgroundImage = "preset-id://chuang_01";
        //混自己的推流
        ChuangMixStreamInfo publishStreamMixInfo = new ChuangMixStreamInfo();
        publishStreamMixInfo.streamId = pushStreamId;
        publishStreamMixInfo.zlevel = 0;
        publishStreamMixInfo.width = PreferenceUtils.getInt(this, PsKeyContants.VIDEO_WIDTH, 540);
        publishStreamMixInfo.height = PreferenceUtils.getInt(this, PsKeyContants.VIDEO_HEIGHT, 960);
        publishStreamMixInfo.renderMode = ChuangVideoRenderMode.ASPECT_FIT;
        publishStreamMixInfo.rotation = ChuangStreamRotation.ROTATION_0;
        mixStreamInfoList.add(0, publishStreamMixInfo);
    }

    private List<ChuangMixStreamInfo> setDstConfig(List<ChuangMixStreamInfo> mixStreamInfoList, int mCanvasWidth, int mCanvasHeight) {
        Log.e(TAG, "setDstConfig: 混流数：" + mixStreamInfoList.size());
        if (mixStreamInfoList.size() == 0) return null;
        mWidth = mCanvasWidth / 3;
        mHeight = mCanvasHeight / 3;
        ChuangMixStreamInfo mainMixStream = mixStreamInfoList.get(0);
        mainMixStream.dstRect = new Rect(mWidth * 2, 0, mWidth * 2 + mWidth, mHeight);
        mainMixStream.zlevel = 0;
        int j = 0;
        for (int i = 1; i < mixStreamInfoList.size(); i++) {
            ChuangMixStreamInfo otherStream = mixStreamInfoList.get(i);
            int offsetVertical = mCanvasHeight / mHeight - (j / 3) - 1;
            int top = offsetVertical * mHeight;
            int left = j % (mCanvasHeight / mHeight) * mWidth;
            int right = left + mWidth;
            int bottom = top + mHeight;
            j++;
            otherStream.dstRect = new Rect(left, top, right, bottom);
            otherStream.zlevel = i;
            Logging.d(TAG, "setDtsConfig: " + left + " " + right + " " + top + " " + bottom + "  " + mixStreamInfoList.get(i).streamId
                    + "  宽：" + mixStreamInfoList.get(i).width + " 高：" + mixStreamInfoList.get(i).height + " " + offsetVertical + "  " + mCanvasWidth + " " + mCanvasHeight);
        }
        return mixStreamInfoList;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.mic_btn:
                muteLocalAudio();
                break;
            case R.id.video_btn:
                muteLocalVideo();
                break;
            case R.id.switch_camera_btn:
                switchCamera();
                break;
            case R.id.back_btn:
                logoutRoom();
                break;
            case R.id.settings_btn:
                getPopupWindow();
                break;
            case R.id.user_btn:
                break;

        }
    }

    //切换摄像头
    private void switchCamera() {
        isFont = !isFont;
        mLiveEngine.switchCamera(isFont ? ChuangCameraType.CAMERA_FRONT : ChuangCameraType.CAMERA_BACK);
    }

    //静音
    private void muteLocalAudio() {
        muteLocalAudio = !muteLocalAudio;
        mLiveEngine.muteLocalAudio(pushStreamId, muteLocalAudio);
        binding.roomToolbarBar.micBtn.setActivated(muteLocalAudio);
        ToastUtils.showToast(muteLocalAudio ? "静音" : "解除静音");
    }

    private void muteLocalVideo() {
        muteLocalVideo = !muteLocalVideo;
        mLiveEngine.muteLocalVideo(pushStreamId, muteLocalVideo);
        binding.roomToolbarBar.videoBtn.setActivated(muteLocalVideo);
        if (muteLocalVideo) {
            mLiveEngine.stopPreview();
        } else {
            mLiveEngine.startPreview();
        }
        mainView.muteLocalVideo(muteLocalVideo);
        setCameraNoClick();
    }

    private void setCameraNoClick() {
        if (muteLocalVideo) {
            binding.roomToolbarBar.switchCameraBtn.setActivated(true);
            binding.roomToolbarBar.switchCameraBtn.setClickable(false);
        } else {
            binding.roomToolbarBar.switchCameraBtn.setActivated(false);
            binding.roomToolbarBar.switchCameraBtn.setClickable(true);
        }
    }

    private void getPopupWindow() {
        if (settingsDialog == null) {
            settingsDialog = new SettingsDialog();
        }
        settingsDialog.fillValue(mainView.getFillMode(), mixAudioSwitch, isFont);
        settingsDialog.updatePublishStreamStatus(chuangPublishState);
        settingsDialog.setOnDismissCallback(new SettingsDialog.OnSettingsCallback() {
            @Override
            public void dissmiss(boolean enableQuality, boolean enableVideoMirror, boolean enableNetSpeed, boolean enableSoundLevel, boolean enableLog, boolean mixAudioSwitch, ChuangVideoRenderMode chuangVideoRenderMode) {
                if(LiveRoomActivity.this.enableQuality != enableQuality) {
                    LiveRoomActivity.this.enableQuality = enableQuality;
                    PreferenceUtils.putBoolean(mContext, PsKeyContants.SHOW_DATA_QUALITY_STATUS, enableQuality);
                    for (PlayStreamView playStreamView : surfaceViewMap.values()) {
                        playStreamView.setQualityVisibility(enableQuality);
                    }
                }
                enableNetworkSpeed(enableNetSpeed);
                enableSoundLevel(enableSoundLevel);
                binding.flLogcat.setVisibility(enableLog ? View.VISIBLE : View.GONE);
                if (LiveRoomActivity.this.enableNetSpeed != enableNetSpeed) {
                    LiveRoomActivity.this.enableNetSpeed = enableNetSpeed;
                    for (PlayStreamView playStreamViews : surfaceViewMap.values()) {
                        playStreamViews.showOrHideNetWorkSpeed(enableNetSpeed ? View.VISIBLE : View.GONE);
                    }
                }
                if (LiveRoomActivity.this.enableSoundLevel != enableSoundLevel) {
                    LiveRoomActivity.this.enableSoundLevel = enableSoundLevel;
                    for (PlayStreamView playStreamViews : surfaceViewMap.values()) {
                        playStreamViews.showOrHindSoundLevel(enableSoundLevel ? View.VISIBLE : View.GONE);
                    }
                }

                if (userRole != AUDIENCE) {
                    if (enableVideoMirror) {
                        setPreviewConfig(ChuangVideoMirrorMode.MIRROR_ENABLE);
                    } else {
                        setPreviewConfig(ChuangVideoMirrorMode.MIRROR_DISABLE);
                    }
                    mainView.setFillMode(chuangVideoRenderMode);
                    LiveRoomActivity.this.mixAudioSwitch = mixAudioSwitch;
                    mixAudioSwitch(mixAudioSwitch);
                    if (enableMixVideo != PreferenceUtils.getBoolean(mContext, PsKeyContants.MIX_VIDEO_ENABLE, false)) {
                        enableMixVideo = PreferenceUtils.getBoolean(mContext, PsKeyContants.MIX_VIDEO_ENABLE, false);
                        mixStreamsSwitch();
                    }
                }
            }

            @Override
            public void sendCustomMsg(String msg) {
                mLiveEngine.sendStreamAttachedMessage(pushStreamId, msg);
                ToastUtils.showShortToast("已发送");
            }

            @Override
            public void takePic(final ImageView img) {
                mLiveEngine.takePublishStreamSnapshot((s, i, bitmap) -> runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        img.setImageBitmap(bitmap);
                    }
                }));
            }
        });
        settingsDialog.setResolutionCallback(() -> {
            initVideoConfig();
        });
        settingsDialog.show(getSupportFragmentManager(), "settingsPop");
    }

    private void addInRoomUserInfo(List<ChuangStreamInfo> list) {
        runOnUiThread(() -> {
            for (int i = 0; i < list.   size(); i++) {
                playStreamList.add(list.get(i).streamId);
                ChuangMixStreamInfo mixInfo = new ChuangMixStreamInfo();
                if (list.get(i).streamType == ChuangStreamType.RTC) {
                    mixInfo.streamId = list.get(i).streamId;
                    mixInfo.width = list.get(i).width;
                    mixInfo.height = list.get(i).height;
                    mixInfo.renderMode = ChuangVideoRenderMode.ASPECT_FIT;
                    mixStreamInfoList.add(mixInfo);
                }
                Logging.i(TAG, "run: addStream：" + list.get(i).streamId + "  addStreamSize " + list.size() + "   " + playStreamList.size());
                if (userRole == ChuangUserRole.AUDIENCE && playStreamList.size() == 1) {
                    View childAt = binding.localViewContainer.getChildAt(0);
                    if (childAt instanceof PlayStreamView) {
                        PlayStreamView playStreamView = (PlayStreamView) childAt;
                        if (playStreamView != mainView) {
                            binding.localViewContainer.removeView(playStreamView);
                            mainView = new PlayStreamView(mContext);
                            RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
                            layoutParams.setMargins(0, 0, 0, 0);
                            mainView.setLayoutParams(layoutParams);
                            binding.localViewContainer.addView(mainView);
                        }
                    }
                    ChuangVideoCanvas mainCanvas = new ChuangVideoCanvas();
                    mainCanvas.view = mainView.getSurfaceView();
                    mainCanvas.videoRenderMode = ChuangVideoRenderMode.ASPECT_FILL;
                    mLiveEngine.startPlayStream(list.get(0).streamId, mainCanvas);
                    surfaceViewMap.put(list.get(0).streamId, mainView);
                    mainView.setStreamId(list.get(0).streamId);
                    mainView.setLiveEngine(mLiveEngine);
                    mainView.setLargeScreen(true);
                    mainView.setPreview(false);
                    if (list.get(i).streamMode == ChuangStreamMode.ONLY_AUDIO) {
                        mainView.setOnlyAudio(true);
                    }
                } else {
                    PlayStreamView playStreamView = new PlayStreamView(mContext);
                    playStreamView.showOrHindSoundLevel(enableSoundLevel ? View.VISIBLE : View.GONE);
                    playStreamView.showOrHideNetWorkSpeed(enableNetSpeed ? View.VISIBLE : View.GONE);
                    playStreamView.setLiveEngine(mLiveEngine);
                    LinearLayout.LayoutParams pvlayoutPatams = new LinearLayout.LayoutParams(DisplayUtil.dip2px(mContext, 80), DisplayUtil.dip2px(mContext, 170));
                    pvlayoutPatams.leftMargin = DisplayUtil.dip2px(mContext, 8);
                    playStreamView.setStreamId(list.get(i).streamId);
                    playStreamView.setLayoutParams(pvlayoutPatams);
                    playStreamView.getSurfaceView().setZOrderOnTop(true);
                    playStreamView.getSurfaceView().setZOrderMediaOverlay(true);
                    playStreamView.setQualityVisibility(enableQuality);
                    playStreamView.setLargeScreen(false);
                    playStreamView.setPreview(false);
                    binding.llUserContent.addView(playStreamView);
                    surfaceViewMap.put(list.get(i).streamId, playStreamView);
                    ChuangVideoCanvas playCanvas = new ChuangVideoCanvas();
                    playCanvas.view = playStreamView.getSurfaceView();
                    playCanvas.videoRenderMode = ChuangVideoRenderMode.ASPECT_FILL;
                    mLiveEngine.startPlayStream(list.get(i).streamId, playCanvas);
                    if (list.get(i).streamMode == ChuangStreamMode.ONLY_AUDIO) {
                        playStreamView.setOnlyAudio(true);
                    }
                }
            }

            //addPlayStreamView(list);
            refreshLayout();
            if (userRole == INTERACTION) {
                mixStreamsSwitch();
            }
        });
    }

    private void refreshLayout() {
        binding.roomToolbarBar.userNumTv.setText(String.valueOf(playStreamList.size()));
        binding.rlPerch2.setVisibility(playStreamList.size() == 0 && userRole == ChuangUserRole.AUDIENCE ? View.VISIBLE : View.GONE);
        for (int i = 0; i < binding.llUserContent.getChildCount(); i++) {
            binding.llUserContent.getChildAt(i).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    exChangeView(v);
                }
            });
        }
    }

    private void exChangeView(View v) {
        if (v instanceof PlayStreamView) {
            PlayStreamView playStreamView = (PlayStreamView) v;
            if (playStreamView.isLargeScreen()) return;
            for (int i = 0; i < binding.llUserContent.getChildCount(); i++) {
                if (binding.llUserContent.getChildAt(i) == v) {
                    binding.llUserContent.removeView(v);
                    ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
                    playStreamView.setLargeScreen(true);
                    playStreamView.getSurfaceView().setZOrderOnTop(false);
                    playStreamView.getSurfaceView().setZOrderMediaOverlay(false);
                    binding.localViewContainer.addView(playStreamView, layoutParams);

                    View childAt = binding.localViewContainer.getChildAt(0);
                    if (childAt instanceof PlayStreamView) {
                        PlayStreamView streamView = (PlayStreamView) childAt;
                        binding.localViewContainer.removeView(childAt);
                        LinearLayout.LayoutParams layoutParams1 = new LinearLayout.LayoutParams(DisplayUtil.dip2px(mContext, 80), DisplayUtil.dip2px(mContext, 170));
                        layoutParams1.leftMargin = DisplayUtil.dip2px(mContext, 10);
                        streamView.setLargeScreen(false);
                        binding.llUserContent.addView(streamView, i, layoutParams1);
                        streamView.getSurfaceView().setZOrderOnTop(true);
                        streamView.getSurfaceView().setZOrderMediaOverlay(true);
                        break;
                    }
                }
            }
            refreshLayout();
        }
    }

    private void leaveRoomInfo(List<ChuangStreamInfo> list) {
        for (int i = 0; i < list.size(); i++) {
            String streamId = list.get(i).streamId;
            mLiveEngine.stopPlayStream(streamId);
            Logging.e(TAG, "run:leaveStream： " + streamId);
        }
    }

    private void removeViewRefresh(final PlayStreamView surfaceView) {
        runOnUiThread(() -> {
            if (surfaceView != null) {
                if (surfaceView.isLargeScreen()) {
                    View childAt = binding.llUserContent.getChildAt(0);
                    if (childAt instanceof PlayStreamView) {
                        binding.localViewContainer.removeView(surfaceView);
                        PlayStreamView playStreamView = (PlayStreamView) childAt;
                        binding.llUserContent.removeView(playStreamView);
                        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
                        playStreamView.setLayoutParams(layoutParams);
                        playStreamView.setLargeScreen(true);
                        playStreamView.getSurfaceView().setZOrderOnTop(false);
                        playStreamView.getSurfaceView().setZOrderMediaOverlay(false);
                        binding.localViewContainer.addView(playStreamView);
                    }
                } else {
                    binding.llUserContent.removeView(surfaceView);
                }
                Logging.d(TAG, "removeView : " + surfaceView.getStreamId());
            }
            refreshLayout();
        });
    }

    @Override
    public void onLogCallback(final String msg) {
        Log.d(TAG, "onLogCallback: " + msg);
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                String strContent = msg + "\r\n\n";
                log.append(strContent);
                logcatTv.setText(log.toString());
            }
        });
    }

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {

    }

    @Override
    public void onActivityResumed(@NonNull Activity activity) {
    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {
    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {

    }


    class EventHandler extends IChuangEventHandler {
        @Override
        public void onRoomStateUpdate(String s, ChuangRoomState chuangRoomState, int i) {
            if (chuangRoomState == ChuangRoomState.CONNECTED && i == 0) {
                ToastUtils.showToast("登录成功");
                Logging.d(TAG, "login success" + " userRole： " + userRole);
                Log.e(TAG, "onRoomStateUpdate: " + s + "  " + i);
                if (userRole == ChuangUserRole.AUDIENCE) return;
                startPublishStream();
            }
        }

        @Override
        public void onPublishStreamStateUpdate(String streamId, ChuangPublishState chuangPublishState, int i) {
            LiveRoomActivity.this.chuangPublishState = chuangPublishState;
            if (null != settingsDialog) {
                runOnUiThread(() -> settingsDialog.updatePublishStreamStatus(chuangPublishState));
            }
            Logging.d(TAG, "onPublishStreamStateUpdate: " + "  " + chuangPublishState + "   " + i + "  流id：" + streamId);
            if (chuangPublishState == ChuangPublishState.PUBLISH_CONNECTING && i == ChuangLiveVideoError.CHUANG_RTMP_TRANSFORM_CONNECT_FAILED) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        ToastUtils.showToast("转推RTMP连接服务器失败");
                    }
                });
            }
            if (chuangPublishState == ChuangPublishState.PUBLISH_CONNECTED && i == ChuangLiveVideoError.CHUANG_SUCCESS) {
                ToastUtils.showToast("推流成功");
                Logging.d(TAG, "startpublish success");
                mainView.setStreamId(pushStreamId);
                if (!playStreamList.contains(streamId)) {
                    playStreamList.add(streamId);
                    runOnUiThread(() -> refreshLayout());
                }
                if (userRole == INTERACTION) {
                    mixStreamsSwitch();
                }
            }
            if (chuangPublishState == ChuangPublishState.PUBLISH_CONNECTING && i == ChuangLiveVideoError.CHUANG_MIC_INIT_FAILED) {
                Logging.d(TAG, "麦克风初始化失败,重新推流");
                startPublishStream();
            }
            if (chuangPublishState == ChuangPublishState.PUIBLISH_DISCONNECTED) {
                playStreamList.remove(streamId);
                runOnUiThread(LiveRoomActivity.this::refreshLayout);
            }
        }

        @Override
        public void onRoomStreamUpdate(String roomId, ChuangStreamUpdateType chuangStreamUpdateType, List<ChuangStreamInfo> list) {
            if (chuangStreamUpdateType == ChuangStreamUpdateType.ADD) {
                addInRoomUserInfo(list);
            }
            if (chuangStreamUpdateType == ChuangStreamUpdateType.DELETE) {
                leaveRoomInfo(list);
            }
        }

        @Override
        public void onPlayStreamStateUpdate(String streamId, ChuangPlayState chuangPlayState, int code) {
            Logging.d(TAG, "onPlayStreamStateUpdate: " + streamId + "   " + chuangPlayState.value() + "  " + code);
            if (chuangPlayState == ChuangPlayState.PLAY_DISCONNECTED && code == ChuangLiveVideoError.CHUANG_SUCCESS) {
                Logging.d(TAG, "stopStreamSuccess: " + streamId);
                PlayStreamView stopSurface = surfaceViewMap.get(streamId);
                removeViewRefresh(stopSurface);
                playStreamList.remove(streamId);
                surfaceViewMap.remove(streamId);
                if (userRole == INTERACTION) {
                    for (int i = 0; i < mixStreamInfoList.size(); i++) {
                        if (mixStreamInfoList.get(i).streamId.equals(streamId)) {
                            mixStreamInfoList.remove(i);
                            break;
                        }
                    }
                    mixStreamsSwitch();
                }
            }
            if (chuangPlayState == ChuangPlayState.PLAY_CONNECTED && code == ChuangLiveVideoError.CHUANG_SUCCESS) {
                Logging.d(TAG, "播流成功：" + streamId);
            }
        }


        @Override
        public void onPublishStreamQualityUpdate(final String streamId,
                                                 final ChuangPublishStreamQuality chuangPublishStreamQuality) {
            PlayStreamView playStreamView = surfaceViewMap.get(streamId);
            if (playStreamView != null) {
                playStreamView.updateStreamQuality(chuangPublishStreamQuality);
            }

        }

        @Override
        public void onPlayStreamQualityUpdate(String streamId, ChuangPlayStreamQuality chuangPlayStreamQuality) {
            PlayStreamView playStreamView = surfaceViewMap.get(streamId);
            if (playStreamView != null) {
                playStreamView.updateStreamQuality(chuangPlayStreamQuality.publishStreamQuality);
            }
        }

        @Override
        public void onPlayStreamStateChanged(String streamId, ChuangStreamState chuangStreamState) {
            Logging.d(TAG,"streamId "+streamId + " "+chuangStreamState);
            PlayStreamView playStreamView = surfaceViewMap.get(streamId);
            if (playStreamView != null) {
                playStreamView.updateStreamState(chuangStreamState);
            }
        }

        @Override
        public void onNetworkSpeedTestQualityUpdate(final ChuangNetworkSpeedQuality chuangNetworkSpeedQuality, final ChuangNetworkSpeedTestType chuangNetworkSpeedTestType) {
            runOnUiThread(() -> {
                for (PlayStreamView playStreamView : surfaceViewMap.values()) {
                    if (null != playStreamView) {
                        playStreamView.updateNetworkSpeed(chuangNetworkSpeedQuality, chuangNetworkSpeedTestType);
                    }
                }
            });
//            Logging.d(TAG, "可用宽带：" + chuangNetworkSpeedQuality.availableBndWidthKbps + "kbps   网络测速类型: " + chuangNetworkSpeedTestType);
        }

        @Override
        public void onCaptureSoundLevelUpdate(ChuangSoundLevel chuangSoundLevel) {
            runOnUiThread(() -> {
                PlayStreamView playStreamView = surfaceViewMap.get(chuangSoundLevel.streamID);
                if (null != playStreamView) {
                    playStreamView.updateSoundLevel(chuangSoundLevel);
                }
            });
//            Logging.d(TAG, chuangSoundLevel.streamID + " 音量大小 " + chuangSoundLevel.soundLevel);
        }

        @Override
        public void onRemoteSoundLevelUpdate(ChuangSoundLevel[] chuangSoundLevels) {
            runOnUiThread(() -> {
                for (ChuangSoundLevel chuangSoundLevel : chuangSoundLevels) {
                    PlayStreamView playStreamView = surfaceViewMap.get(chuangSoundLevel.streamID);
                    if (null != playStreamView) {
                        playStreamView.updateSoundLevel(chuangSoundLevel);
                    }
//                    Logging.d(TAG, chuangSoundLevels[i].streamID + " 音量大小 " + chuangSoundLevels[i].soundLevel);
                }
            });
        }

        @Override
        public void onReceiveStreamAttchedMessage(String streamId, String msg) {
            Logging.d(TAG, streamId + "：" + msg);
        }

        @Override
        public void onPlayStreamVideoSizeChanged(String streamId, int width, int height) {
            super.onPlayStreamVideoSizeChanged(streamId, width, height);
            Logging.d("推流分辨率：", streamId + "：width " + width + " height " + height);
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            logoutRoom();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }
}