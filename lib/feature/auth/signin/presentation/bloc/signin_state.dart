
import '../../data/model/signin_model.dart';

abstract class SigninState {
  const SigninState();
}

class SigninInitialState extends SigninState {}

class SigninLoadingState extends SigninState {}

class SigninSuccessState extends SigninState {
  final SigninModel model;
  const SigninSuccessState({required this.model});
}

class SigninFailed extends SigninState {
  final String errorMessage;

  SigninFailed(this.errorMessage);
}

class SigninException extends SigninState {
  final String errorMessage;

  SigninException(this.errorMessage);
}
