import 'package:json_annotation/json_annotation.dart';

part 'sms_request.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SMSRequest<T> {
  @JsonKey(name: 'data')
  T? data;

  SMSRequest({this.data});

  factory SMSRequest.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$SMSRequestFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Function(dynamic value) value) =>
      _$SMSRequestToJson(this, (T) {
        return T;
      });

  SMSRequest<T> createRequest(T) {
    return SMSRequest(data: T);
  }

  Map<String, dynamic> toMap() {
    return {'data': data};
  }

  factory SMSRequest.fromMap(Map<String, dynamic> map) {
    return SMSRequest(data: map['data'] as T);
  }

  SMSRequest<T> copyWith({
    int? subscriberId,
    int? compoundId,
  }) {
    return SMSRequest(data: data);
  }
}
