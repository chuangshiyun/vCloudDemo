package com.aocyun.chuangrtcdemo.dialog;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.aocyun.chuangrtcdemo.adapters.TextItemAdapter;
import com.aocyun.chuangrtcdemo.beans.TextBean;
import com.aocyun.chuangrtcdemo.interfaces.OnItemClickCallback;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;

import java.util.List;

/**
 * @Author SongTiChao
 * @CreateDate 2021/7/20 17:56
 * Description:
 */
public class TextListBaseDialog extends RecycleBaseDialog {
    private TextItemAdapter adapter;
    private OnItemClickCallback onItemClickCallback;
    private List<TextBean> list;
    private String preferenceKey;

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initView();
    }

    private void initView() {
        binding.dismissBtn.setOnClickListener(v -> {
            PreferenceUtils.putString(requireContext(), preferenceKey, list.get(0).getId());
            onItemClickCallback.callBack(list.get(0).getContent());
            dismiss();
        });
        binding.recyclerView.setLayoutManager(new LinearLayoutManager(requireContext()));
        adapter = new TextItemAdapter(requireContext());
        binding.recyclerView.setAdapter(adapter);

        adapter.setOnItemClickListener(position -> {
            PreferenceUtils.putString(requireContext(), preferenceKey, list.get(position).getId());
            if (null != onItemClickCallback) {
                onItemClickCallback.callBack(list.get(position).getContent());
            }
            dismiss();
        });
        adapter.setData(list);
        adapter.updateSelectedItem(PreferenceUtils.getString(requireContext(), preferenceKey, ""));
    }

    public void updateLayout(String key) {
        preferenceKey = key;
    }

    public void setData(List<TextBean> list) {
        this.list = list;
    }

    public void setOnItemClickCallback(OnItemClickCallback onItemClickCallback) {
        this.onItemClickCallback = onItemClickCallback;
    }
}
