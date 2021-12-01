# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-keep class com.chuangcache.rtc.ChuangLiveEngine{*;}
-keep class com.chuangcache.rtc.ChuangLiveEngineImpl{*;}
-keep class com.chuangcache.rtc.IChuangAudioMixingHandler{*;}
-keep class com.chuangcache.rtc.IChuangCustomVideoCaptureHandler{*;}
-keep class com.chuangcache.rtc.IChuangCustomVideoRenderHandler{*;}
-keep class com.chuangcache.rtc.IChuangEventHandler{*;}
-keep class com.chuangcache.rtc.IChuangMixStreamCallback{*;}
-keep class com.chuangcache.rtc.IChuangPublisherTakeSnapshotCallback{*;}
-keep class com.chuangcache.rtc.constants.*{*;}
-keep class com.chuangcache.rtc.entity.*{*;}
-keep class com.chuangcache.rtc.enums.*{*;}
-keep class com.chuangcache.rtc.util.Version{*;}

-keep class lib.livevideo.**{*;}
