import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sms_sender/src/data/source/api_key.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_sms_notification.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_request.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_response.dart';

part 'sms_api_services.g.dart';

@RestApi()
abstract class SMSAPIService {
  factory SMSAPIService(Dio dio) = _SMSAPIService;

  @POST(APIKeys.sms)
  Future<HttpResponse<SMSResponse<List<RemoteSmsNotification>>>> sms(
      @Body() SMSRequest request);
}
