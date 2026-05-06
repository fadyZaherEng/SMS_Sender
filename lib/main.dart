import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Sender',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    if (Theme.of(context).platform == TargetPlatform.android) {
      // Android: Direct background SMS
      final status = await Permission.sms.request();
      if (status.isGranted) {
        try {
          final result = await _channel.invokeMethod('sendSms', {
            'phone': number,
            'message': message,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.toString())),
          );
        } on PlatformException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SMS Permission Denied')),
        );
      }
    } else {
      // iOS/Other: Fallback to Composer (Direct background SMS is restricted by Apple)
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: number,
        queryParameters: <String, String>{'body': message},
      );
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch SMS app')),
        );
      }
    }
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
      appBar: AppBar(
        title: const Text('Send SMS'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1234567890',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Enter your message here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _sendSms,
              icon: const Icon(Icons.send),
              label: const Text('Send SMS'),
            ),
          ],
        ),
      ),
    );
  }
}
