
import '../../../chat/data/model/chat_model.dart';

class HistoryModel {
  final List<Data>? data;

  HistoryModel({
    this.data,
  });

  HistoryModel copyWith({
    List<Data>? data,
  }) {
    return HistoryModel(
      data: data ?? this.data,
    );
  }

  HistoryModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'data': data?.map((e) => e.toJson()).toList()};
}

class Data {
  final Date? date;

  Data({
    this.date,
  });

  Data copyWith({
    Date? date,
  }) {
    return Data(
      date: date ?? this.date,
    );
  }

  Data.fromJson(Map<String, dynamic> json)
      : date = (json['date'] as Map<String, dynamic>?) != null
            ? Date.fromJson(json['date'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'date': date?.toJson()};
}

class Date {
  final List<ChatModel>? chats;

  Date({
    this.chats,
  });

  Date copyWith({
    List<ChatModel>? chats,
  }) {
    return Date(
      chats: chats ?? this.chats,
    );
  }

  Date.fromJson(Map<String, dynamic> json) : chats = json['chats'] as List<ChatModel>?;

  Map<String, dynamic> toJson() => {'chats': chats};
}
