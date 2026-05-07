import 'package:sms_sender/src/domain/usecase/sms/bulk_update_notification_user_state_use_case.dart';
import 'package:sms_sender/src/domain/usecase/sms/sms_notification_use_case.dart';
import 'package:sms_sender/src/domain/usecase/sms/update_notification_user_state_use_case.dart';

import 'data_layer_injector.dart';

Future<void> initializeUseCaseDependencies() async {
  injector.registerFactory<SmsNotificationUseCase>(
      () => SmsNotificationUseCase(smsRepository: injector()));

  injector.registerFactory<UpdateNotificationUserStateUseCase>(
      () => UpdateNotificationUserStateUseCase(smsRepository: injector()));

  injector.registerFactory<BulkUpdateNotificationUserStateUseCase>(
      () => BulkUpdateNotificationUserStateUseCase(smsRepository: injector()));
}
