import 'package:dio/dio.dart';
import 'package:sms_sender/src/core/resources/data_state.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_message_response.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_sms_notifications_response.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_sms_notification.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/bulk_notification_user_state_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/notification_user_state_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/request_sms_notification.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/sms_api_services.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_request.dart';
import 'package:sms_sender/src/domain/entities/sms/message_response.dart';
import 'package:sms_sender/src/domain/entities/sms/sms_notification.dart';
import 'package:sms_sender/src/domain/repositories/sms/sms_repository.dart';

class SMSRepositoryImplementation extends SMSRepository {
  final SMSAPIService _smsApiService;

  SMSRepositoryImplementation(this._smsApiService);

  @override
  Future<DataState<List<SmsNotification>>> smsNotification({
    required RequestSmsNotification request,
  }) async {
    try {
      final httpResponse = await _smsApiService.sms(request);
      if (httpResponse.response.statusCode == 200) {
        return DataSuccess(
          data: (httpResponse.data.notifications ?? <RemoteSmsNotification>[])
              .mapToDomainList(),
          message: httpResponse.data.message ?? "",
        );
      }
      return DataFailed(
        message: "Failed to fetch notifications",
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return DataSuccess(
          data: const [],
          message: e.response?.data is Map
              ? e.response?.data['message']?.toString() ?? "No notifications"
              : "No notifications",
        );
      }
      return DataFailed(
        error: e,
        message: e.type == DioExceptionType.connectionError
            ? "No internet connection"
            : e.message ?? "Something went wrong",
      );
    }
  }
  @override
  Future<DataState<MessageResponse>> updateNotificationUserState({
    required NotificationUserStateRequest request,
  }) async {
    try {
      final httpResponse =
          await _smsApiService.updateNotificationUserState(request);
      if (httpResponse.response.statusCode == 200) {
        if ((httpResponse.data.success ?? false) &&
            (httpResponse.data.statusCode ?? 400) == 200) {
          return DataSuccess(
            data: httpResponse.data.result.mapToDomain(),
            message: httpResponse.data.responseMessage ?? "",
          );
        }
      }
      return DataFailed(
        message: httpResponse.data.responseMessage ?? "",
      );
    } on DioException catch (e) {
      return DataFailed(
        error: e,
        message: e.type == DioExceptionType.connectionError
            ? "No internet connection"
            : e.message ?? "Something went wrong",
      );
    }
  }

  @override
  Future<DataState<MessageResponse>> bulkUpdateNotificationUserState({
    required BulkNotificationUserStateRequest request,
  }) async {
    try {
      final httpResponse =
          await _smsApiService.bulkUpdateNotificationUserState(request);
      if (httpResponse.response.statusCode == 200) {
        if ((httpResponse.data.success ?? false) &&
            (httpResponse.data.statusCode ?? 400) == 200) {
          return DataSuccess(
            data: httpResponse.data.result.mapToDomain(),
            message: httpResponse.data.responseMessage ?? "",
          );
        }
      }
      return DataFailed(
        message: httpResponse.data.responseMessage ?? "",
      );
    } on DioException catch (e) {
      return DataFailed(
        error: e,
        message: e.type == DioExceptionType.connectionError
            ? "No internet connection"
            : e.message ?? "Something went wrong",
      );
    }
  }
}
