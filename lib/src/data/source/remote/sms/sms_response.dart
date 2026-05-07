import 'package:json_annotation/json_annotation.dart';

part 'sms_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SMSResponse<T> {
  @JsonKey(name: 'statusCode')
  int? statusCode;
  @JsonKey(name: 'requestId')
  String? requestId;
  @JsonKey(name: 'error')
  List<String>? error;
  @JsonKey(name: 'success')
  bool? success;
  @JsonKey(name: 'responseMessage')
  String? responseMessage;
  @JsonKey(name: 'result')
  T? result;

  SMSResponse({
    this.statusCode,
    this.requestId,
    this.error,
    this.success,
    this.responseMessage,
    this.result,
  });

  factory SMSResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$SMSResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Function(dynamic value) value) =>
      _$SMSResponseToJson(this, (T) {
        return T;
      });
}
