package com.aocyun.chuangrtcdemo.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;

import androidx.annotation.NonNull;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.utils.DisplayUtil;

public class PermissesDialog extends Dialog {
    private Context mContext;
    private Button toSettingsBtn;
    private Button cancleBtn;


    public PermissesDialog(@NonNull Context context) {
        super(context, R.style.CustomDialog);
        this.mContext = context;
        View view = View.inflate(context, R.layout.permisses_dialog, null);
        setContentView(view);
        Window win = getWindow();
        WindowManager.LayoutParams lp = win.getAttributes();
        lp.width = DisplayUtil.dip2px(mContext, 300);
        lp.height = DisplayUtil.dip2px(mContext, 190);
        win.setAttributes(lp);
        initView();
        initData();
    }

    private void initData() {
    }

    private void initView() {
        toSettingsBtn = findViewById(R.id.to_settings_btn);
        cancleBtn = findViewById(R.id.cancle_btn);


        toSettingsBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((Activity) mContext).startActivityForResult(getAppDetailSettingIntent(mContext), 98);
                dismiss();
            }
        });

        cancleBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
    }

    public static Intent getAppDetailSettingIntent(Context mContext) {
        Intent localIntent = new Intent();
        localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (Build.VERSION.SDK_INT >= 9) {
            localIntent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
            localIntent.setData(Uri.fromParts("package", mContext.getPackageName(), null));
        } else if (Build.VERSION.SDK_INT <= 8) {
            localIntent.setAction(Intent.ACTION_VIEW);
            localIntent.setClassName("com.android.settings", "com.android.settings.InstalledAppDetails");
            localIntent.putExtra("com.android.settings.ApplicationPkgName", mContext.getPackageName());
        }
        return localIntent;
    }

}
