part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileGetEvent extends ProfileEvent {
  const ProfileGetEvent();
  @override
  List<Object> get props => [];
}

class ProfileUpdateEvent extends ProfileEvent {
  const ProfileUpdateEvent({required this.username,required this.mobile,required this.email});
  final String username;
  final String mobile;
  final String email;

  @override
  List<Object> get props => [username, mobile, email];
}
