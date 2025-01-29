part of 'code_verification_bloc.dart';

abstract class CodeVerificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class CodeInitial extends CodeVerificationState {}

class CodeVerifying extends CodeVerificationState {}

class CodeVerified extends CodeVerificationState {}

class CodeVerificationFailed extends CodeVerificationState {
  final String error;

  CodeVerificationFailed(this.error);

  @override
  List<Object> get props => [error];
}
