import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/src/core/resources/data_state.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/bulk_notification_user_state_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/notification_user_state_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/request_sms_notification.dart';
import 'package:sms_sender/src/domain/entities/sms/message_response.dart';
import 'package:sms_sender/src/domain/entities/sms/sms_notification.dart';
import 'package:sms_sender/src/domain/usecase/sms/sms_notification_use_case.dart';

import 'package:sms_sender/src/domain/usecase/sms/bulk_update_notification_user_state_use_case.dart';
import 'package:sms_sender/src/domain/usecase/sms/update_notification_user_state_use_case.dart';

part 'sms_event.dart';

part 'sms_state.dart';

class SmsBloc extends Bloc<SmsEvent, SmsState> {
  final SmsNotificationUseCase _smsNotificationUseCase;
  final UpdateNotificationUserStateUseCase _updateNotificationUserStateUseCase;
  final BulkUpdateNotificationUserStateUseCase
      _bulkUpdateNotificationUserStateUseCase;

  SmsBloc(
    this._smsNotificationUseCase,
    this._updateNotificationUserStateUseCase,
    this._bulkUpdateNotificationUserStateUseCase,
  ) : super(SmsInitial()) {
    on<SmsSendEvent>(_onSmsSendEvent);
    on<BulkSmsSendEvent>(_onBulkSmsSendEvent);
    on<GetSMSNotificationToSendOtp>(_onGetSMSNotificationToSendOtp);
    on<UpdateNotificationUserStateEvent>(_onUpdateNotificationUserStateEvent);
    on<BulkUpdateNotificationUserStateEvent>(
        _onBulkUpdateNotificationUserStateEvent);
  }

  static const _channel = MethodChannel('com.example.sms_sender/sms');

  Future<void> _onBulkSmsSendEvent(
    BulkSmsSendEvent event,
    Emitter<SmsState> emit,
  ) async {
    final status = await Permission.sms.request();

    if (!status.isGranted) {
      emit(SendSmsFailure(errorMessage: "SMS Permission Denied"));
      return;
    }

    final notifications = event.notifications
        .where(
            (n) => n.body.trim().isNotEmpty && n.destination.trim().isNotEmpty)
        .toList();

    for (var notification in notifications) {
      try {
        // 📱 تنظيف الرقم فقط
        String phone = _convertArabicToEnglish(notification.destination).trim();
        phone = phone.replaceAll(RegExp(r'[^\d+]'), '');

        if (phone.startsWith("+201")) {
          phone = "0${phone.substring(3)}";
        } else if (phone.startsWith("201")) {
          phone = "0${phone.substring(2)}";
        } else if (phone.startsWith("00201")) {
          phone = "0${phone.substring(5)}";
        }

        // 🧼 تنظيف بسيط بدون تكسير النص
        final message = _convertArabicToEnglish(notification.body)
            .replaceAll('\r', '')
            .replaceAll('\n', ' ')
            .replaceAll('\u200B', '')
            .trim();

        debugPrint("PHONE: $phone");
        debugPrint("MESSAGE: ${message.substring(13, 23)}");

        emit(SendSmsLoading());

        final result = await _channel.invokeMethod(
          'sendSms',
          {
            'phone': phone,
            'message': message.substring(13, 23),
          },
        ).timeout(
          const Duration(seconds: 60),
        );

        if (result == "SMS Sent Successfully") {
          await _updateNotificationUserStateUseCase(
            request: NotificationUserStateRequest(
              notificationUserId: notification.notificationUserId,
              isSent: true,
            ),
          );

          emit(SendSmsSuccess(
            responseMessage: "Sent to $phone",
          ));
        } else {
          emit(SendSmsFailure(errorMessage: result.toString()));
        }
      } catch (e) {
        emit(SendSmsFailure(
          errorMessage: "Failed: ${e.toString()}",
        ));
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> _onSmsSendEvent(
      SmsSendEvent event, Emitter<SmsState> emit) async {
    final status = await Permission.sms.request();
    if (!status.isGranted) {
      emit(SendSmsFailure(errorMessage: "SMS Permission Denied"));
      return;
    }

    // تنظيف وتوحيد رقم التليفون
    String phone = _convertArabicToEnglish(event.phoneNumber).trim();
    phone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (phone.startsWith("+2001")) {
      phone = "0${phone.substring(4)}";
    } else if (phone.startsWith("+201")) {
      phone = "0${phone.substring(3)}";
    } else if (phone.startsWith("201")) {
      phone = "0${phone.substring(2)}";
    } else if (phone.startsWith("00201")) {
      phone = "0${phone.substring(5)}";
    }

    // تنظيف الرسالة
    final message = _convertArabicToEnglish(event.message)
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '')
        .replaceAll('\u200E', '')
        .replaceAll('\u200F', '')
        .replaceAll('\u00A0', '')
        .replaceAll('\r', '')
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    debugPrint("MANUAL SENDING: phone: $phone, message: $message");
    emit(SendSmsLoading());
    try {
      try {
        final result = await _channel.invokeMethod('sendSms', {
          'phone': phone,
          'message': message,
        });
        debugPrint("MANUAL SEND RESULT: $result");
        if (result.toString() == "SMS Sent Successfully") {
          emit(SendSmsSuccess(
              responseMessage: result.toString().isNotEmpty
                  ? result.toString()
                  : "SMS sent successfully to ${event.phoneNumber}"));
        }
      } on PlatformException catch (e) {
        emit(SendSmsFailure(errorMessage: "Failed to send SMS: ${e.message}"));
      }
    } catch (e) {
      emit(SendSmsFailure(errorMessage: "Failed to send SMS: ${e.toString()}"));
    }
  }

  Future<void> _onGetSMSNotificationToSendOtp(
      GetSMSNotificationToSendOtp event, Emitter<SmsState> emit) async {
    emit(GetSMSNotificationToSendOtpLoadingState());
    final smsNotificationState = await _smsNotificationUseCase(
        requestSmsNotification: RequestSmsNotification(
      compoundId: event.compoundId,
      subscriberId: event.subscriberId,
    ));
    if (smsNotificationState is DataSuccess<List<SmsNotification>>) {
      emit(GetSMSNotificationToSendOtpSuccessState(
          smsNotificationOtp: smsNotificationState.data ?? []));
    } else if (smsNotificationState is DataFailed) {
      emit(GetSMSNotificationToSendOtpErrorState(
          errorMessage: smsNotificationState.message ?? ""));
    }
  }

  Future<void> _onUpdateNotificationUserStateEvent(
      UpdateNotificationUserStateEvent event, Emitter<SmsState> emit) async {
    emit(UpdateNotificationUserStateLoadingState());
    final result =
        await _updateNotificationUserStateUseCase(request: event.request);
    if (result is DataSuccess<MessageResponse>) {
      emit(UpdateNotificationUserStateSuccessState(
          response: result.data ?? const MessageResponse()));
    } else if (result is DataFailed) {
      emit(UpdateNotificationUserStateErrorState(
          errorMessage: result.message ?? ""));
    }
  }

  Future<void> _onBulkUpdateNotificationUserStateEvent(
      BulkUpdateNotificationUserStateEvent event,
      Emitter<SmsState> emit) async {
    emit(BulkUpdateNotificationUserStateLoadingState());
    final result =
        await _bulkUpdateNotificationUserStateUseCase(request: event.request);
    if (result is DataSuccess<MessageResponse>) {
      emit(BulkUpdateNotificationUserStateSuccessState(
          response: result.data ?? const MessageResponse()));
    } else if (result is DataFailed) {
      emit(BulkUpdateNotificationUserStateErrorState(
          errorMessage: result.message ?? ""));
    }
  }

  String _convertArabicToEnglish(String input) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }
}
