import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_sender/src/di/injector.dart';
import 'package:sms_sender/src/presentation/bloc/sms/sms_bloc.dart';
import 'package:sms_sender/src/presentation/screens/sms/sms_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  ChuckerFlutter.showNotification = true;
  ChuckerFlutter.showOnRelease = true;
  try {
    await initializeDependencies();
  } catch (e) {
    debugPrint("initializeDependencies failed: $e");
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

//use this to make the app run in background and send sms without opening the app
//flutter_background_service
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Sender',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SmsBloc>(create: (context) => injector()),
        ],
        child: const SmsSenderScreen(),
      ),
    );
  }
}
