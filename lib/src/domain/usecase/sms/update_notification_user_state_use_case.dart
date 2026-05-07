import 'package:sms_sender/src/core/resources/data_state.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/notification_user_state_request.dart';
import 'package:sms_sender/src/domain/entities/sms/message_response.dart';
import 'package:sms_sender/src/domain/repositories/sms/sms_repository.dart';

class UpdateNotificationUserStateUseCase {
  final SMSRepository smsRepository;

  UpdateNotificationUserStateUseCase({
    required this.smsRepository,
  });

  Future<DataState<MessageResponse>> call({
    required NotificationUserStateRequest request,
  }) async {
    return await smsRepository.updateNotificationUserState(request: request);
  }
}
