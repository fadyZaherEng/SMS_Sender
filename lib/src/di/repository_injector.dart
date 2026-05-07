import 'package:sms_sender/src/data/repositories/sms_repository_implementation.dart';
import 'package:sms_sender/src/di/data_layer_injector.dart';
import 'package:sms_sender/src/domain/repositories/sms/sms_repository.dart';

Future<void> initializeRepositoryDependencies() async {
  injector.registerFactory<SMSRepository>(
      () => SMSRepositoryImplementation(injector()));
}
