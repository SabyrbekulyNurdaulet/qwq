import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher.freezed.dart';
part 'teacher.g.dart';

@freezed
class Teacher with _$Teacher {
  const factory Teacher({
    required String id,
    required String userId,
    String? education,
    int? experience,
    String? specialization,
    List<String>? groups,
    List<String>? subjects,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Teacher;

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);
}
