import 'package:json_annotation/json_annotation.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/entity/remote_sms_notification.dart';

part 'remote_sms_notifications_response.g.dart';

@JsonSerializable()
class RemoteSmsNotificationsResponse {
  @JsonKey(name: 'notifications')
  final List<RemoteSmsNotification>? notifications;
  @JsonKey(name: 'message')
  final String? message;

  const RemoteSmsNotificationsResponse({
    this.notifications= const [],
    this.message= '',
  });

  factory RemoteSmsNotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$RemoteSmsNotificationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteSmsNotificationsResponseToJson(this);
}
