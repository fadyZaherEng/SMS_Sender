import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sms_sender/src/data/source/api_key.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_message_response.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_sms_notifications_response.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_sms_notification.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/bulk_notification_user_state_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/notification_user_state_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_response.dart';

part 'sms_api_services.g.dart';

@RestApi()
abstract class SMSAPIService {
  factory SMSAPIService(Dio dio) = _SMSAPIService;

  @POST(APIKeys.sms)
  Future<HttpResponse<RemoteSmsNotificationsResponse>> sms(
      @Body() SMSRequest request);

  @POST(APIKeys.smsUserState)
  Future<HttpResponse<SMSResponse<RemoteMessageResponse>>>
      updateNotificationUserState(
          @Body() SMSRequest<NotificationUserStateRequest> request);

  @POST(APIKeys.smsUserStateBulk)
  Future<HttpResponse<SMSResponse<RemoteMessageResponse>>>
      bulkUpdateNotificationUserState(
          @Body() SMSRequest<BulkNotificationUserStateRequest> request);
}
