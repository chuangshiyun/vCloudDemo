package com.aocyun.chuangrtcdemo.dialog;

import android.content.Context;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.aocyun.chuangrtcdemo.adapters.MixBitrateAdapter;
import com.aocyun.chuangrtcdemo.beans.MixBitrateBeans;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;

import java.util.ArrayList;
import java.util.List;


public class MixBitrateDialogTextList extends RecycleBaseDialog {
    private List<MixBitrateBeans> mixBitrateBeans = new ArrayList<>();

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initView();
        initData();
    }

    private void initData() {
        mixBitrateBeans.clear();
        MixBitrateBeans b1500 = new MixBitrateBeans();
        b1500.setContent("1500kbps");
        b1500.setBitrate(1500);
        MixBitrateBeans b1000 = new MixBitrateBeans();
        b1000.setContent("1000kbps");
        b1000.setBitrate(1000);
        MixBitrateBeans b800 = new MixBitrateBeans();
        b800.setContent("800kbps");
        b800.setBitrate(800);
        MixBitrateBeans b600 = new MixBitrateBeans();
        b600.setContent("600kbps");
        b600.setBitrate(600);
        MixBitrateBeans b400 = new MixBitrateBeans();
        b400.setContent("400kbps");
        b400.setBitrate(400);
        MixBitrateBeans b300 = new MixBitrateBeans();
        b300.setContent("300kbps");

        b300.setBitrate(300);
        mixBitrateBeans.add(b1500);
        mixBitrateBeans.add(b1000);
        mixBitrateBeans.add(b800);
        mixBitrateBeans.add(b600);
        mixBitrateBeans.add(b400);
        mixBitrateBeans.add(b300);
    }

    private void initView() {
        setTitle("选择RTMP混流码率");
        binding.recyclerView.setLayoutManager(new LinearLayoutManager(requireContext()));
        MixBitrateAdapter adapter = new MixBitrateAdapter(requireContext());
        adapter.setData(mixBitrateBeans);
        binding.recyclerView.setAdapter(adapter);

        adapter.setOnItemClickListener(position -> {
            MixBitrateBeans resolutionBeans = mixBitrateBeans.get(position);
            saveBitrate(resolutionBeans.getBitrate(), resolutionBeans.getContent());
        });
    }

    private void saveBitrate(int bitrate, String content) {

        PreferenceUtils.putInt(requireContext(), PsKeyContants.MIX_BITRATE, bitrate);
        PreferenceUtils.putString(requireContext(), PsKeyContants.Mix_BITRATE_CONTENT, content);
        onMixBitrateCallback.mixBitrate(content);
        dismiss();
    }


    private OnMixBitrateCallback onMixBitrateCallback;

    public void getMixBitrate(OnMixBitrateCallback onMixBitrateCallback) {
        this.onMixBitrateCallback = onMixBitrateCallback;
    }

    public interface OnMixBitrateCallback {
        void mixBitrate(String content);
    }

}
