import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_sender/src/di/injector.dart';
import 'package:sms_sender/src/presentation/bloc/sms/sms_bloc.dart';
import 'package:sms_sender/src/presentation/screens/sms/sms_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
}

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
