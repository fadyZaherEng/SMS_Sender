// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_sms_notifications_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteSmsNotificationsResponse _$RemoteSmsNotificationsResponseFromJson(
        Map<String, dynamic> json) =>
    RemoteSmsNotificationsResponse(
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map(
              (e) => RemoteSmsNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$RemoteSmsNotificationsResponseToJson(
        RemoteSmsNotificationsResponse instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'message': instance.message,
    };
