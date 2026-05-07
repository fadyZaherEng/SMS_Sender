import 'package:json_annotation/json_annotation.dart';
import 'package:sms_sender/src/domain/entities/sms/message_response.dart';

part 'remote_message_response.g.dart';

@JsonSerializable()
class RemoteMessageResponse {
  @JsonKey(name: 'message')
  final String? message;

  const RemoteMessageResponse({
    this.message,
  });

  factory RemoteMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$RemoteMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteMessageResponseToJson(this);
}

extension RemoteMessageResponseExtension on RemoteMessageResponse? {
  MessageResponse mapToDomain() {
    return MessageResponse(
      message: this?.message ?? '',
    );
  }
}
