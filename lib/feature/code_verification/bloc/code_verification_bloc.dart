import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'code_verification_event.dart';
part 'code_verification_state.dart';

class CodeVerificationBloc extends Bloc<CodeVerificationEvent, CodeVerificationState> {
  CodeVerificationBloc() : super(CodeInitial()){
    on<VerifyCode>(mapEventToState);
  }

  void mapEventToState(VerifyCode event,Emitter<CodeVerificationState> emit) async{
    emit(CodeVerifying());
    
      if (event.code == "12345") {  // Replace with actual logic
      emit(CodeVerified());
      } else {
        emit( CodeVerificationFailed("Invalid Code"));
      }
    
  }
}
