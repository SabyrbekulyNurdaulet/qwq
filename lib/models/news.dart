import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'news.freezed.dart';
part 'news.g.dart';

@freezed
class NewsImage with _$NewsImage {
  const factory NewsImage({
    required String url,
    required String alt,
    required int order,
  }) = _NewsImage;

  factory NewsImage.fromJson(Map<String, dynamic> json) =>
      _$NewsImageFromJson(json);
}

@freezed
class News with _$News {
  const factory News({
    required String id,
    required String title,
    required String content,
    required String authorId,
    required List<NewsImage> images,
    required List<String> tags,
    required bool isPublished,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    @TimestampConverter() DateTime? publishedAt,
  }) = _News;

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
