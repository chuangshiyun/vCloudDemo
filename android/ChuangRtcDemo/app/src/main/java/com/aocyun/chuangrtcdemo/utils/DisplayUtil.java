package com.aocyun.chuangrtcdemo.utils;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Point;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.Display;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.Window;
import android.view.WindowManager;

import com.aocyun.chuangrtcdemo.R;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;


public class DisplayUtil {
    private static final String TAG = "DisplayUtil";

    /**
     * dipתpx
     *
     * @param context
     * @param dipValue
     * @return
     */
    public static int dip2px(Context context, float dipValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dipValue * scale + 0.5f);
    }

    /**
     * pxתdip
     *
     * @param context
     * @param pxValue
     * @return
     */
    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    public static int sp2px(Context context, float spValue) {
        final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
        return (int) (spValue * fontScale + 0.5f);
    }

    private static final Resources sResource = Resources.getSystem();

    public static float dp2px(float dp) {
        DisplayMetrics dm = sResource.getDisplayMetrics();
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, dm);
    }

    public static int dp2pxInt(float dp) {
        return (int) dp2px(dp);
    }

    public static float sp2px(float sp) {
        DisplayMetrics dm = sResource.getDisplayMetrics();
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, sp, dm);
    }

    public static int sp2pxInt(float sp) {
        return (int) sp2px(sp);
    }


    public static float getDensity(Context context) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return scale;
    }

    /**
     * 获取状态栏高度
     *
     * @param context
     * @return
     */
    public static int getStatusBarHeight(Context context) {
        int result = 0;
        int resourceId = context.getResources().getIdentifier("status_bar_height", "dimen",
                "android");
        if (resourceId > 0) {
            result = context.getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }

    /**
     * ��ȡ��Ļ��Ⱥ͸߶ȣ���λΪpx
     *
     * @param context
     * @return
     */
    public static Point getScreenMetrics(Context context) {
        DisplayMetrics dm = context.getResources().getDisplayMetrics();
        int w_screen = dm.widthPixels;
        int h_screen = dm.heightPixels;
        Log.i(TAG, "Screen---Width = " + w_screen + " Height = " + h_screen + " densityDpi = " + dm.densityDpi);
        return new Point(w_screen, h_screen);

    }

    /**
     * ��ȡ��Ļ�����
     *
     * @param context
     * @return
     */
    public static float getScreenRate(Context context) {
        Point P = getScreenMetrics(context);
        float H = P.y;
        float W = P.x;
        return (H / W);
    }


    /**
     * 获取屏幕宽高
     *
     * @return int[]  , width=int[0]  , height=int[1]
     */
    public static int[] getWidthAndHeight(Context context) {
        WindowManager manager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics dm = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(dm);
        return new int[]{dm.widthPixels, dm.heightPixels};
    }

    /**
     * 获取屏幕真实宽高
     *
     * @return height
     */
    public static int[] getScreen(Context context) {
        int heightPixels;
        WindowManager manager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display display = manager.getDefaultDisplay();
        DisplayMetrics metrics = new DisplayMetrics();
        display.getMetrics(metrics);

        // since SDK_INT = 1;
        heightPixels = metrics.heightPixels;

        // includes window decorations (statusbar bar/navigation bar)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH && Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN_MR1) {
            try {
                heightPixels = (Integer) Display.class.getMethod("getRawHeight").invoke(display);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            }
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            Point realSize = new Point();
            try {
                Display.class.getMethod("getRealSize", Point.class).invoke(display, realSize);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            }
            heightPixels = realSize.y;
        }

        return new int[]{metrics.widthPixels, heightPixels};
    }


    /**
     * 获取镜头的方向
     *
     * @return 方向
     */
    public static int getRotation(Context context) {
        WindowManager manager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        return manager.getDefaultDisplay().getRotation();
    }

    /**
     * 是否横屏
     *
     * @return true 是， false 不是
     */
    public static boolean isLandscape(Context context) {
        Configuration mOrientation = context.getResources().getConfiguration();
        return mOrientation.orientation == Configuration.ORIENTATION_LANDSCAPE;
    }

    /**
     * 判断是否存在NavigationBar
     * @param context：上下文环境
     * @return：返回是否存在(true/false)
     * 此方法不准确  有的手机没有导航栏 也返回true
     */
    private static boolean hasNavBar(Context context) {
        Resources res = context.getResources();
        int resourceId = res.getIdentifier("config_showNavigationBar", "bool", "android");
        if (resourceId != 0) {
            boolean hasNav = res.getBoolean(resourceId);
            String sNavBarOverride = getNavBarOverride();
            if ("1".equals(sNavBarOverride)) {
                hasNav = false;
            } else if ("0".equals(sNavBarOverride)) {
                hasNav = true;
            }
            return hasNav;
        } else {
            return !ViewConfiguration.get(context).hasPermanentMenuKey();
        }
    }

    //判断是否有导航栏
    public static boolean isNavigationBarShow(Context context) {
        Display defaultDisplay;
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            defaultDisplay = ((Activity) context).getWindowManager().getDefaultDisplay();
        } else {
            try {
                defaultDisplay = context.getDisplay();
            } catch (NoSuchMethodError error) {
                return false;
            }
        }
        DisplayMetrics outMetrics = new DisplayMetrics();
        defaultDisplay.getRealMetrics(outMetrics);
        //获取屏幕高度
        int heightPixels = outMetrics.heightPixels;
        //宽度
        int widthPixels = outMetrics.widthPixels;
        //获取内容高度
        int heightPixels2 = context.getResources().getDisplayMetrics().heightPixels;
        //宽度
        int widthPixels2 = context.getResources().getDisplayMetrics().widthPixels;
        return heightPixels - getStatusBarHeight(context) - heightPixels2 > 0 || widthPixels - widthPixels2 > 0;
    }
    /**
     * 判断虚拟按键栏是否重写
     */
    private static String getNavBarOverride() {
        String sNavBarOverride = null;
        try {
            Class c = Class.forName("android.os.SystemProperties");
            Method m = c.getDeclaredMethod("get", String.class);
            m.setAccessible(true);
            sNavBarOverride = (String) m.invoke(null, "qemu.hw.mainkeys");
        } catch (Exception e) {
            Log.e(TAG, e.toString());
        }
        return sNavBarOverride;
    }

    /**
     * 测量底部导航栏的高度
     * @param context:上下文环境
     * @return：返回测量出的底部导航栏高度
     */
    public static int getNavigationBarHeight(Context context) {
        int result = 0;
            Resources res = context.getResources();
            int resourceId = res.getIdentifier("navigation_bar_height", "dimen", "android");
            if (resourceId > 0) {
                result = res.getDimensionPixelSize(resourceId);
        }
        return result;
    }

    public static void setBottomNavbarTransparent(Activity activity) {
        Window window = activity.getWindow();
        int option = View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
        window.getDecorView().setSystemUiVisibility(option);
        window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
        window.setNavigationBarColor(activity.getResources().getColor(R.color.transparent));
    }

    //隐藏底部导航栏
    public static void hideNavigationBar(View view) {
        int uiOptions = View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
                //布局位于状态栏下方
                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
                //全屏
                View.SYSTEM_UI_FLAG_FULLSCREEN |
                //隐藏导航栏
                View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN;
        uiOptions |= View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;
        view.setSystemUiVisibility(uiOptions);
    }
}
