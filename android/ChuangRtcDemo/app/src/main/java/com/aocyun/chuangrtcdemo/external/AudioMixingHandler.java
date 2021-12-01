package com.aocyun.chuangrtcdemo.external;

import android.content.Context;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.contants.PsKeyContants;

import com.aocyun.chuangrtcdemo.utils.PreferenceUtils;
import com.chuangcache.rtc.entity.ChuangAudioMixingData;
import com.chuangcache.rtc.IChuangAudioMixingHandler;


import java.io.IOException;
import java.io.InputStream;

/**
 * @Author: zhangmd
 * @CreateDate: 2021/4/22 3:44 PM
 */
public class AudioMixingHandler implements IChuangAudioMixingHandler {
    InputStream audioMixingInputStream = null;
    byte[] audioMixingDataBuffer = new byte[48000 * 4];
    private Context mContext;

    public AudioMixingHandler(Context mContext) {
        this.mContext = mContext;
    }

    @Override
    public int onAudioMixingCopyData(ChuangAudioMixingData chuangAudioMixingData) {
        int audioDataBytes = chuangAudioMixingData.needSamplePerChannel * chuangAudioMixingData.channel * 2;

        if (audioMixingInputStream == null) {
            try {
                audioMixingInputStream = mContext.getResources().openRawResource(R.raw.maonv);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            try {
                int ret = audioMixingInputStream.read(audioMixingDataBuffer, 0, audioDataBytes);
                if (ret <= 0) {
                    audioMixingInputStream.close();
                    audioMixingInputStream = null;
                }
                chuangAudioMixingData.pcmData.put(audioMixingDataBuffer, 0, audioDataBytes);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return audioDataBytes;
    }
}
