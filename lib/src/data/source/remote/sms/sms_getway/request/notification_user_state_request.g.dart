// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_user_state_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationUserStateRequest _$NotificationUserStateRequestFromJson(
        Map<String, dynamic> json) =>
    NotificationUserStateRequest(
      notificationUserId: (json['notificationUserId'] as num?)?.toInt(),
      isSent: json['isSent'] as bool?,
    );

Map<String, dynamic> _$NotificationUserStateRequestToJson(
        NotificationUserStateRequest instance) =>
    <String, dynamic>{
      'notificationUserId': instance.notificationUserId,
      'isSent': instance.isSent,
    };
