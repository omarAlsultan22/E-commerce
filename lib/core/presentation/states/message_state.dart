import 'package:international_cuisine/core/data/models/message_result.dart';


class MessageState {
  final MessageResult? messageResult;

  const MessageState({
    this.messageResult
  });

  factory MessageState.initial(){
    return const MessageState(messageResult: null);
  }
}