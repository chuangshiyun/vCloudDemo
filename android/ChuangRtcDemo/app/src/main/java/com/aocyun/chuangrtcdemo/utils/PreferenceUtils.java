package com.aocyun.chuangrtcdemo.utils;

import android.content.Context;
import android.content.SharedPreferences;

public class PreferenceUtils {
	private static SharedPreferences sp;
	public static SharedPreferences getSharedPreferences(Context context){
		if (sp==null) {
			sp = context.getSharedPreferences("config", Context.MODE_PRIVATE);
		}
		return sp;
	}
	public static void putBoolean(Context context, String key, boolean value){
		 getSharedPreferences(context);
		sp.edit().putBoolean(key, value).commit();
	}
	public static boolean getBoolean(Context context, String key, boolean defValue){
		getSharedPreferences(context);
		return sp.getBoolean(key, defValue);
	}
	
	public static void putInt(Context context, String key, int value){
		getSharedPreferences(context);
		sp.edit().putInt(key, value).commit();
	}
	public static int getInt(Context context, String key, int defValue){
		getSharedPreferences(context);
		return sp.getInt(key, defValue);
	}
	
	public static void putString(Context context, String key, String value){
		getSharedPreferences(context);
		sp.edit().putString(key, value).commit();
	}
	public static String getString(Context context, String key, String defValue){
		getSharedPreferences(context);
		return sp.getString(key, defValue);
	}
	public static void remove(Context context, String key) {
		getSharedPreferences(context);
		sp.edit().remove(key).commit();	
	}

	public static void clear(Context context) {
		SharedPreferences preferences = context.getSharedPreferences("config", Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = preferences.edit();
		editor.clear();
		editor.commit();
	}
}





















