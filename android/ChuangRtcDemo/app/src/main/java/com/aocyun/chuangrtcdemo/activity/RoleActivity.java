package com.aocyun.chuangrtcdemo.activity;

import android.content.Intent;
import android.view.View;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;
import com.aocyun.chuangrtcdemo.databinding.AcRoleLayoutBinding;
import com.aocyun.chuangrtcdemo.dialog.PermissesDialog;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;
import com.chuangcache.rtc.enums.ChuangUserRole;

import java.util.Locale;

public class RoleActivity extends BaseActivity implements View.OnClickListener {
    private String roomId;
    private AcRoleLayoutBinding binding;

    @Override
    protected View createView() {
        binding = AcRoleLayoutBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    protected void initData() {
        roomId = PreferenceUtils.getString(this, PsKeyContants.ROOMID, "");
    }

    @Override
    protected void initView() {
        binding.titleBar.backBtn.setOnClickListener(this);
        binding.rlAudienceBtn.setOnClickListener(this);
        binding.rlInteractiveBtn.setOnClickListener(this);
        binding.rlHostBtn.setOnClickListener(this);
        String roomIdTxt = String.format(Locale.US, "房间ID: %s", roomId);
        binding.audienceRoomIdTv.setText(roomIdTxt);
        binding.interactiveRoomIdTv.setText(roomIdTxt);
        binding.hostRoomIdTv.setText(roomIdTxt);
        binding.titleBar.titleTextView.setText("请选择您的身份");
    }


    private void showDialog() {
        PermissesDialog dialog = new PermissesDialog(mContext);
        dialog.show();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.back_btn:
                finish();
                break;
            case R.id.rl_host_btn:
                intentAc(LiveRoomActivity.class, ChuangUserRole.ANCHOR);
                break;
            case R.id.rl_audience_btn:
                intentAc(LiveRoomActivity.class, ChuangUserRole.AUDIENCE);
                break;
            case R.id.rl_interactive_btn:
                intentAc(LiveRoomActivity.class, ChuangUserRole.INTERACTION);
                break;

        }
    }

    private void intentAc(Class acClass, ChuangUserRole userRole) {
        if (!isGrantAllPermissions()) {
            showDialog();
            return;
        }
        Intent intent = new Intent(this, acClass);
        intent.putExtra("enum", ChuangUserRole.getUserRole(userRole.value()));

        startActivity(intent);
    }

}
