part of 'code_verification_bloc.dart';

abstract class CodeVerificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VerifyCode extends CodeVerificationEvent {
  final String code;

  VerifyCode(this.code);

  @override
  List<Object> get props => [code];
}
