import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/model/chat_model.dart';
import '../../data/repository/chat_repository.dart';
import '../../data/repository/firebase_repository.dart';
import '../../data/services/encription_helper.dart';


part 'chat_event.dart';
part 'chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  HomeRepository repository;
  FirebaseRepository firebaseRepository;
  ChatBloc({required this.repository, required this.firebaseRepository})
      : super(ChatInitial()) {
    on<ChatRequest>(_onMassageRequest);
    on<ChatHistory>(_onSetHistoryRequest);
    on<GetTodayChat>(_onGetTodayChat);
    on<NewChatEvent>(_onNewChatEvent);
    on<ImageResponseReq>(_onImageResponse);
  }
  void _onImageResponse(ImageResponseReq event, Emitter<ChatState> emit) async {
    
  }

  _onNewChatEvent(NewChatEvent event, Emitter<ChatState> emit) {
    emit(ChatLoaded(
        isNewChat: true,
        data: ChatModel(
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            candidates: [Candidates(content: Content(parts: []))])));
  }



Stream _onGetTodayChat(GetTodayChat event, Emitter<ChatState> emit) async* {
  emit(ChatLoading());


  try {
    final stream = firebaseRepository.getTodayChatStream(event.isVerified);
    await for (var snapshot in stream) {
      emit(ChatLoaded(data: snapshot));
      // yield ChatLoaded(data: snapshot);
    }
  } catch (e) {
    log("Error: $e");
    emit(ChatException(errorMessage: "Failed to load chat data"));
  }
}



  _onSetHistoryRequest(ChatHistory event, Emitter<ChatState> emit) async {
    emit(ChatLoaded(data: event.model,index:event.index));
  }

  _onMassageRequest(ChatRequest event, Emitter<ChatState> emit) async {
    final encryptionHelper =
        EncryptionHelper('6gHdJ1kLmNoP8b2x', '3xTu9R4dWq8YtZkC');
    Map<String, dynamic> body = {
      "contents": [
        {
          "parts": [
            {"text": event.msg}
          ]
        }
      ]
    };
    final currentState = state;
    if (currentState is ChatLoaded) {
      ChatModel updatedModel =
          currentState.data.copyWith(date: event.date, candidates: [
        currentState.data.candidates![0].copyWith(
            content: currentState.data.candidates![0].content!.copyWith(parts: [
          ...?currentState.data.candidates![0].content!.parts,
          ...[
            Parts(
                isUser: true,
                text: event.msg,
                time: DateFormat('HH:mm').format(DateTime.now()))
          ],
        ]))
      ]);
      emit(ChatLoaded(isNewChat: event.isNewChat, data: updatedModel));
    } else if (currentState is ChatInitial) {
      ChatModel model = ChatModel(date: event.date, candidates: [
        Candidates(
            content: Content(parts: [Parts(isUser: true, text: event.msg)]))
      ]);
      emit(ChatLoaded(isNewChat: event.isNewChat, data: model));
    }
    final currentState1 = state;
    try {
      // ChatModel response = await repository.getInformation(
      //     'AIzaSyDaKc-H4hWesxWJt6ARDVz7rYcBn0ILUQw', body);
      final ChatModel model = ChatModel(candidates: [Candidates(content: Content(parts: [Parts(
            isUser: false,
            text: event.msg,
            time: DateFormat('HH:mm').format(DateTime.now()))]))]);
 final ChatModel updatedModel = ChatModel(candidates: [Candidates(content: Content(parts: [Parts(
            isUser: false,
            text: event.msg,
            time: DateFormat('HH:mm').format(DateTime.now()))]))]);

      if (currentState1 is ChatLoaded) {
        
        // // Store updatedModel in Firebase before emitting the state
        // firebaseRepository.appendPartsToFirestore(
        //     updatedModel, event.date, event.isNewChat);
        // Create an encrypted model only for Firebase storage
        ChatModel encryptedModel = updatedModel.copyWith(candidates: [
          updatedModel.candidates![0].copyWith(
              content: updatedModel.candidates![0].content!.copyWith(parts: [
            for (var part in updatedModel.candidates![0].content!.parts!)
              Parts(
                time: part.time ?? DateFormat('HH:mm:').format(DateTime.now()),
                isUser: part.isUser,
                text: encryptionHelper.encryptText(part.text!),
              )
          ]))
        ]);

        // Append the encrypted model to Firebase
        firebaseRepository.appendPartsToFirestore(
            encryptedModel, event.date, event.isNewChat,event.index);

        // Update Home Widget
        // await _updateHomeWidget(updatedModel);
        log("date ${updatedModel.date}");
        emit(ChatLoaded(
          isNewChat: event.isNewChat,
          data: updatedModel,
        ));
      } else {
        emit(ChatLoaded(data:updatedModel ));
      }
    } catch (e) {
      log("ERROR : $e");
      emit(ChatException(errorMessage: e.toString()));
    }
  }
}
