// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NewsImage _$NewsImageFromJson(Map<String, dynamic> json) {
  return _NewsImage.fromJson(json);
}

/// @nodoc
mixin _$NewsImage {
  String get url => throw _privateConstructorUsedError;
  String get alt => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this NewsImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsImageCopyWith<NewsImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsImageCopyWith<$Res> {
  factory $NewsImageCopyWith(NewsImage value, $Res Function(NewsImage) then) =
      _$NewsImageCopyWithImpl<$Res, NewsImage>;
  @useResult
  $Res call({String url, String alt, int order});
}

/// @nodoc
class _$NewsImageCopyWithImpl<$Res, $Val extends NewsImage>
    implements $NewsImageCopyWith<$Res> {
  _$NewsImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? alt = null, Object? order = null}) {
    return _then(
      _value.copyWith(
            url:
                null == url
                    ? _value.url
                    : url // ignore: cast_nullable_to_non_nullable
                        as String,
            alt:
                null == alt
                    ? _value.alt
                    : alt // ignore: cast_nullable_to_non_nullable
                        as String,
            order:
                null == order
                    ? _value.order
                    : order // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NewsImageImplCopyWith<$Res>
    implements $NewsImageCopyWith<$Res> {
  factory _$$NewsImageImplCopyWith(
    _$NewsImageImpl value,
    $Res Function(_$NewsImageImpl) then,
  ) = __$$NewsImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String alt, int order});
}

/// @nodoc
class __$$NewsImageImplCopyWithImpl<$Res>
    extends _$NewsImageCopyWithImpl<$Res, _$NewsImageImpl>
    implements _$$NewsImageImplCopyWith<$Res> {
  __$$NewsImageImplCopyWithImpl(
    _$NewsImageImpl _value,
    $Res Function(_$NewsImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NewsImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? alt = null, Object? order = null}) {
    return _then(
      _$NewsImageImpl(
        url:
            null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                    as String,
        alt:
            null == alt
                ? _value.alt
                : alt // ignore: cast_nullable_to_non_nullable
                    as String,
        order:
            null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsImageImpl implements _NewsImage {
  const _$NewsImageImpl({
    required this.url,
    required this.alt,
    required this.order,
  });

  factory _$NewsImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsImageImplFromJson(json);

  @override
  final String url;
  @override
  final String alt;
  @override
  final int order;

  @override
  String toString() {
    return 'NewsImage(url: $url, alt: $alt, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsImageImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.alt, alt) || other.alt == alt) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, alt, order);

  /// Create a copy of NewsImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsImageImplCopyWith<_$NewsImageImpl> get copyWith =>
      __$$NewsImageImplCopyWithImpl<_$NewsImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsImageImplToJson(this);
  }
}

abstract class _NewsImage implements NewsImage {
  const factory _NewsImage({
    required final String url,
    required final String alt,
    required final int order,
  }) = _$NewsImageImpl;

  factory _NewsImage.fromJson(Map<String, dynamic> json) =
      _$NewsImageImpl.fromJson;

  @override
  String get url;
  @override
  String get alt;
  @override
  int get order;

  /// Create a copy of NewsImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsImageImplCopyWith<_$NewsImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

News _$NewsFromJson(Map<String, dynamic> json) {
  return _News.fromJson(json);
}

/// @nodoc
mixin _$News {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  List<NewsImage> get images => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isPublished => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  /// Serializes this News to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsCopyWith<News> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsCopyWith<$Res> {
  factory $NewsCopyWith(News value, $Res Function(News) then) =
      _$NewsCopyWithImpl<$Res, News>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String authorId,
    List<NewsImage> images,
    List<String> tags,
    bool isPublished,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    @TimestampConverter() DateTime? publishedAt,
  });
}

/// @nodoc
class _$NewsCopyWithImpl<$Res, $Val extends News>
    implements $NewsCopyWith<$Res> {
  _$NewsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? authorId = null,
    Object? images = null,
    Object? tags = null,
    Object? isPublished = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? publishedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String,
            authorId:
                null == authorId
                    ? _value.authorId
                    : authorId // ignore: cast_nullable_to_non_nullable
                        as String,
            images:
                null == images
                    ? _value.images
                    : images // ignore: cast_nullable_to_non_nullable
                        as List<NewsImage>,
            tags:
                null == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            isPublished:
                null == isPublished
                    ? _value.isPublished
                    : isPublished // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            publishedAt:
                freezed == publishedAt
                    ? _value.publishedAt
                    : publishedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NewsImplCopyWith<$Res> implements $NewsCopyWith<$Res> {
  factory _$$NewsImplCopyWith(
    _$NewsImpl value,
    $Res Function(_$NewsImpl) then,
  ) = __$$NewsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String authorId,
    List<NewsImage> images,
    List<String> tags,
    bool isPublished,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    @TimestampConverter() DateTime? publishedAt,
  });
}

/// @nodoc
class __$$NewsImplCopyWithImpl<$Res>
    extends _$NewsCopyWithImpl<$Res, _$NewsImpl>
    implements _$$NewsImplCopyWith<$Res> {
  __$$NewsImplCopyWithImpl(_$NewsImpl _value, $Res Function(_$NewsImpl) _then)
    : super(_value, _then);

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? authorId = null,
    Object? images = null,
    Object? tags = null,
    Object? isPublished = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? publishedAt = freezed,
  }) {
    return _then(
      _$NewsImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
        authorId:
            null == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                    as String,
        images:
            null == images
                ? _value._images
                : images // ignore: cast_nullable_to_non_nullable
                    as List<NewsImage>,
        tags:
            null == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        isPublished:
            null == isPublished
                ? _value.isPublished
                : isPublished // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        publishedAt:
            freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsImpl implements _News {
  const _$NewsImpl({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required final List<NewsImage> images,
    required final List<String> tags,
    required this.isPublished,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
    @TimestampConverter() this.publishedAt,
  }) : _images = images,
       _tags = tags;

  factory _$NewsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final String authorId;
  final List<NewsImage> _images;
  @override
  List<NewsImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final bool isPublished;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  @TimestampConverter()
  final DateTime? publishedAt;

  @override
  String toString() {
    return 'News(id: $id, title: $title, content: $content, authorId: $authorId, images: $images, tags: $tags, isPublished: $isPublished, createdAt: $createdAt, updatedAt: $updatedAt, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    content,
    authorId,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_tags),
    isPublished,
    createdAt,
    updatedAt,
    publishedAt,
  );

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsImplCopyWith<_$NewsImpl> get copyWith =>
      __$$NewsImplCopyWithImpl<_$NewsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsImplToJson(this);
  }
}

abstract class _News implements News {
  const factory _News({
    required final String id,
    required final String title,
    required final String content,
    required final String authorId,
    required final List<NewsImage> images,
    required final List<String> tags,
    required final bool isPublished,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
    @TimestampConverter() final DateTime? publishedAt,
  }) = _$NewsImpl;

  factory _News.fromJson(Map<String, dynamic> json) = _$NewsImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  String get authorId;
  @override
  List<NewsImage> get images;
  @override
  List<String> get tags;
  @override
  bool get isPublished;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  @TimestampConverter()
  DateTime? get publishedAt;

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsImplCopyWith<_$NewsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
