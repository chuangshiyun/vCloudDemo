package com.aocyun.chuangrtcdemo.activity;

import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.aocyun.chuangrtcdemo.BuildConfig;
import com.aocyun.chuangrtcdemo.databinding.ActivityAboutBinding;
import com.chuangcache.rtc.ChuangLiveEngine;

/**
 * @Author SongTiChao
 * @CreateDate 2021/7/22 17:48
 * Description:
 */
public class AboutActivity extends BaseActivity {
    private ActivityAboutBinding binding;

    public static void startActivity(Context context) {
        context.startActivity(new Intent(context, AboutActivity.class));
    }

    @Override
    protected View createView() {
        binding = ActivityAboutBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    protected void initView() {
        binding.sdkVersionTextView.setText(ChuangLiveEngine.getSDKVersion());
        String stringBuffer = "Android-" +
                BuildConfig.VERSION_NAME +
                "-" +
                BuildConfig.versionDateTime;
        binding.apkVersionTextView.setText(stringBuffer);
        binding.titleBar.backBtn.setOnClickListener(v -> finish());
        binding.titleBar.titleTextView.setText("关于");
    }

    @Override
    protected void initData() {

    }
}
