package com.aocyun.chuangrtcdemo.views;

import android.content.DialogInterface;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RadioGroup;

import androidx.annotation.NonNull;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;
import com.aocyun.chuangrtcdemo.databinding.DialogSettingsLayoutBinding;
import com.aocyun.chuangrtcdemo.dialog.BaseBottomDialog;
import com.aocyun.chuangrtcdemo.dialog.ResolutionDialogTextList;
import com.aocyun.chuangrtcdemo.utils.DisplayUtil;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;
import com.aocyun.chuangrtcdemo.utils.ToastUtils;
import com.chuangcache.rtc.enums.ChuangPublishState;
import com.chuangcache.rtc.enums.ChuangVideoRenderMode;

public class SettingsDialog extends BaseBottomDialog {
    private boolean enableQuality;
    private ChuangVideoRenderMode chuangVideoRenderMode = ChuangVideoRenderMode.ASPECT_FIT;
    private DialogSettingsLayoutBinding binding;
    private boolean mixAudioSwitch;
    private boolean mixVideoEnable;
    private boolean enableVideoMirror = true;
    private boolean enableNetSpeed;
    private boolean enableSoundLevel;
    private boolean enableLog;
    private ChuangPublishState chuangPublishState;
    private ResolutionDialogTextList resolutionDialog;
    private ResolutionCallback resolutionCallback;
    private boolean isFontCamera = true;

    public void fillValue(ChuangVideoRenderMode chuangVideoRenderMode, boolean mixAudioSwitch, boolean isFontCamera) {
        this.chuangVideoRenderMode = chuangVideoRenderMode;
        this.mixAudioSwitch = mixAudioSwitch;
        this.isFontCamera = isFontCamera;
    }

    public void setResolutionCallback(ResolutionCallback resolutionCallback) {
        this.resolutionCallback = resolutionCallback;
    }

    @Override
    protected View createView() {
        binding = DialogSettingsLayoutBinding.inflate(LayoutInflater.from(getContext()));
        return binding.getRoot();
    }

    @Override
    protected void initView() {
        DisplayMetrics metric = new DisplayMetrics();
        getActivity().getWindowManager().getDefaultDisplay().getMetrics(metric);
        int heightPixels = metric.heightPixels;
        ViewGroup.LayoutParams layoutParams = binding.container.getLayoutParams();
        layoutParams.height = Math.round(heightPixels * 0.8f);
        binding.container.setLayoutParams(layoutParams);
        updateLayout();
        if (!isFontCamera) {
            binding.rlMirror.setVisibility(View.GONE);
        }
    }

    @Override
    protected void initData() {
        enableQuality = PreferenceUtils.getBoolean(getContext(), PsKeyContants.SHOW_DATA_QUALITY_STATUS, false);
        mixVideoEnable = PreferenceUtils.getBoolean(getContext(), PsKeyContants.MIX_VIDEO_ENABLE, false);
        if (chuangPublishState == ChuangPublishState.PUBLISH_CONNECTED) {
            binding.rlTakePic.setVisibility(View.VISIBLE);
            binding.rlSendCustomMsg.setVisibility(View.VISIBLE);
        } else {
            binding.rlTakePic.setVisibility(View.GONE);
            binding.rlSendCustomMsg.setVisibility(View.GONE);
        }
    }

    private void updateLayout() {
        binding.videoQualitySwitch.setChecked(enableQuality);
        binding.videoMirrorSwitch.setChecked(enableVideoMirror);
        binding.videoSpeedSwitch.setChecked(enableNetSpeed);
        binding.videoSoundSwitch.setChecked(enableSoundLevel);
        binding.enableLogSwitch.setChecked(enableLog);
        binding.openMixAudioSwitch.setChecked(mixAudioSwitch);
        binding.openMixStreamSwitch.setChecked(mixVideoEnable);
        String mixAddressText = PreferenceUtils.getString(getContext(), PsKeyContants.MIX_ADDRESS, "");
        binding.mixStreamContainer.setVisibility(mixAddressText.isEmpty() ? View.GONE : View.VISIBLE);
        binding.videoQualitySwitch.setOnCheckedChangeListener((buttonView, isChecked) -> enableQuality = isChecked);
        binding.backButton.setOnClickListener(v -> {
            dismiss();
        });
        binding.takePicBtn.setOnClickListener(v -> onDismissCallback.takePic(binding.takePicImg));
        binding.sendMsgBtn.setOnClickListener(v -> {
            if (binding.customMsgEt.getText().toString().isEmpty()) {
                ToastUtils.showShortToast("请输入发送内容");
                return;
            }
            onDismissCallback.sendCustomMsg(binding.customMsgEt.getText().toString());
            binding.customMsgEt.setText("");
        });
        binding.videoMirrorSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> enableVideoMirror = isChecked);
        binding.videoSpeedSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> enableNetSpeed = isChecked);

        binding.videoSoundSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> enableSoundLevel = isChecked);

        binding.enableLogSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> enableLog = isChecked);
        if (null != chuangVideoRenderMode) {
            switch (chuangVideoRenderMode) {
                case ASPECT_FILL:
                    binding.flipNormalRadioButton.setChecked(true);
                    break;
                case ASPECT_FIT:
                    binding.flipFitRadioButton.setChecked(true);
                    break;
                case SCALE_TO_FILL:
                    binding.flipFillRadioButton.setChecked(true);
                    break;
            }
        }
        binding.fillModeRadioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                if (checkedId == R.id.flipNormalRadioButton) {
                    chuangVideoRenderMode = ChuangVideoRenderMode.ASPECT_FILL;
                }
                if (checkedId == R.id.flipFitRadioButton) {
                    chuangVideoRenderMode = ChuangVideoRenderMode.ASPECT_FIT;
                }
                if (checkedId == R.id.flipFillRadioButton) {
                    chuangVideoRenderMode = ChuangVideoRenderMode.SCALE_TO_FILL;
                }
            }
        });
        binding.openMixAudioSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> mixAudioSwitch = isChecked);
        binding.openMixStreamSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> PreferenceUtils.putBoolean(getContext(), PsKeyContants.MIX_VIDEO_ENABLE, isChecked));
        binding.publishStreamResolution.setText(PreferenceUtils.getString(requireContext(), PsKeyContants.VIDEO_RESOLUTION_CONTENT, "540 * 960") + " >");
        binding.publishStreamResolutionContainer.setOnClickListener(v -> showResolutionDialog());
    }


    private void showResolutionDialog() {
        if (resolutionDialog == null) {
            resolutionDialog = new ResolutionDialogTextList(false);
        }
        resolutionDialog.getResolution(content -> {
            if (null != content) {
                binding.publishStreamResolution.setText(content + " >");
                PreferenceUtils.putString(getContext(), PsKeyContants.VIDEO_RESOLUTION_CONTENT, content);
                if (null != resolutionCallback) {
                    resolutionCallback.callback();
                }
            }
            if (getDialog() != null) {
                getDialog().getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
                DisplayUtil.hideNavigationBar(getDialog().getWindow().getDecorView());
                getDialog().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
            }
        });
        resolutionDialog.show(getChildFragmentManager(), "resolutionDialog");
    }

    @Override
    public void onDismiss(@NonNull DialogInterface dialog) {
        super.onDismiss(dialog);
        if (null != onDismissCallback)
            onDismissCallback.dissmiss(enableQuality, enableVideoMirror, enableNetSpeed, enableSoundLevel, enableLog, mixAudioSwitch, chuangVideoRenderMode);
    }

    private OnSettingsCallback onDismissCallback;

    public void setOnDismissCallback(OnSettingsCallback onDismissCallback) {
        this.onDismissCallback = onDismissCallback;
    }

    public interface OnSettingsCallback {
        void dissmiss(boolean enableQuality, boolean enableVideoMirror, boolean enableNetSpeed, boolean enableSoundLevel, boolean enableLog, boolean mixAudioSwitch, ChuangVideoRenderMode chuangVideoRenderMode);

        void sendCustomMsg(String msg);

        void takePic(ImageView img);
    }

    public void updatePublishStreamStatus(ChuangPublishState chuangPublishState) {
        this.chuangPublishState = chuangPublishState;
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

    public interface ResolutionCallback {
        void callback();
    }
}
