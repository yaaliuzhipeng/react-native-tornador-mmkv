// TornadorMMKVModule.java

package com.tornador.mmkv;

import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.turbomodule.core.CallInvokerHolderImpl;

public class TornadorMMKVModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    public static final String TAG = TornadorMMKVModule.class.getSimpleName();

    public native void nativeInstall(long jsiContext, CallInvokerHolderImpl callInvokerHolder,String documentDir);

    public TornadorMMKVModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "TornadorMMKV";
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    public void install(){
        try {
            System.loadLibrary("tornadormmkv");
            long jsiContext = reactContext.getJavaScriptContextHolder().get();
            CallInvokerHolderImpl callInvokerHolder = (CallInvokerHolderImpl) reactContext.getCatalystInstance().getJSCallInvokerHolder();
            if(jsiContext > 0){
                nativeInstall(jsiContext,callInvokerHolder,reactContext.getFilesDir().getAbsolutePath());
            }
        }catch (Exception e) {
            Log.i(TAG, "load native library failed: "+e.getLocalizedMessage());
        }
    }
}
