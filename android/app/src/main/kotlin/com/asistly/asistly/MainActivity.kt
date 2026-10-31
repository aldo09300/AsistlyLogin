package com.asistly.asistly

import android.annotation.SuppressLint
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    @SuppressLint("HardwareIds")
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ANDROID_ID: estable para esta app en este dispositivo (sobrevive a reinstalaciones).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "asistly/device")
            .setMethodCallHandler { call, result ->
                if (call.method == "getDeviceId") {
                    result.success(Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID))
                } else {
                    result.notImplemented()
                }
            }
    }
}
