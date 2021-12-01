package com.aocyun.chuangrtcdemo.utils;


import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

public class SystemUtils {
//    public static int getRawIdBySamplerateAndChannel(int samplerate, int channel) {
//        if (samplerate == 48000) {
//            if (channel == 1)
//                return R.raw.audio_48000_1;
//            else
//                return R.raw.audio_48000_2;
//        } else if (samplerate == 16000) {
//            if (channel == 1)
//                return R.raw.audio_16000_1;
//        }
//        return -1;
//    }

    /**
     * 获取版本号
     *
     * @return 当前应用的版本号
     */
    public  static String getVersion(Context mContext) {
        try {
            PackageManager manager = mContext.getPackageManager();
            PackageInfo info = manager.getPackageInfo(mContext.getPackageName(), 0);
            String version = info.versionName;
            return version;
        } catch (Exception e) {
            e.printStackTrace();
            return "无法获取到版本号";
        }
    }
}
