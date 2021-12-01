package com.aocyun.chuangrtcdemo.dialog;

import android.content.DialogInterface;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.databinding.DialogUserActionEventsBinding;
import com.aocyun.chuangrtcdemo.utils.DisplayUtil;
import com.chuangcache.rtc.ChuangLiveEngine;
import com.chuangcache.rtc.enums.ChuangVideoRenderMode;

/**
 * @Author SongTiChao
 * @CreateDate 2021/7/20 13:09
 * Description:
 */
public class UserActionEventsDialog extends BaseBottomDialog {
    public DialogUserActionEventsBinding binding;
    private OnDismissListener onDismissListener;
    private ChuangVideoRenderMode chuangVideoRenderMode;
    private boolean localMuteAudio;
    private boolean localMuteVideo;
    private boolean remoteMuteVideo;
    private boolean remoteMuteAudio;
    private ChuangLiveEngine mLiveEngine;
    private String streamId;
    private SwitchListener onMicrophoneSwitchListener;
    private SwitchListener onCameraSwitchListener;

    public UserActionEventsDialog(ChuangVideoRenderMode chuangVideoRenderMode, boolean localMuteAudio, boolean localMuteVideo, ChuangLiveEngine mLiveEngine) {
        this.chuangVideoRenderMode = chuangVideoRenderMode;
        this.localMuteAudio = localMuteAudio;
        this.localMuteVideo = localMuteVideo;
        this.mLiveEngine = mLiveEngine;
    }

    public void setRemoteMuteVideo(boolean remoteMuteVideo) {
        this.remoteMuteVideo = remoteMuteVideo;
    }

    public void setRemoteMuteAudio(boolean remoteMuteAudio) {
        this.remoteMuteAudio = remoteMuteAudio;
    }

    public void setStreamId(String streamId) {
        this.streamId = streamId;
    }

    @Override
    protected View createView() {
        binding = DialogUserActionEventsBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    protected void initView() {
        binding.microphoneSwitch.setEnabled(!remoteMuteAudio);
        binding.cameraSwitch.setEnabled(!remoteMuteVideo);
        binding.microphoneSwitch.setChecked(!remoteMuteAudio);
        binding.cameraSwitch.setChecked(!remoteMuteVideo);
        switch (chuangVideoRenderMode) {
            case ASPECT_FILL:
                binding.equalScaleCroppingRadioButton.setChecked(true);
                break;
            case ASPECT_FIT:
                binding.equalScaleZoomRadioButton.setChecked(true);
                break;
            case SCALE_TO_FILL:
                binding.stretchRadioButton.setChecked(true);
                break;
        }
        if (!remoteMuteVideo) {
            binding.cameraSwitch.setChecked(!localMuteVideo);
        }
        if (!remoteMuteAudio) {
            binding.microphoneSwitch.setChecked(!localMuteAudio);
        }
        binding.radioGroup.setOnCheckedChangeListener((group, checkedId) -> {
            if (checkedId == R.id.equalScaleCroppingRadioButton) {
                chuangVideoRenderMode = ChuangVideoRenderMode.ASPECT_FILL;
                dismiss();
            }
            if (checkedId == R.id.equalScaleZoomRadioButton) {
                chuangVideoRenderMode = ChuangVideoRenderMode.ASPECT_FIT;
                dismiss();
            }
            if (checkedId == R.id.stretchRadioButton) {
                chuangVideoRenderMode = ChuangVideoRenderMode.SCALE_TO_FILL;
                dismiss();
            }
        });
        binding.microphoneSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
            localMuteAudio = !isChecked;
        });
        //这个点击事件是用来监听是否是手动关闭的  不能放到setOnCheckedChangeListener方法中
        binding.microphoneSwitch.setOnClickListener(v -> onMicrophoneSwitchListener.listener());
        binding.cameraSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
            localMuteVideo = !isChecked;
        });
        //这个点击事件是用来监听是否是手动关闭的  不能放到setOnCheckedChangeListener方法中
        binding.cameraSwitch.setOnClickListener(v -> onCameraSwitchListener.listener());
        binding.screenshotTextView.setOnClickListener(v -> {
            mLiveEngine.takePlayStreamSnapshot(streamId, (streamId, errorCode, bitmap) ->
                    getActivity().runOnUiThread(() -> {
                        binding.takePicImageView.setVisibility(View.VISIBLE);
                        binding.takePicImageView.setImageBitmap(bitmap);
                    }));
        });
    }

    @Override
    protected void initData() {

    }

    public void setOnDismissListener(OnDismissListener onDismissListener) {
        this.onDismissListener = onDismissListener;
    }

    public interface OnDismissListener {
        void dismiss(ChuangVideoRenderMode chuangVideoRenderMode, boolean microphoneSwitch, boolean cameraSwitch);
    }

    @Override
    public void onDismiss(@NonNull DialogInterface dialog) {
        super.onDismiss(dialog);
        boolean audioSwitch = false;
        if (localMuteAudio || remoteMuteAudio) {
            audioSwitch = true;
        }
        boolean videoSwitch = false;
        if (localMuteVideo || remoteMuteVideo) {
            videoSwitch = true;
        }
        onDismissListener.dismiss(chuangVideoRenderMode, audioSwitch, videoSwitch);
    }

    public void setOnMicrophoneSwitchListener(SwitchListener onMicrophoneSwitchListener) {
        this.onMicrophoneSwitchListener = onMicrophoneSwitchListener;
    }

    public void setOnCameraSwitchListener(SwitchListener onCameraSwitchListener) {
        this.onCameraSwitchListener = onCameraSwitchListener;
    }

    public interface SwitchListener {
        void listener();
    }

    @Override
    public void onResume() {
        super.onResume();
        if (getDialog() != null) {
            getDialog().getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
            DisplayUtil.hideNavigationBar(getDialog().getWindow().getDecorView());
            getDialog().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
        }
    }
}
