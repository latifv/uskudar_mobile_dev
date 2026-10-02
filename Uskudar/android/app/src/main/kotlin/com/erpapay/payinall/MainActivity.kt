package com.erpapay.payinall

import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.HashMap
import com.erpapay.payinall.AuthCallback


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.erpapay.payinall/liveauth"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine
    ) {

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            val authCallback = object : AuthCallback {
                override fun onSuccess(value: Map<String, Any>) {
                    result.success(value)
                }

                override fun onFail(value: Int) {
                    result.error("$value", null, null)
                }
            }
            
            AuthManager.setCallback(authCallback)

            if (call.method == "frontside") {
                val intent = Intent(this@MainActivity, FrontSideActivity::class.java)
                startActivity(intent)
            } else if (call.method == "backside") {
                val intent = Intent(this@MainActivity, BackSideActivity::class.java)
                startActivity(intent)
            } else if (call.method == "nfc") {
                val intent = Intent(this@MainActivity, NfcReaderActivity::class.java)
                startActivity(intent)
            } else if (call.method == "selfie") {
                val intent = Intent(this@MainActivity, SelfieReaderActivity::class.java)
                startActivity(intent)
            } else {
                result.notImplemented()
            }
        }
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}