import 'package:sms_sender/src/core/resources/data_state.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/request_sms_notification.dart';
import 'package:sms_sender/src/domain/entities/sms/sms_notification.dart';
import 'package:sms_sender/src/domain/repositories/sms/sms_repository.dart';

class SmsNotificationUseCase {
  final SMSRepository smsRepository;

  SmsNotificationUseCase({
    required this.smsRepository,
  });

  Future<DataState<List<SmsNotification>>> call({
    required RequestSmsNotification requestSmsNotification,
  }) async {
    return await smsRepository.smsNotification(request: requestSmsNotification);
  }
}
