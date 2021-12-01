package com.aocyun.chuangrtcdemo.dialog;

import android.content.Context;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.aocyun.chuangrtcdemo.adapters.MixCanvasAdapter;
import com.aocyun.chuangrtcdemo.beans.MixCanvasBeans;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;

import java.util.ArrayList;
import java.util.List;



public class MixCanvasDialogTextList extends RecycleBaseDialog {
    private Context mContext;
    private List<MixCanvasBeans> mixCanvasBeans = new ArrayList<>();

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        this.mContext = requireContext();
        initView();
        initData();
    }

    private void initData() {
        mixCanvasBeans.clear();
        MixCanvasBeans p720_1280 = new MixCanvasBeans();
        p720_1280.setContent("720 * 1280");
        p720_1280.setWidth(720);
        p720_1280.setHeight(1280);

        MixCanvasBeans p1280_720 = new MixCanvasBeans();
        p1280_720.setContent("1280 * 720");
        p1280_720.setWidth(1280);
        p1280_720.setHeight(720);

        MixCanvasBeans p800_600 = new MixCanvasBeans();
        p800_600.setContent("800 * 600");
        p800_600.setWidth(800);
        p800_600.setHeight(600);

        MixCanvasBeans p768_432 = new MixCanvasBeans();
        p768_432.setContent("768 * 432");
        p768_432.setWidth(768);
        p768_432.setHeight(432);

        MixCanvasBeans p432_768 = new MixCanvasBeans();
        p432_768.setContent("432 * 768");
        p432_768.setWidth(432);
        p432_768.setHeight(768);

        mixCanvasBeans.add(p720_1280);
        mixCanvasBeans.add(p1280_720);
        mixCanvasBeans.add(p800_600);
        mixCanvasBeans.add(p768_432);
        mixCanvasBeans.add(p432_768);

    }

    private void initView() {
        setTitle("选择RTMP混流分辨率");
        binding.recyclerView.setLayoutManager(new LinearLayoutManager(mContext));
        MixCanvasAdapter adapter = new MixCanvasAdapter(mContext);
        adapter.setData(mixCanvasBeans);
        binding.recyclerView.setAdapter(adapter);

        adapter.setOnItemClickListener(position -> {
            MixCanvasBeans mixCanvasBean = mixCanvasBeans.get(position);
            saveCanvas(mixCanvasBean.getWidth(), mixCanvasBean.getHeight(), mixCanvasBean.getContent());
        });
    }

    private void saveCanvas(int width, int height, String content) {

        PreferenceUtils.putInt(mContext, PsKeyContants.MIX_CANVAS_WIDTH, width);
        PreferenceUtils.putInt(mContext, PsKeyContants.MIX_CANVAS_HEIGHT, height);
        PreferenceUtils.putString(mContext, PsKeyContants.MIX_CANVAS_CONTENT, content);
        onCanvasResolutinCallback.canvasResolution(content);
        dismiss();
    }


    private OnCanvasResolutinCallback onCanvasResolutinCallback;

    public void getMixCanvas(OnCanvasResolutinCallback onCanvasResolutinCallback) {
        this.onCanvasResolutinCallback = onCanvasResolutinCallback;
    }

    public interface OnCanvasResolutinCallback {
        void canvasResolution(String content);
    }

}
