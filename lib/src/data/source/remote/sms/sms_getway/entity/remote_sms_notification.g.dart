// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_sms_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteSmsNotification _$RemoteSmsNotificationFromJson(
        Map<String, dynamic> json) =>
    RemoteSmsNotification(
      NotificationUserId: (json['NotificationUserId'] as num?)?.toInt(),
      Destination: json['Destination'] as String?,
      Body: json['Body'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$RemoteSmsNotificationToJson(
        RemoteSmsNotification instance) =>
    <String, dynamic>{
      'NotificationUserId': instance.NotificationUserId,
      'Destination': instance.Destination,
      'Body': instance.Body,
      'message': instance.message,
    };
