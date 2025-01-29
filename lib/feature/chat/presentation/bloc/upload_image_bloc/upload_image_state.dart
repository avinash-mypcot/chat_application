part of 'upload_image_bloc.dart';

sealed class UploadImageState extends Equatable {
  const UploadImageState();

  @override
  List<Object> get props => [];
}

final class UploadImageInitial extends UploadImageState {}

class UploadImageLoading extends UploadImageState {}

class UploadImageSuccess extends UploadImageState {
  final UploadImageModel model;

  const UploadImageSuccess({required this.model});
  @override
  List<Object> get props => [model];
}

class UploadImageFailureState extends UploadImageState {
  final String error;
  const UploadImageFailureState({required this.error});
}

class UploadImageExceptionState extends UploadImageState {
  final String error;
  const UploadImageExceptionState({required this.error});
}
