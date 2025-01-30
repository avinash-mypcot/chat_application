
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/signup_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepository _repository;
  SignUpBloc(this._repository) : super(SignUpInitialState()) {
    on<SignupReqEvent>(_onSignup);
  }
  _onSignup(SignupReqEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    try {
      final body = {"email": event.email, "password": event.password};
      final response = await _repository.signUpReq(body);
      
      emit(SignUpSuccessState(model: response));
    } catch (e) {
      emit(SignUpException(e.toString()));
    }
  }
}
