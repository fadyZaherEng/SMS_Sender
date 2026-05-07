import 'package:json_annotation/json_annotation.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/notification_user_state_request.dart';

part 'bulk_notification_user_state_request.g.dart';

@JsonSerializable()
class BulkNotificationUserStateRequest {
  @JsonKey(name: 'notificationUsers')
  final List<NotificationUserStateRequest>? notificationUsers;

  const BulkNotificationUserStateRequest({
    this.notificationUsers,
  });

  factory BulkNotificationUserStateRequest.fromJson(Map<String, dynamic> json) =>
      _$BulkNotificationUserStateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BulkNotificationUserStateRequestToJson(this);
}
