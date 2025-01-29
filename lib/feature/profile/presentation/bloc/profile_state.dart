part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
  @override
  List<Object> get props => [];
}

class ProfileLoadedState extends ProfileState {
  final ProfileModel model;
  final bool isUpdate;
  const ProfileLoadedState({required this.model, this.isUpdate = false});

  @override
  List<Object> get props => [model, isUpdate];
}

class ProfileFailedState extends ProfileState {
  const ProfileFailedState();
  @override
  List<Object> get props => [];
}
