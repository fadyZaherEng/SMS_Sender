import 'package:json_annotation/json_annotation.dart';

part 'notification_user_state_request.g.dart';

@JsonSerializable()
class NotificationUserStateRequest {
  @JsonKey(name: 'notificationUserId')
  final int? notificationUserId;
  @JsonKey(name: 'isSent')
  final bool? isSent;

  const NotificationUserStateRequest({
    this.notificationUserId,
    this.isSent,
  });

  factory NotificationUserStateRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationUserStateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationUserStateRequestToJson(this);
  @override
  String toString() {
    return 'NotificationUserStateRequest{notificationUserId: $notificationUserId, isSent: $isSent}';
  }
}
