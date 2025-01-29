import 'package:equatable/equatable.dart';

// Base class for SignUp Events
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

// Event to handle user signup
class SignupReqEvent extends SignUpEvent {


  const SignupReqEvent({
    required this.email,required this.password
  });
final String email;
final String password;
  @override
  List<Object?> get props => [email, password];
}

