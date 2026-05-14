import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sms_sender/src/core/resources/data_state.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/notification_user_state_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/request_sms_notification.dart';
import 'package:sms_sender/src/di/injector.dart';
import 'package:sms_sender/src/domain/entities/sms/sms_notification.dart';
import 'package:sms_sender/src/domain/usecase/sms/sms_notification_use_case.dart';
import 'package:sms_sender/src/domain/usecase/sms/update_notification_user_state_use_case.dart';
import 'package:flutter/services.dart';

class BackgroundServiceUtils {
  static const String channelId = 'sms_background_service_channel';
  static const String channelName = 'SMS Background Service';
  static const String notificationTitle = 'SMS Sender Running';
  static const String notificationContent = 'Fetching and sending SMS in background';

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: 'This channel is used for important notifications.',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: channelId,
        initialNotificationTitle: notificationTitle,
        initialNotificationContent: notificationContent,
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    await service.startService();
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    // Re-initialize dependencies for the background isolate
    try {
      await initializeDependencies();
    } catch (e) {
      debugPrint("Background initializeDependencies failed: $e");
    }

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Periodic task
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          service.setForegroundNotificationInfo(
            title: notificationTitle,
            content: "Last checked: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
          );
        }
      }

      await _fetchAndSendSms();
    });
  }

  static Future<void> _fetchAndSendSms() async {
    try {
      final smsNotificationUseCase = injector<SmsNotificationUseCase>();
      final updateNotificationUserStateUseCase = injector<UpdateNotificationUserStateUseCase>();
      const MethodChannel methodChannel = MethodChannel('com.example.sms_sender/sms');

      final result = await smsNotificationUseCase(
        requestSmsNotification: const RequestSmsNotification(
          compoundId: 1041,
          subscriberId: 1020,
        ),
      );

      if (result is DataSuccess<List<SmsNotification>> && result.data != null) {
        final notifications = result.data!;
        debugPrint("Background Service: Found ${notifications.length} SMS to send");

        for (var notification in notifications) {
          try {
            final String message = "Verification Code: ${notification.body} .This Code Is Valid For 10 Minutes . Please do not share it with anyone";
            
            final sendResult = await methodChannel.invokeMethod('sendSms', {
              'phone': notification.destination,
              'message': message,
            });

            if (sendResult == "SMS Sent Successfully") {
              debugPrint("Background Service: SMS sent successfully to ${notification.destination}");
              await updateNotificationUserStateUseCase(
                request: NotificationUserStateRequest(
                  notificationUserId: notification.notificationUserId,
                  isSent: true,
                ),
              );
            } else {
              debugPrint("Background Service: Failed to send SMS to ${notification.destination}: $sendResult");
            }
          } catch (e) {
            debugPrint("Background Service: Error sending SMS: $e");
          }
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    } catch (e) {
      debugPrint("Background Service: Error in _fetchAndSendSms: $e");
    }
  }
}
