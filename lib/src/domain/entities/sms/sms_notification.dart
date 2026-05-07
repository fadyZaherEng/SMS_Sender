import 'package:equatable/equatable.dart';

class SmsNotification extends Equatable {
  final int notificationUserId;
  final String destination;
  final String body;

  const SmsNotification({
    this.notificationUserId = 0,
    this.destination = '',
    this.body = '',
   });

  @override
  List<Object?> get props => [notificationUserId, destination, body];
}
