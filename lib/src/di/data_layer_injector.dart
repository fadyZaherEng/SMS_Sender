import 'dart:io';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sms_sender/src/data/source/api_key.dart';

final injector = GetIt.instance;

Future<void> initializeDataDependencies() async {
// إعداد Dio مع SSL و Timeout
  final dio = Dio()
    ..options.baseUrl = APIKeys.baseURL // استبدل بعنوان API الخاص بك
    ..options.connectTimeout = const Duration(seconds: 30)
    ..options.receiveTimeout = const Duration(seconds: 30)
    ..interceptors.add(ChuckerDioInterceptor())
    ..interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

  // السماح بالشهادات غير الموثوقة
  if (!kIsWeb) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }

  injector.registerLazySingleton<Dio>(() => dio);

  // final SharedPreferences sharedPreferences =
  //     await SharedPreferences.getInstance();
  //
  // injector.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  //
  // injector.registerSingleton<LoginAPIService>(LoginAPIService(injector()));
}
