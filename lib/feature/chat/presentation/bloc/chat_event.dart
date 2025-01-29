part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatRequest extends ChatEvent {
  const ChatRequest({required this.msg, required this.date,this.isNewChat=false,required this.index});
  final String msg;
  final String date;
  final bool isNewChat;
  final int index;

  @override
  List<Object> get props => [msg,date,isNewChat,index];
}

class ChatHistory extends ChatEvent {
  const ChatHistory({required this.model,required this.index});
  final ChatModel model;
  final int index;

  @override
  List<Object> get props => [model,index];
}

class GetTodayChat extends ChatEvent {
  final bool isVerified;
  const GetTodayChat({required this.isVerified});
  @override
  List<Object> get props => [isVerified];
}

class NewChatEvent extends ChatEvent {
  const NewChatEvent();

  @override
  List<Object> get props => [];
}
class ImageResponseReq extends ChatEvent {
  final String imagePath;
  final String imageUrl;
  final String msg;
  final String mimeType;
  final String date;
  final bool isNewChat;
  final int index;
  const ImageResponseReq({required this.imagePath,required this.imageUrl, required this.msg,required this.mimeType,required this.date,required this.isNewChat,required this.index});

  @override
  List<Object> get props => [imageUrl, msg,mimeType,imagePath,date,isNewChat];
}
