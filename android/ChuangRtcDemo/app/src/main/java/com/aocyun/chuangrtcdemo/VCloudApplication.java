package com.aocyun.chuangrtcdemo;

import android.app.Application;

import com.aocyun.chuangrtcdemo.utils.CrashHandler;
import com.aocyun.chuangrtcdemo.utils.ToastUtils;

/**
 * @Author: zhangmd
 * @CreateDate: 2021/5/13 11:13 AM
 */
public class VCloudApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        ToastUtils.init(this);
        CrashHandler crashHandler = CrashHandler.getInstance();
        crashHandler.init(this);
    }
}
