package com.aocyun.chuangrtcdemo.dialog;

import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.aocyun.chuangrtcdemo.adapters.ResolutionAdapter;
import com.aocyun.chuangrtcdemo.beans.ResolutionBeans;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;
import com.aocyun.chuangrtcdemo.utils.DisplayUtil;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;

import java.util.ArrayList;
import java.util.List;

public class ResolutionDialogTextList extends RecycleBaseDialog {
    private List<ResolutionBeans> resolutionBeans = new ArrayList<>();
    private ResolutionAdapter adapter;
    private String content = null;
    private boolean showNavigationBar = true;

    public ResolutionDialogTextList(boolean showNavigationBar) {
        this.showNavigationBar = showNavigationBar;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initView();
        initData();
    }

    @Override
    public void onResume() {
        super.onResume();
        if (getDialog() != null && !showNavigationBar) {
            getDialog().getWindow().setFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
            DisplayUtil.hideNavigationBar(getDialog().getWindow().getDecorView());
            getDialog().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE);
        }
    }

    @Override
    public void onDismiss(@NonNull DialogInterface dialog) {
        super.onDismiss(dialog);
        onResolutionCallback.resolution(content);
    }

    private void initData() {
        resolutionBeans.clear();
        ResolutionBeans r1080P = new ResolutionBeans();
        r1080P.setContent("1080 * 1920");
        r1080P.setWidth(1080);
        r1080P.setHeight(1920);
        r1080P.setFps(15);
        r1080P.setBitrate(3000);
        ResolutionBeans r720P = new ResolutionBeans();
        r720P.setContent("720 * 1280");
        r720P.setWidth(720);
        r720P.setHeight(1280);
        r720P.setFps(15);
        r720P.setBitrate(1500);
        ResolutionBeans r540P = new ResolutionBeans();
        r540P.setContent("540 * 960");
        r540P.setWidth(540);
        r540P.setHeight(960);
        r540P.setFps(15);
        r540P.setBitrate(1200);
        ResolutionBeans r360P = new ResolutionBeans();
        r360P.setContent("360 * 640");
        r360P.setWidth(360);
        r360P.setHeight(640);
        r360P.setFps(15);
        r360P.setBitrate(600);
        ResolutionBeans r270P = new ResolutionBeans();
        r270P.setContent("270 * 480");
        r270P.setWidth(270);
        r270P.setHeight(480);
        r270P.setFps(15);
        r270P.setBitrate(400);
        ResolutionBeans r180P = new ResolutionBeans();
        r180P.setContent("180 * 320");
        r180P.setWidth(180);
        r180P.setHeight(320);
        r180P.setFps(15);
        r180P.setBitrate(300);

        resolutionBeans.add(r1080P);
        resolutionBeans.add(r720P);
        resolutionBeans.add(r540P);
        resolutionBeans.add(r360P);
        resolutionBeans.add(r270P);
        resolutionBeans.add(r180P);
    }

    private void initView() {
        setTitle("选择推流分辨率");
        binding.recyclerView.setLayoutManager(new LinearLayoutManager(requireContext()));
        if (null == adapter) {
            adapter = new ResolutionAdapter(requireContext());
        }
        adapter.setData(resolutionBeans);
        binding.recyclerView.setAdapter(adapter);

        adapter.setOnItemClickListener(position -> {
            ResolutionBeans resolutionBeans = ResolutionDialogTextList.this.resolutionBeans.get(position);
            content = resolutionBeans.getContent();
            saveResolution(resolutionBeans.getWidth(), resolutionBeans.getHeight(),resolutionBeans.getFps(),resolutionBeans.getBitrate());
        });
    }

    private void saveResolution(int width, int height,int fps,int bitrate) {
        PreferenceUtils.putInt(requireContext(), PsKeyContants.VIDEO_WIDTH, width);
        PreferenceUtils.putInt(requireContext(), PsKeyContants.VIDEO_HEIGHT, height);
        PreferenceUtils.putInt(requireContext(), PsKeyContants.VIDEO_FPS, fps);
        PreferenceUtils.putInt(requireContext(), PsKeyContants.VIDEO_BITRATE, bitrate);
        dismiss();
    }


    private OnResolutionCallback onResolutionCallback;

    public void getResolution(OnResolutionCallback OnResolutionCallback) {
        this.onResolutionCallback = OnResolutionCallback;
    }

    public interface OnResolutionCallback {
        void resolution(String content);
    }
}
