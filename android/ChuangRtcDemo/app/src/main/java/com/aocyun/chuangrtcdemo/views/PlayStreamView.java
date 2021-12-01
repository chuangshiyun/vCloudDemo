package com.aocyun.chuangrtcdemo.views;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.SurfaceView;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.databinding.PlaystreamViewLayoutBinding;
import com.aocyun.chuangrtcdemo.dialog.UserActionEventsDialog;
import com.aocyun.chuangrtcdemo.utils.DisplayUtil;
import com.chuangcache.rtc.ChuangLiveEngine;
import com.chuangcache.rtc.entity.ChuangNetworkSpeedQuality;
import com.chuangcache.rtc.entity.ChuangPublishStreamQuality;
import com.chuangcache.rtc.entity.ChuangSoundLevel;
import com.chuangcache.rtc.entity.ChuangVideoCanvas;
import com.chuangcache.rtc.enums.ChuangNetworkSpeedTestType;
import com.chuangcache.rtc.enums.ChuangStreamState;
import com.chuangcache.rtc.enums.ChuangVideoRenderMode;

import java.nio.ByteBuffer;
import java.text.DecimalFormat;

public class PlayStreamView extends FrameLayout implements View.OnClickListener {
    private Context mContext;
    private TextView fpsTv;
    private TextView lostTv;
    private TextView delayTv;
    private String streamId;
    private TextView streamNameRight;

    private boolean isLargeScreen = false;
    private ChuangLiveEngine mLiveEngine;
    private boolean muteRemoteAudio = false;
    private boolean muteRemoteVideo = false;
    private ChuangVideoCanvas videoCanvas = new ChuangVideoCanvas();
    private boolean remoteMuteVideo;
    private boolean remoteMuteAudio;
    private boolean isPreview;
    private final int UPDATE_QUALITY = 0;
    private final int UPDATE_BTN = 1;
    private final int UPDATE_STREAMID = 2;
    private PlaystreamViewLayoutBinding binding;
    private UserActionEventsDialog userActionEventsDialog;
    private int showOrHideNetWorkSpeed = View.GONE;

    public PlayStreamView(Context context) {
        super(context);
        this.mContext = context;
        initView();
    }

    public PlayStreamView(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.mContext = context;
        initView();
    }

    public PlayStreamView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.mContext = context;
        initView();
    }

    public void setStreamId(String streamId) {
        this.streamId = streamId;
        Message message = Message.obtain();
        message.arg1 = UPDATE_STREAMID;
        handler.sendMessage(message);
    }

    public void setLiveEngine(ChuangLiveEngine ccLiveEngine) {
        this.mLiveEngine = ccLiveEngine;
    }

    private void initView() {
        binding = PlaystreamViewLayoutBinding.inflate(LayoutInflater.from(mContext), this, true);
        fpsTv = binding.videoQuatity.videoSmallFpsTv;
        lostTv = binding.videoQuatity.smallNetworklostTv;
        delayTv = binding.videoQuatity.smallDelayTv;

        streamNameRight = binding.streamIdTv;
        binding.menuImageView.setOnClickListener(this);

    }

    public void setPreview(boolean isPreview) {
        this.isPreview = isPreview;
        binding.menuImageView.setVisibility(isPreview ? GONE : VISIBLE);
    }

    public boolean isPreview() {
        return isPreview;
    }

    Handler handler = new Handler() {
        @SuppressLint("HandlerLeak")
        @Override
        public void handleMessage(@NonNull Message msg) {
            super.handleMessage(msg);
            switch (msg.arg1) {
                case UPDATE_QUALITY:
                    ChuangPublishStreamQuality publishStreamQuality = (ChuangPublishStreamQuality) msg.obj;
                    binding.videoQuatity.smallBitrateTv.setText(String.valueOf(publishStreamQuality.videoBitrateKbps));
                    if (remoteMuteVideo == true) {
                        fpsTv.setText("0");
                    } else {
                        fpsTv.setText(String.valueOf(publishStreamQuality.videoFps));
                    }
                    binding.videoQuatity.audioSmallFpsTv.setText("0");
                    delayTv.setText(String.valueOf(publishStreamQuality.rtt));
                    lostTv.setText(doubleToString(publishStreamQuality.packetLostRate));
                    break;
                case UPDATE_BTN:
                    if (!muteRemoteVideo) {
                        binding.rlPerch.setVisibility(remoteMuteVideo ? VISIBLE : GONE);
                        if (null != userActionEventsDialog) {
                            userActionEventsDialog.binding.cameraSwitch.setChecked(!remoteMuteVideo);
                        }
                    }
                    if (null != userActionEventsDialog) {
                        userActionEventsDialog.binding.cameraSwitch.setEnabled(!remoteMuteVideo);
                    }
                    if (!muteRemoteAudio) {
                        if (null != userActionEventsDialog) {
                            userActionEventsDialog.binding.microphoneSwitch.setChecked(!remoteMuteAudio);
                        }
                    }
                    if (null != userActionEventsDialog) {
                        userActionEventsDialog.binding.microphoneSwitch.setEnabled(!remoteMuteAudio);
                    }
                    break;
                case UPDATE_STREAMID:
                    if (streamId.length() > 12) {
                        streamNameRight.setText(streamId.substring(0, 12) + "...");
                    } else {
                        streamNameRight.setText(streamId);
                    }
                    break;
            }

        }
    };

    public boolean isLargeScreen() {
        return isLargeScreen;
    }

    public SurfaceView getSurfaceView() {
        return binding.surfaceView;
    }

    public String getStreamId() {
        return streamId;
    }

    public void setLargeScreen(boolean isLargeScreen) {
        binding.videoQuatity.networkSpeedContainer.setVisibility(isLargeScreen ? showOrHideNetWorkSpeed : View.GONE);
        LayoutParams layoutParams = (LayoutParams) binding.rlRoot.getLayoutParams();
        if (!isLargeScreen) {
            layoutParams.width = DisplayUtil.dip2px(mContext, 80);
            layoutParams.height = DisplayUtil.dip2px(mContext, 120);
        } else {
            layoutParams.width = LayoutParams.MATCH_PARENT;
            layoutParams.height = LayoutParams.MATCH_PARENT;
        }
        binding.rlRoot.setLayoutParams(layoutParams);
        this.isLargeScreen = isLargeScreen;
    }

    public void updateStreamQuality(ChuangPublishStreamQuality publishStreamQuality) {
        Message message = Message.obtain();
        message.arg1 = UPDATE_QUALITY;
        message.obj = publishStreamQuality;
        handler.sendMessage(message);
    }

    public void updateStreamState(ChuangStreamState chuangStreamState) {
        if (ChuangStreamState.AUDIO_MUTE == chuangStreamState) {
            remoteMuteAudio = true;
        } else if (ChuangStreamState.AUDIO_UNMUTE == chuangStreamState) {
            remoteMuteAudio = false;
        }
        if (ChuangStreamState.VIDEO_MUTE == chuangStreamState) {
            remoteMuteVideo = true;
        } else if (ChuangStreamState.VIDEO_UNMUTE == chuangStreamState) {
            remoteMuteVideo = false;
        }
        Message message = Message.obtain();
        message.arg1 = UPDATE_BTN;
        handler.sendMessage(message);
    }

    public void setOnlyAudio(boolean isOnlyAudio) {
        binding.rlPerch.setVisibility(isOnlyAudio ? VISIBLE : GONE);
        remoteMuteVideo = isOnlyAudio;
    }

    public void setQualityVisibility(boolean enableQuality) {
        binding.videoQuatity.bitrateContainer.setVisibility(enableQuality ? VISIBLE : INVISIBLE);
        binding.videoQuatity.videoFpsContainer.setVisibility(enableQuality ? VISIBLE : INVISIBLE);
        binding.videoQuatity.audioFpsContainer.setVisibility(enableQuality ? VISIBLE : INVISIBLE);
        binding.videoQuatity.lostContainer.setVisibility(enableQuality ? VISIBLE : INVISIBLE);
        binding.videoQuatity.delayContainer.setVisibility(enableQuality ? VISIBLE : INVISIBLE);
    }

    public void muteLocalVideo(boolean muteLocalVideo) {
        binding.rlPerch.setVisibility(muteLocalVideo ? VISIBLE : GONE);
    }

    private String doubleToString(double num) {
        //使用0.00不足位补0，#.##仅保留有效位
        return new DecimalFormat("0.00").format(num);
    }

    public void setFillMode(ChuangVideoRenderMode chuangVideoRenderMode) {
        if (videoCanvas.videoRenderMode != chuangVideoRenderMode) {
            videoCanvas.videoRenderMode = chuangVideoRenderMode;
            if (isPreview) {
                mLiveEngine.setPreviewCanvas(videoCanvas);
            } else {
                mLiveEngine.startPlayStream(streamId, videoCanvas);
            }
        }
    }

    public ChuangVideoRenderMode getFillMode() {
        return videoCanvas.videoRenderMode;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.menuImageView:
                userActionEventsDialog = new UserActionEventsDialog(videoCanvas.videoRenderMode == null ? ChuangVideoRenderMode.ASPECT_FILL : videoCanvas.videoRenderMode, muteRemoteAudio, muteRemoteVideo, mLiveEngine);
                userActionEventsDialog.setOnDismissListener((chuangVideoRenderMode, localMuteAudio, localMuteVideo) -> {
                    setFillMode(chuangVideoRenderMode);
                    mLiveEngine.muteRemoteAudio(streamId, localMuteAudio);
                    mLiveEngine.muteRemoteVideo(streamId, localMuteVideo);
                    binding.rlPerch.setVisibility(localMuteVideo ? VISIBLE : GONE);
                });
                userActionEventsDialog.setOnCameraSwitchListener(() -> muteRemoteVideo = !muteRemoteVideo);
                userActionEventsDialog.setOnMicrophoneSwitchListener(() -> muteRemoteAudio = !muteRemoteAudio);
                userActionEventsDialog.setRemoteMuteAudio(remoteMuteAudio);
                userActionEventsDialog.setRemoteMuteVideo(remoteMuteVideo);
                userActionEventsDialog.setStreamId(streamId);
                userActionEventsDialog.show(((AppCompatActivity) mContext).getSupportFragmentManager(), "UserActionEventsDialog");
                break;
        }
    }

    public void updateNetworkSpeed(ChuangNetworkSpeedQuality chuangNetworkSpeedQuality, ChuangNetworkSpeedTestType chuangNetworkSpeedTestType) {
        binding.videoQuatity.networkSpeedTextView.setText(chuangNetworkSpeedQuality.availableBndWidthKbps + "");
    }

    public void showOrHideNetWorkSpeed(int visibility) {
        showOrHideNetWorkSpeed = visibility;
        if (isLargeScreen)
            binding.videoQuatity.networkSpeedContainer.setVisibility(showOrHideNetWorkSpeed);
    }

    public void updateSoundLevel(ChuangSoundLevel chuangSoundLevel) {
        binding.videoQuatity.volumeTextView.setText(chuangSoundLevel.soundLevel + "");
    }

    public void showOrHindSoundLevel(int visibility) {
        binding.videoQuatity.volumeContainer.setVisibility(visibility);
    }
}
