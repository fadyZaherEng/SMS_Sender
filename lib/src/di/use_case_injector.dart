import 'package:sms_sender/src/domain/usecase/sms/sms_notification_use_case.dart';

import 'data_layer_injector.dart';

Future<void> initializeUseCaseDependencies() async {
  injector.registerFactory<SmsNotificationUseCase>(
      () => SmsNotificationUseCase(smsRepository: injector()));
}
