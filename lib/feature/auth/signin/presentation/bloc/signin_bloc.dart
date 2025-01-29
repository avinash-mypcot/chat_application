import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/signin_repository.dart';
import 'signin_event.dart';
import 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SigninRepository _repository;
  SigninBloc(this._repository) : super(SigninInitialState()) {
    on<SigninReqEvent>(_onSigninReqEvent);
  }
  _onSigninReqEvent(SigninReqEvent event, Emitter<SigninState> emit) async {
    emit(SigninLoadingState());
    try {
      final response = await _repository
          .signinReq({"email": event.email, "password": event.password});
      log("Success Log in");
      emit(SigninSuccessState(model: response));
    } catch (e) {
      emit(SigninFailed(e.toString()));
    }
  }
}
