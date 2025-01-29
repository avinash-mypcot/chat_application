
import '../../data/model/signup_model.dart';

abstract class SignUpState {
  const SignUpState();
}

class SignUpInitialState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {
  const SignUpSuccessState({required this.model});
  final SignUpModel model;
}

class SignUpFailed extends SignUpState {
  final String errorMessage;

  SignUpFailed(this.errorMessage);
}
class SignUpException extends SignUpState {
  final String errorMessage;

  SignUpException(this.errorMessage);
}

