package com.aocyun.chuangrtcdemo.activity;

import android.content.Intent;
import android.text.TextUtils;
import android.view.View;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;
import com.aocyun.chuangrtcdemo.databinding.AcLoginLayoutBinding;
import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;
import com.aocyun.chuangrtcdemo.utils.ToastUtils;


public class LoginActivity extends BaseActivity {
    private AcLoginLayoutBinding binding;

    @Override
    protected View createView() {
        binding = AcLoginLayoutBinding.inflate(getLayoutInflater());
        return binding.getRoot();
    }

    @Override
    protected void initView() {
        getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
        String roomId = PreferenceUtils.getString(this, PsKeyContants.ROOMID, binding.etRoomId.getText().toString());
        String userId = PreferenceUtils.getString(this, PsKeyContants.USERID, binding.etName.getText().toString());
        binding.etRoomId.setText(roomId);
        binding.etName.setText(userId);
        binding.loginBtn.setOnClickListener(v -> toLogin());
        binding.settingsBtn.setOnClickListener(v -> startActivity(new Intent(mContext, SettingsActivity.class)));
    }

    private void toLogin() {
        if (TextUtils.isEmpty(binding.etName.getText().toString()) && TextUtils.isEmpty(binding.etRoomId.getText().toString())) {
            ToastUtils.showToast("房间号用户名不能为空");
            return;
        }
        if (TextUtils.isEmpty(binding.etRoomId.getText().toString())) {
            ToastUtils.showToast(getString(R.string.activity_login_room_id_error_hint));
            return;
        }
        if (TextUtils.isEmpty(binding.etName.getText().toString())) {
            ToastUtils.showToast(getString(R.string.activity_login_room_name_error_hint));
            return;
        }
        if (binding.etName.getText().toString().length() < 2 && binding.etRoomId.getText().toString().length() < 2) {
            ToastUtils.showToast("房间号用户名不少于两位");
            return;
        }
        if (binding.etRoomId.getText().toString().length() < 2) {
            ToastUtils.showToast("房间号不少于两位");
            return;
        }
        if (binding.etName.getText().toString().length() < 2) {
            ToastUtils.showToast("用户名不少于两位");
            return;
        }
        if (!binding.etRoomId.getText().toString().matches("^[A-Za-z0-9-_]+$")) {
            ToastUtils.showToast("房间号用户名只支持数字、字母、下划线和-");
            return;
        }
        if (!binding.etName.getText().toString().matches("^[A-Za-z0-9-_]+$")) {
            ToastUtils.showToast("房间号用户名只支持数字、字母、下划线和-");
            return;
        }
        PreferenceUtils.putString(this, PsKeyContants.ROOMID, binding.etRoomId.getText().toString());
        PreferenceUtils.putString(this, PsKeyContants.USERID, binding.etName.getText().toString());
        Intent it = new Intent(this, RoleActivity.class);
        startActivity(it);

    }

    @Override
    protected void initData() {

    }
}
