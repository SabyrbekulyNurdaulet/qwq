// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsImageImpl _$$NewsImageImplFromJson(Map<String, dynamic> json) =>
    _$NewsImageImpl(
      url: json['url'] as String,
      alt: json['alt'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$$NewsImageImplToJson(_$NewsImageImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'alt': instance.alt,
      'order': instance.order,
    };

_$NewsImpl _$$NewsImplFromJson(Map<String, dynamic> json) => _$NewsImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  authorId: json['authorId'] as String,
  images:
      (json['images'] as List<dynamic>)
          .map((e) => NewsImage.fromJson(e as Map<String, dynamic>))
          .toList(),
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  isPublished: json['isPublished'] as bool,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
  publishedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['publishedAt'],
    const TimestampConverter().fromJson,
  ),
);

Map<String, dynamic> _$$NewsImplToJson(_$NewsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'authorId': instance.authorId,
      'images': instance.images,
      'tags': instance.tags,
      'isPublished': instance.isPublished,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'publishedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.publishedAt,
        const TimestampConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
