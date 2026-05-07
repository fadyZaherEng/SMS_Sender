import 'package:equatable/equatable.dart';

class MessageResponse extends Equatable {
  final String message;

  const MessageResponse({
    this.message='',
  });

  @override
  List<Object?> get props => [message];
}
