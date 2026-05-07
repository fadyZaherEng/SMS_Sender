// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_sms_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestSmsNotification _$RequestSmsNotificationFromJson(
        Map<String, dynamic> json) =>
    RequestSmsNotification(
      subscriberId: (json['subscriberId'] as num?)?.toInt(),
      compoundId: (json['compoundId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RequestSmsNotificationToJson(
        RequestSmsNotification instance) =>
    <String, dynamic>{
      'subscriberId': instance.subscriberId,
      'compoundId': instance.compoundId,
    };
