// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_notification_user_state_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkNotificationUserStateRequest _$BulkNotificationUserStateRequestFromJson(
        Map<String, dynamic> json) =>
    BulkNotificationUserStateRequest(
      notificationUsers: (json['notificationUsers'] as List<dynamic>?)
          ?.map((e) =>
              NotificationUserStateRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BulkNotificationUserStateRequestToJson(
        BulkNotificationUserStateRequest instance) =>
    <String, dynamic>{
      'notificationUsers': instance.notificationUsers,
    };
