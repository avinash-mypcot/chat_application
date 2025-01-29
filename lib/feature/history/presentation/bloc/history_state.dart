part of 'history_bloc.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded({required this.model});
  final HistoryModel model;

  @override
  List<Object> get props => [model];
}

class HistoryFailed extends HistoryState {
  const HistoryFailed({required this.msg});
  final String msg;
  @override
  List<Object> get props => [msg];
}

class HistoryException extends HistoryState {
  const HistoryException({required this.msg});
  final String msg;
  @override
  List<Object> get props => [msg];
}