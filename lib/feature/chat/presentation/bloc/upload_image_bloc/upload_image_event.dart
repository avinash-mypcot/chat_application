part of 'upload_image_bloc.dart';

sealed class UploadImageEvent extends Equatable {
  const UploadImageEvent();

  @override
  List<Object> get props => [];
}

class UploadImageToGemini extends UploadImageEvent {
  final String? image;
  
  const UploadImageToGemini({required this.image});

  @override
  List<Object> get props =>[image!];
}

