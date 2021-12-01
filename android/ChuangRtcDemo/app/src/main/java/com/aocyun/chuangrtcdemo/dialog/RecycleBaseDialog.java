package com.aocyun.chuangrtcdemo.dialog;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.FragmentManager;

import com.aocyun.chuangrtcdemo.databinding.DialogBaseLayoutBinding;

/**
 * @Author SongTiChao
 * @CreateDate 2021/7/20 17:56
 * Description:
 */
public class RecycleBaseDialog extends DialogFragment {
    DialogBaseLayoutBinding binding;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        binding = DialogBaseLayoutBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initView();
    }

    @Override
    public void onResume() {
        super.onResume();
        Window window = getDialog().getWindow();
        window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        WindowManager.LayoutParams lp = window.getAttributes();
        lp.width = WindowManager.LayoutParams.MATCH_PARENT;
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
        window.setAttributes(lp);
    }

    void setTitle(String title) {
        binding.titleTextView.setText(title);
    }

    private void initView() {
        binding.dismissBtn.setOnClickListener(v -> dismiss());
    }

    @Override
    public void show(@NonNull FragmentManager manager, String tag) {
        if (!this.isAdded() && !this.isVisible() && !this.isRemoving()) {
            super.show(manager, tag);
        }
    }
}
