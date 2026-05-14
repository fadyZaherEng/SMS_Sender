package com.example.sms_sender

import android.content.Context
import android.os.Build
import android.telephony.SmsManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SmsPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.example.sms_sender/sms")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "sendSms") {
            val phone = call.argument<String>("phone")
            val message = call.argument<String>("message")

            if (phone.isNullOrBlank() || message.isNullOrBlank()) {
                result.error("ERR_ARGS", "Missing phone or message", null)
                return
            }

            try {
                val smsManager: SmsManager? =
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        context.getSystemService(SmsManager::class.java) ?: SmsManager.getDefault()
                    } else {
                        @Suppress("DEPRECATION")
                        SmsManager.getDefault()
                    }

                if (smsManager == null) {
                    result.error("ERR_SMS", "SmsManager is not available", null)
                    return
                }

                val parts = smsManager.divideMessage(message)
                if (parts == null || parts.isEmpty()) {
                    result.error("ERR_SMS", "Failed to divide message", null)
                    return
                }

                if (parts.size == 1) {
                    smsManager.sendTextMessage(phone, null, message, null, null)
                } else {
                    smsManager.sendMultipartTextMessage(phone, null, parts, null, null)
                }

                result.success("SMS Sent Successfully")

            } catch (e: Exception) {
                val trace = android.util.Log.getStackTraceString(e)
                android.util.Log.e("SMS_DEBUG", "Crash: $trace")
                result.error("ERR_SMS", "${e.javaClass.simpleName}: ${e.message}", trace)
            }
        } else {
            result.notImplemented()
        }
    }
}
