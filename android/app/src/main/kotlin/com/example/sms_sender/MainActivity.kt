package com.example.sms_sender

import android.os.Build
import android.telephony.SmsManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.sms_sender/sms"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "sendSms") {

                    val phone = call.argument<String>("phone")
                    val message = call.argument<String>("message")

                    if (phone.isNullOrBlank() || message.isNullOrBlank()) {
                        result.error("ERR_ARGS", "Missing phone or message", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val smsManager: SmsManager =
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                applicationContext.getSystemService(SmsManager::class.java)
                            } else {
                                @Suppress("DEPRECATION")
                                SmsManager.getDefault()
                            }

                        // 🔥 تقسيم الرسالة بشكل آمن
                        val parts = smsManager.divideMessage(message)

                        android.util.Log.d("SMS_DEBUG", "Message length: ${message.length}")
                        android.util.Log.d("SMS_DEBUG", "Parts count: ${parts.size}")

                        for (i in parts.indices) {
                            android.util.Log.d("SMS_DEBUG", "Part $i = ${parts[i]}")
                        }

                        try {
                            smsManager.sendMultipartTextMessage(phone, null, parts, null, null)
                            android.util.Log.d("SMS_DEBUG", "SEND CALLED SUCCESS")
                        } catch (e: Exception) {
                            android.util.Log.e("SMS_DEBUG", "FAILED: ${e.message}")
                        }
                        if (parts.size == 1) {
                            smsManager.sendTextMessage(phone, null, message, null, null)
                        } else {
                            smsManager.sendMultipartTextMessage(
                                phone,
                                null,
                                parts,
                                null,
                                null
                            )
                        }

                        result.success("SMS Sent Successfully")

                    } catch (e: Exception) {
                        result.error("ERR_SMS", e.message, null)
                    }

                } else {
                    result.notImplemented()
                }
            }
    }
}