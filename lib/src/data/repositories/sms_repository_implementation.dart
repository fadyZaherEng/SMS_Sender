import 'package:dio/dio.dart';
import 'package:sms_sender/src/core/resources/data_state.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_sms_notification.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/request_sms_notification.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/sms_api_services.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_request.dart';
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
      SMSRequest<RequestSmsNotification> smsRequest =
          SMSRequest<RequestSmsNotification>().createRequest(request);
      final httpResponse = await _smsApiService.sms(smsRequest);
      if (httpResponse.response.statusCode == 200) {
        if ((httpResponse.data.success ?? false) &&
            (httpResponse.data.statusCode ?? 400) == 200) {
          return DataSuccess(
            data: (httpResponse.data.result ?? <RemoteSmsNotification>[])
                .mapToDomainList(),
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
        message: "Bad Response",
      );
    }
  }
}
