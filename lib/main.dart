import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

void main() {
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
      home: const SmsSenderPage(),
    );
  }
}

class SmsSenderPage extends StatefulWidget {
  const SmsSenderPage({super.key});

  @override
  State<SmsSenderPage> createState() => _SmsSenderPageState();
}

class _SmsSenderPageState extends State<SmsSenderPage> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  static const _channel = MethodChannel('com.example.sms_sender/sms');

  Future<void> _sendSms() async {
    final String number = _numberController.text.trim();
    final String message = _messageController.text;

    if (number.isEmpty) {
      _showError('Please enter a phone number');
      return;
    }

    if (Theme.of(context).platform == TargetPlatform.android) {
      final status = await Permission.sms.request();
      if (!status.isGranted) {
        _showError('SMS Permission Denied');
        return;
      }
    }

    try {
      final result = await _channel.invokeMethod('sendSms', {
        'phone': number,
        'message': message,
      });
      _showSuccess(result.toString());
    } on PlatformException catch (e) {
      _showError(e.message ?? 'Unknown error');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Background Shapes
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.15),
              ),
            ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.5, 0.5)),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEC4899).withOpacity(0.1),
              ),
            ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.8, 0.8)),
          ),

          // Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Direct SMS',
                    style: GoogleFonts.outfit(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn().moveY(begin: 20, end: 0),
                  Text(
                    'Connect with anyone, anywhere.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 10, end: 0),
                  const SizedBox(height: 48),

                  // Glass Card for Input
                  _buildGlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTextField(
                          controller: _numberController,
                          label: 'Recipient Number',
                          icon: Icons.phone_iphone_rounded,
                          hint: '+20 123 567 890',
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(
                          controller: _messageController,
                          label: 'Message',
                          icon: Icons.chat_bubble_outline_rounded,
                          hint: 'Type something meaningful...',
                          isLongText: true,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

                  const SizedBox(height: 32),

                  // Action Button
                  Container(
                    width: double.infinity,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _sendSms,
                        borderRadius: BorderRadius.circular(20),
                        child: const Center(
                          child: Text(
                            'Send SMS Message Now',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0),

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? 'Native composer will open for security'
                          : 'SMS will be sent in background',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isLongText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF6366F1)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: isLongText ? null : 1,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
