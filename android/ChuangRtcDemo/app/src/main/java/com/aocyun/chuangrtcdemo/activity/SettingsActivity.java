package com.aocyun.chuangrtcdemo.activity;

import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.widget.LinearLayout;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;
import com.aocyun.chuangrtcdemo.databinding.AcSettingsLayoutBinding;
import com.aocyun.chuangrtcdemo.dialog.MixBitrateDialogTextList;
import com.aocyun.chuangrtcdemo.dialog.MixCanvasDialogTextList;
import com.aocyun.chuangrtcdemo.dialog.ResolutionDialogTextList;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;
import com.aocyun.chuangrtcdemo.utils.ToastUtils;


public class SettingsActivity extends BaseActivity implements View.OnClickListener {
    private boolean publishRtmpEnable;
    private boolean mixVideoEnable;
    private boolean rtcMixVideoEnable;
    private boolean isShowQuality;

    private String rtmpAddressTxt;
    private String mixAddressTxt;
    private ResolutionDialogTextList resolutionDialog;
    private MixBitrateDialogTextList mixBitrateDialog;
    private MixCanvasDialogTextList mixCanvasDialog;
    private String videoCotentTxt;
    private String mixBitrateTxt;
    private String mixCanvasContentTxt;
    private boolean isOnlyAudio;
    private AcSettingsLayoutBinding binding;

    @Override
    protected View createView() {
        binding = AcSettingsLayoutBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    protected void initView() {
        binding.rlMixBitrate.setOnClickListener(this);
        binding.resolutionBtn.setOnClickListener(this);
        binding.titleBar.backBtn.setOnClickListener(this);
        binding.rlMixCanvas.setOnClickListener(this);
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) binding.titleBar.settingsTitle.getLayoutParams();
        layoutParams.setMargins(0, statusBarHeight, 0, 0);
        binding.titleBar.settingsTitle.setLayoutParams(layoutParams);
        binding.titleBar.titleTextView.setText("常用功能设置");
        binding.openRtmpBtn.setChecked(publishRtmpEnable);
        binding.openMixBtn.setChecked(mixVideoEnable);
        binding.openRtcMixBtn.setChecked(rtcMixVideoEnable);

        binding.openRtcMixBtn.setOnCheckedChangeListener((buttonView, isChecked) -> {
            PreferenceUtils.putBoolean(mContext, PsKeyContants.MIX_RTC_VIDEO_ENABLE, isChecked);
            rtcMixVideoEnable = isChecked;
        });
        binding.showDataQualityBtn.setChecked(isShowQuality);
        binding.onlyAudioSwitchBtn.setChecked(isOnlyAudio);
        binding.llMixconfig.setVisibility(mixVideoEnable ? View.VISIBLE : View.GONE);
        binding.rlRtmpAddress.setVisibility(publishRtmpEnable ? View.VISIBLE : View.GONE);
        binding.rtmpAddressEt.setText(rtmpAddressTxt);
        binding.mixAddressEt.setText(mixAddressTxt);
        binding.resolutionTv.setText(videoCotentTxt + " >");
        binding.mixCanvasTv.setText(mixCanvasContentTxt + " >");
        binding.mixBitrateTv.setText(mixBitrateTxt + " >");
        binding.openMixBtn.setOnCheckedChangeListener((buttonView, isChecked) -> {
            binding.llMixconfig.setVisibility(isChecked ? View.VISIBLE : View.GONE);
            PreferenceUtils.putBoolean(mContext, PsKeyContants.MIX_VIDEO_ENABLE, isChecked);
            mixVideoEnable = isChecked;
        });
        binding.openRtmpBtn.setOnCheckedChangeListener((buttonView, isChecked) -> {
            binding.rlRtmpAddress.setVisibility(isChecked ? View.VISIBLE : View.GONE);
            PreferenceUtils.putBoolean(mContext, PsKeyContants.PUBLISH_RTMP_ENABLE, isChecked);
            publishRtmpEnable = isChecked;
        });
        binding.showDataQualityBtn.setOnCheckedChangeListener((buttonView, isChecked) -> PreferenceUtils.putBoolean(mContext, PsKeyContants.SHOW_DATA_QUALITY_STATUS, isChecked));
        binding.onlyAudioSwitchBtn.setOnCheckedChangeListener((buttonView, isChecked) -> PreferenceUtils.putBoolean(mContext, PsKeyContants.ONLY_AUDIO, isChecked));
        binding.aboutTextView.setOnClickListener(v -> {
            AboutActivity.startActivity(this);
        });
    }

    @Override
    protected void initData() {
        publishRtmpEnable = PreferenceUtils.getBoolean(mContext, PsKeyContants.PUBLISH_RTMP_ENABLE, false);
        mixVideoEnable = PreferenceUtils.getBoolean(mContext, PsKeyContants.MIX_VIDEO_ENABLE, false);
        rtcMixVideoEnable = PreferenceUtils.getBoolean(mContext, PsKeyContants.MIX_RTC_VIDEO_ENABLE, false);
        isOnlyAudio = PreferenceUtils.getBoolean(mContext, PsKeyContants.ONLY_AUDIO, false);
        isShowQuality = PreferenceUtils.getBoolean(mContext, PsKeyContants.SHOW_DATA_QUALITY_STATUS, false);
        rtmpAddressTxt = PreferenceUtils.getString(mContext, PsKeyContants.RTMP_ADDRESS, "");
        mixAddressTxt = PreferenceUtils.getString(mContext, PsKeyContants.MIX_ADDRESS, "");
        videoCotentTxt = PreferenceUtils.getString(mContext, PsKeyContants.VIDEO_RESOLUTION_CONTENT, "540 * 960");
        mixBitrateTxt = PreferenceUtils.getString(mContext, PsKeyContants.Mix_BITRATE_CONTENT, "800kbps");
        mixCanvasContentTxt = PreferenceUtils.getString(mContext, PsKeyContants.MIX_CANVAS_CONTENT, "800 * 600");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        PreferenceUtils.putString(mContext, PsKeyContants.RTMP_ADDRESS, binding.rtmpAddressEt.getText().toString());
        if (binding.openMixBtn.isChecked()) {
            PreferenceUtils.putString(mContext, PsKeyContants.MIX_ADDRESS, binding.mixAddressEt.getText().toString());
        } else {
            PreferenceUtils.remove(mContext, PsKeyContants.MIX_ADDRESS);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.back_btn:
                if (canFinishActivity()) {
                    finish();
                }
                break;
            case R.id.resolution_btn:
                showResolutionDialog();
                break;
            case R.id.rlMixBitrate:
                showBitrateDialog();
                break;
            case R.id.rl_mix_canvas:
                showCanvasDialog();
                break;
        }
    }

    private boolean canFinishActivity() {
        if (publishRtmpEnable && TextUtils.isEmpty(binding.rtmpAddressEt.getText().toString()) && mixVideoEnable && TextUtils.isEmpty(binding.mixAddressEt.getText().toString())) {
            ToastUtils.showToast("RTMP推流和RTMP混流地址不能为空");
            return false;
        }
        if (publishRtmpEnable && TextUtils.isEmpty(binding.rtmpAddressEt.getText().toString())) {
            ToastUtils.showToast("RTMP推流地址不能为空");
            return false;
        }
        if (mixVideoEnable && TextUtils.isEmpty(binding.mixAddressEt.getText().toString())) {
            ToastUtils.showToast("RTMP混流地址不能为空");
            return false;
        }
        return true;
    }

    private void showResolutionDialog() {
        if (resolutionDialog == null) {
            resolutionDialog = new ResolutionDialogTextList(true);
        }
        resolutionDialog.getResolution(content -> {
            if (null != content) {
                binding.resolutionTv.setText(content + " >");
                PreferenceUtils.putString(mContext, PsKeyContants.VIDEO_RESOLUTION_CONTENT, content);
            }
        });
        resolutionDialog.show(getSupportFragmentManager(), "resolutionDialog");
    }

    private void showBitrateDialog() {
        if (mixBitrateDialog == null) {
            mixBitrateDialog = new MixBitrateDialogTextList();
        }
        mixBitrateDialog.getMixBitrate(content -> {
            binding.mixBitrateTv.setText(content + " >");
            PreferenceUtils.putString(mContext, PsKeyContants.Mix_BITRATE_CONTENT, content);
        });
        mixBitrateDialog.show(getSupportFragmentManager(), "mixBitrateDialog");
    }

    private void showCanvasDialog() {
        if (mixCanvasDialog == null) {
            mixCanvasDialog = new MixCanvasDialogTextList();
        }
        mixCanvasDialog.getMixCanvas(content -> {
            binding.mixCanvasTv.setText(content + " >");
            PreferenceUtils.putString(mContext, PsKeyContants.MIX_CANVAS_CONTENT, content);
        });
        mixCanvasDialog.show(getSupportFragmentManager(), "mixCanvasDialog");
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (canFinishActivity()) {
                return super.onKeyDown(keyCode, event);
            } else {
                return true;
            }
        }
        return super.onKeyDown(keyCode, event);
    }
}
