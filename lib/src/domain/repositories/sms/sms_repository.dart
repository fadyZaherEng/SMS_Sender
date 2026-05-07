import 'package:sms_sender/src/core/resources/data_state.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/request_sms_notification.dart';
import 'package:sms_sender/src/domain/entities/sms/sms_notification.dart';

abstract class SMSRepository {
  Future<DataState<List<SmsNotification>>> smsNotification({
    required RequestSmsNotification request,
  });
}
