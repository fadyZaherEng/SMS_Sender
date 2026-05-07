import 'package:sms_sender/src/core/resources/data_state.dart';
import 'package:sms_sender/src/data/source/remote/sms/sms_getway/request/bulk_notification_user_state_request.dart';
import 'package:sms_sender/src/domain/entities/sms/message_response.dart';
import 'package:sms_sender/src/domain/repositories/sms/sms_repository.dart';

class BulkUpdateNotificationUserStateUseCase {
  final SMSRepository smsRepository;

  BulkUpdateNotificationUserStateUseCase({
    required this.smsRepository,
  });

  Future<DataState<MessageResponse>> call({
    required BulkNotificationUserStateRequest request,
  }) async {
    return await smsRepository.bulkUpdateNotificationUserState(request: request);
  }
}
