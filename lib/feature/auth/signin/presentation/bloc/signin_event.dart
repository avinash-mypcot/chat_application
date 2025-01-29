import 'package:equatable/equatable.dart';

// Base class for SignUp Events
abstract class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object?> get props => [];
}

// Event to handle user signup
class SigninReqEvent extends SigninEvent {


  const SigninReqEvent({
    required this.email,required this.password
  });
final String email;
final String password;
  @override
  List<Object?> get props => [email, password];
}
