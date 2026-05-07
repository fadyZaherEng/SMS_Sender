import 'package:sms_sender/src/presentation/bloc/sms/sms_bloc.dart';

import 'data_layer_injector.dart';

Future<void> initializeBlocDependencies() async {
  injector.registerFactory<SmsBloc>(() => SmsBloc(
        injector(),
      ));
}
