import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/src/config/base/widget/base_stateful_widget.dart';
import 'package:sms_sender/src/domain/entities/sms/sms_notification.dart';
import 'package:sms_sender/src/presentation/bloc/sms/sms_bloc.dart';
import 'package:sms_sender/src/presentation/screens/sms/widgets/sms_card_widget.dart';

// {
// "subscriberId": 1020,
// "compoundId": 1041
// }
class SmsSenderScreen extends BaseStatefulWidget {
  const SmsSenderScreen({super.key});

  @override
  BaseState<SmsSenderScreen> baseCreateState() => _SmsSenderScreenState();
}

class _SmsSenderScreenState extends BaseState<SmsSenderScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final List<SmsNotification> _smsNotifications = [];
  Timer? _fetchTimer;

  SmsBloc get _bloc => BlocProvider.of<SmsBloc>(context);

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _fetchTimer = Timer.periodic(const Duration(minutes: 20), (timer) {
      _fetchNotifications();
    });
  }

  void _fetchNotifications() {
    _bloc.add(GetSMSNotificationToSendOtp(
      compoundId: 1041,
      subscriberId: 1020,
    ));
  }

  @override
  Widget baseBuild(BuildContext context) {
    return BlocConsumer<SmsBloc, SmsState>(
      listener: (context, state) {
        if (state is SendSmsFailure) {
          hideLoading();
          _showError(state.errorMessage);
        } else if (state is SendSmsSuccess) {
          hideLoading();
          _showSuccess(state.responseMessage);
        } else if (state is SendSmsLoading) {
          showLoading();
        } else if (state is GetSMSNotificationToSendOtpLoadingState) {
          showLoading();
        } else if (state is GetSMSNotificationToSendOtpSuccessState) {
          hideLoading();
          _smsNotifications.clear();
          _smsNotifications.addAll(state.smsNotificationOtp);
        } else if (state is GetSMSNotificationToSendOtpErrorState) {
          hideLoading();
          _showError(state.errorMessage);
        } else if (state is UpdateNotificationUserStateLoadingState) {
          showLoading();
        } else if (state is UpdateNotificationUserStateSuccessState) {
          hideLoading();
          _showSuccess(state.response.message);
        } else if (state is UpdateNotificationUserStateErrorState) {
          hideLoading();
          _showError(state.errorMessage);
        } else if (state is BulkUpdateNotificationUserStateLoadingState) {
          showLoading();
        } else if (state is BulkUpdateNotificationUserStateSuccessState) {
          hideLoading();
          _showSuccess(state.response.message);
        } else if (state is BulkUpdateNotificationUserStateErrorState) {
          hideLoading();
          _showError(state.errorMessage);
        }
      },
      builder: (context, state) {
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
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(begin: const Offset(0.5, 0.5)),
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
                )
                    .animate()
                    .fadeIn(duration: 1000.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
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
                      )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .moveY(begin: 10, end: 0),
                      const SizedBox(height: 48),

                      // Glass Card for Input
                      SMSCardWidget(
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
                      )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .scale(begin: const Offset(0.95, 0.95)),

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
                            onTap: () async {
                              final number = _numberController.text.trim();
                              final message = _messageController.text.trim();

                              if (number.isEmpty || message.isEmpty) {
                                _showError('Please fill in all fields.');
                                return;
                              }

                              if (!RegExp(r'^\+?\d{7,15}$').hasMatch(number)) {
                                _showError(
                                    'Please enter a valid phone number.');
                                return;
                              }

                              final status = await Permission.sms.request();
                              if (!status.isGranted) {
                                _showError(
                                    'SMS permission is required to send messages.');
                                return;
                              }

                              _bloc.add(
                                SmsSendEvent(
                                  phoneNumber: number,
                                  message: message,
                                  context: context,
                                  notificationUserId: 0,
                                ),
                              );
                            },
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
                      )
                          .animate()
                          .fadeIn(delay: 600.ms)
                          .moveY(begin: 20, end: 0),

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
      },
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
              borderSide:
                  const BorderSide(color: Color(0xFF6366F1), width: 1.5),
            ),
          ),
        ),
      ],
    );
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
    _fetchTimer?.cancel();
    _numberController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
