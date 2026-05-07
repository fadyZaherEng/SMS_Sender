import 'package:equatable/equatable.dart';

class SmsNotification extends Equatable {
  final int notificationUserId;
  final String destination;
  final String body;
  final String message;

  const SmsNotification({
    this.notificationUserId = 0,
    this.destination = '',
    this.body = '',
    this.message = '',
  });

  @override
  List<Object?> get props => [notificationUserId, destination, body, message];
}
