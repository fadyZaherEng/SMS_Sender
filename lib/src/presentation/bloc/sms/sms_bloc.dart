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

  SmsBloc(this._smsNotificationUseCase,
      this._updateNotificationUserStateUseCase,
      this._bulkUpdateNotificationUserStateUseCase,) : super(SmsInitial()) {
    on<SmsSendEvent>(_onSmsSendEvent);
    on<BulkSmsSendEvent>(_onBulkSmsSendEvent);
    on<GetSMSNotificationToSendOtp>(_onGetSMSNotificationToSendOtp);
    on<UpdateNotificationUserStateEvent>(_onUpdateNotificationUserStateEvent);
    on<BulkUpdateNotificationUserStateEvent>(
        _onBulkUpdateNotificationUserStateEvent);
  }

  static const _channel = MethodChannel('com.example.sms_sender/sms');

  Future<void> _onBulkSmsSendEvent(BulkSmsSendEvent event,
      Emitter<SmsState> emit,) async {
    final status = await Permission.sms.request();

    if (!status.isGranted) {
      emit(SendSmsFailure(errorMessage: "SMS Permission Denied"));
      return;
    }
    for (var notification in event.notifications) {
      try {
        debugPrint("PHONE: ${notification.destination}");
        debugPrint("MESSAGE: ${notification.body}");

        emit(SendSmsLoading());

        final result = await _channel.invokeMethod(
          'sendSms',
          {
            'phone': notification.destination,
            'message': notification.body,
            // "Verification Code: ${notification
            //     .body} .This Code Is Valid For 10 Minutes . Please do not share it with anyone",
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
            responseMessage: "Sent to ${notification.destination}",
          ));
        } else {
          emit(SendSmsFailure(errorMessage: result.toString()));
        }
      } catch (e) {
        emit(SendSmsFailure(
          errorMessage: "Failed: ${e.toString()}",
        ));
      }
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  Future<void> _onSmsSendEvent(SmsSendEvent event,
      Emitter<SmsState> emit) async {
    final status = await Permission.sms.request();
    if (!status.isGranted) {
      emit(SendSmsFailure(errorMessage: "SMS Permission Denied"));
      return;
    }
    debugPrint(
        "MANUAL SENDING: phone: ${event.phoneNumber}, message: ${event
            .message}");
    emit(SendSmsLoading());
    try {
      try {
        final result = await _channel.invokeMethod('sendSms', {
          'phone': event.phoneNumber,
          'message': event.message,
        });
        debugPrint("MANUAL SEND RESULT: $result");
        if (result.toString() == "SMS Sent Successfully") {
          emit(SendSmsSuccess(
              responseMessage: result
                  .toString()
                  .isNotEmpty
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

  Future<void> _onGetSMSNotificationToSendOtp(GetSMSNotificationToSendOtp event,
      Emitter<SmsState> emit) async {
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
}
