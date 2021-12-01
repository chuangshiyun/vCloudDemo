package com.aocyun.chuangrtcdemo.utils;

import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;

//import com.chuangcache.rtc.livevideo.constants.LogLevel;

import com.aocyun.chuangrtcdemo.contants.LogLevel;

import java.io.File;
import java.io.RandomAccessFile;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;



public class Logging {

    private static int LOG_LEVEL = LogLevel.LEVEL_VERBOSE;
    private static int PRINT_LOG_LEVEL = LogLevel.LEVEL_NONE;

    private static String DATE_TO_STRING_DETAIL_PATTERN = "yyyy-MM-dd HH:mm:ss:SSS";


    private static LogCallback mLogCallback = null;

    public static void setCallback(LogCallback callback) {
        mLogCallback = callback;
    }


    public static boolean setLogFilename(String filename) {
        if (TextUtils.isEmpty(filename))
            return false;

        return true;
    }

    public static boolean setLogFileSize(int size) {
        if (size < 0 || size > 10240)
            return false;
        return true;
    }

    public static boolean setLogPath(String path) {
        if (TextUtils.isEmpty(path))
            return false;

        return true;
    }

    public static void v(String tag, String msg) {
        Log.v(tag, msg);

        onLogCallback(msg);
    }

    public static void d(String tag, String msg) {

        Log.d(tag, msg);
        onLogCallback(msg);
    }

    public static void i(String tag, String msg) {

        Log.i(tag, msg);


        onLogCallback(msg);
    }

    public static void format(String TAG, String format, Object... args) {
        String msg = String.format(Locale.US, format, args);
        if (LogLevel.LEVEL_INFO >= PRINT_LOG_LEVEL)
            Log.i(TAG, msg);

        if (LogLevel.LEVEL_INFO >= LOG_LEVEL)
            onLogCallback(msg);
    }

    public static void formatError(String TAG, String format, Object... args) {
        String msg = String.format(Locale.US, format, args);
        Log.e(TAG, msg);
        onLogCallback(msg);
    }


    public static void w(String tag, String msg) {

        Log.w(tag, msg);
        onLogCallback(msg);
    }

    public static void e(String tag, String msg) {
        Log.e(tag, msg);
        onLogCallback(msg);
    }

    public static void n(String msg) {
        onLogCallback(msg);
    }

    private static int mNowSec = 0;

    public static boolean b = true;

    public static void LogOnce(String tag, String msg) {
        if (PRINT_LOG_LEVEL == LogLevel.LEVEL_NONE)
            return;
        if (b) {
            Log.i(tag, msg);
            b = false;
        }
    }

    public static void LogPerSec(String tag, String msg) {
        if (PRINT_LOG_LEVEL == LogLevel.LEVEL_NONE)
            return;
        int sec = (int) System.currentTimeMillis() / 1000;
        if (mNowSec != sec) {
            mNowSec = sec;
            Log.i(tag, msg);
            onLogCallback(msg);
        }
    }


    private static void onLogCallback(String msg) {
        msg = getStringDate() + " | " + msg;
        if (mLogCallback != null) {
            mLogCallback.onLogCallback(msg);
        }
        // writeLogToFile(msg);
    }


    /**
     * 获取现在时间
     *
     * @return 返回字符串格式 yyyy-MM-dd HH:mm:ss
     */
    public static String getStringDate() {
        Date currentTime = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat(DATE_TO_STRING_DETAIL_PATTERN, Locale.US);
        return formatter.format(currentTime);
    }

    private static boolean isWrite = true;
    private static String fileName = "log.txt";
    private static String path = Environment.getExternalStorageDirectory() + "/LogFile";
    private static File files = new File(path);

    /**
     * @param content 将字符串写入到文本文件中
     */
    public static void writeLogToFile(String content) {
        //生成文件夹之后，再生成文件，不然会出错
        String strFilePath = files.getPath() + "/" + fileName;
        // 每次写入时，都换行写
        String strContent = content + "\r\n";
        try {
            File file = new File(strFilePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            RandomAccessFile raf = new RandomAccessFile(file, "rwd");
            Log.e("zmd", "writeLogToFile: 写入成功" + content);
            raf.seek(file.length());
            raf.write(strContent.getBytes());
            raf.close();
        } catch (Exception e) {
            Log.e("TestFile", "Error on write File:" + e.getMessage());
        }
    }

    // 生成文件
    private static File makeFilePath(String filePath, String fileName) {
        File file = null;
        // makeRootDirectory(filePath);
        try {
            file = new File(filePath + fileName);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return file;
    }

    // 生成文件夹
    private static void makeRootDirectory(String filePath) {
        File file;
        try {
            file = new File(filePath);
            if (!file.exists()) {
                file.mkdir();
            }
        } catch (Exception e) {
            Log.i("TestFile:", e.getMessage() + "");
        }
    }

}
