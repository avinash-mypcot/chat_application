import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/utils.dart';
import '../../data/model/chat_model.dart';
import '../../data/repository/chat_repository.dart';
import '../../data/repository/firebase_repository.dart';
import '../../data/services/encription_helper.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';
part 'chat_state.dart';
// https://generativelanguage.googleapis.com/v1beta/files/56qyegb7ljfa
Future<void> _updateHomeWidget(ChatModel chatModel) async {
  // Extract the latest message
  final latestMessage =
      chatModel.candidates?[0].content?.parts?.last.text ?? '';
  // Save the latest message in SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('latest_message', latestMessage);
  final msgStore = await prefs.getString('latest_message');
  await prefs.reload();
  // Update Home Widget data
  log("Response $msgStore");
  await HomeWidget.saveWidgetData<String>('latest_message', latestMessage);

  // Trigger the widget update
  final res = await HomeWidget.updateWidget(
    name: 'MyWidgetProvider1',
    androidName: 'MyWidgetProvider1',
  );
  log("Response $res");
}

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
    final body = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "fileData": {
                "fileUri": event.imageUrl,
                "mimeType": event.mimeType,
              }
            }
          ]
        },
        {
          "role": "model",
          "parts": [
            {"text": event.msg}
          ]
        }
      ]
    };

    final encryptionHelper =
        EncryptionHelper('6gHdJ1kLmNoP8b2x', '3xTu9R4dWq8YtZkC');
    final base64ImageData =
        await AppUtils.convertImageToBase64(event.imagePath);

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
                base64Image: base64ImageData,
                time: DateFormat('HH:mm').format(DateTime.now()))
          ],
        ]))
      ]);
      log("date1 ${updatedModel.date}");
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
      ChatModel response = await repository.getInformation(
          'AIzaSyDaKc-H4hWesxWJt6ARDVz7rYcBn0ILUQw', body);
      final cont = response.candidates![0].content!.copyWith(parts: [
        Parts(
            isUser: false,
            text: response.candidates![0].content!.parts![0].text,
            time: DateFormat('HH:mm').format(DateTime.now()))
      ]);
      final candi = response.candidates![0].copyWith(content: cont);
      response = response.copyWith(candidates: [candi]);
      if (currentState1 is ChatLoaded) {
        ChatModel updatedModel =
            currentState1.data.copyWith(date: event.date, candidates: [
          currentState1.data.candidates![0].copyWith(
              content:
                  currentState1.data.candidates![0].content!.copyWith(parts: [
            ...?currentState1.data.candidates![0].content!.parts,
            ...response.candidates![0].content!.parts!,
          ]))
        ]);
        // // Store updatedModel in Firebase before emitting the state
        // firebaseRepository.appendPartsToFirestore(
        //     updatedModel, event.date, event.isNewChat);
        // Create an encrypted model only for Firebase storage
        ChatModel encryptedModel = updatedModel.copyWith(candidates: [
          updatedModel.candidates![0].copyWith(
              content: updatedModel.candidates![0].content!.copyWith(parts: [
            for (var part in updatedModel.candidates![0].content!.parts!)
              Parts(
                time: part.time ?? DateFormat('HH:mm').format(DateTime.now()),
                base64Image: part.base64Image,
                isUser: part.isUser,
                text: encryptionHelper.encryptText(part.text!),
              )
          ]))
        ]);

        // Append the encrypted model to Firebase
        firebaseRepository.appendPartsToFirestore(
            encryptedModel, event.date, event.isNewChat,0);

        log("date ${updatedModel.date}");
        emit(ChatLoaded(
          isNewChat: event.isNewChat,
          data: updatedModel,
        ));
      } else {
        emit(ChatLoaded(data: response));
      }
    } catch (e) {
      log("ERROR : $e");
      emit(ChatException(errorMessage: e.toString()));
    }
  }

  _onNewChatEvent(NewChatEvent event, Emitter<ChatState> emit) {
    emit(ChatLoaded(
        isNewChat: true,
        data: ChatModel(
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            candidates: [Candidates(content: Content(parts: []))])));
  }

  Future<void> _onGetTodayChat(
      GetTodayChat event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());
      final res = await firebaseRepository.getTodayChat(event.isVerified);
      // // log(res.candidates![0].content!.parts!.first.base64Image!);
      emit(ChatLoaded(data: res));
    } catch (e) {
      log("Error: $e");
      // emit(ChatError(message: "Failed to load chat data"));
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
      log("date1 ${updatedModel.date}");
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
      ChatModel response = await repository.getInformation(
          'AIzaSyDaKc-H4hWesxWJt6ARDVz7rYcBn0ILUQw', body);

      final cont = response.candidates![0].content!.copyWith(parts: [
        Parts(
            isUser: false,
            text: response.candidates![0].content!.parts![0].text,
            time: DateFormat('HH:mm').format(DateTime.now()))
      ]);
      final candi = response.candidates![0].copyWith(content: cont);
      response = response.copyWith(candidates: [candi]);
      if (currentState1 is ChatLoaded) {
        ChatModel updatedModel =
            currentState1.data.copyWith(date: event.date, candidates: [
          currentState1.data.candidates![0].copyWith(
              content:
                  currentState1.data.candidates![0].content!.copyWith(parts: [
            ...?currentState1.data.candidates![0].content!.parts,
            ...response.candidates![0].content!.parts!,
          ]))
        ]);
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
        await _updateHomeWidget(updatedModel);
        log("date ${updatedModel.date}");
        emit(ChatLoaded(
          isNewChat: event.isNewChat,
          data: updatedModel,
        ));
      } else {
        emit(ChatLoaded(data: response));
      }
    } catch (e) {
      log("ERROR : $e");
      emit(ChatException(errorMessage: e.toString()));
    }
  }
}
