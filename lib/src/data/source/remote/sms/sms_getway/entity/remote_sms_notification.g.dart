// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_sms_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteSmsNotification _$RemoteSmsNotificationFromJson(
        Map<String, dynamic> json) =>
    RemoteSmsNotification(
      notificationUserId: (json['notificationUserId'] as num?)?.toInt(),
      destination: json['destination'] as String?,
      body: json['body'] as String?,
    );

Map<String, dynamic> _$RemoteSmsNotificationToJson(
        RemoteSmsNotification instance) =>
    <String, dynamic>{
      'notificationUserId': instance.notificationUserId,
      'destination': instance.destination,
      'body': instance.body,
    };
