part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatLoaded extends ChatState {
  const ChatLoaded({required this.data,this.isNewChat=false,this.index=0});
  final ChatModel data;
  final bool isNewChat;
  final int index;
  @override
  List<Object> get props => [data,isNewChat,index];
}

class ChatException extends ChatState {
  const ChatException({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
