// lib/providers/teacher_grades_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/teacher/models/teacher_grades.dart';

// Провайдер для получения оценок, выставленных преподавателем
final teacherGradesProvider = StreamProvider.family<List<TeacherGrade>, String>(
  (ref, teacherId) {
    if (teacherId.isEmpty) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('grades')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return TeacherGrade.fromMap(doc.data(), doc.id);
            } catch (e) {
              print('Error parsing grade ${doc.id}: $e');
              // Возвращаем пустую оценку в случае ошибки
              return TeacherGrade.fromMap({
                'studentId': 'unknown',
                'teacherId': teacherId,
                'teacherName': 'Unknown',
                'groupId': 'unknown',
                'subject': 'Unknown',
                'score': 0,
                'gradeSystem': '5',
                'timestamp': Timestamp.now(),
                'createdAt': Timestamp.now(),
              }, doc.id);
            }
          }).toList();
        });
  },
);

// Провайдер для получения оценок конкретного студента от преподавателя
final studentGradesFromTeacherProvider = StreamProvider.family<
  List<TeacherGrade>,
  ({String teacherId, String studentId})
>((ref, params) {
  if (params.teacherId.isEmpty || params.studentId.isEmpty) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('grades')
      .where('teacherId', isEqualTo: params.teacherId)
      .where('studentId', isEqualTo: params.studentId)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return TeacherGrade.fromMap(doc.data(), doc.id);
          } catch (e) {
            print('Error parsing grade ${doc.id}: $e');
            return TeacherGrade.fromMap({
              'studentId': params.studentId,
              'teacherId': params.teacherId,
              'teacherName': 'Unknown',
              'groupId': 'unknown',
              'subject': 'Unknown',
              'score': 0,
              'gradeSystem': '5',
              'timestamp': Timestamp.now(),
              'createdAt': Timestamp.now(),
            }, doc.id);
          }
        }).toList();
      });
});

// Провайдер для получения статистики оценок преподавателя
final teacherGradesStatsProvider =
    Provider.family<Map<String, dynamic>, String>((ref, teacherId) {
      final gradesAsync = ref.watch(teacherGradesProvider(teacherId));

      return gradesAsync.when(
        data: (grades) {
          if (grades.isEmpty) {
            return {
              'total': 0,
              'avgScore': 0.0,
              'bySubject': <String, int>{},
              'byGradeSystem': <String, int>{},
              'recentCount': 0,
            };
          }

          final bySubject = <String, int>{};
          final byGradeSystem = <String, int>{};
          double totalScore = 0;
          int recentCount = 0;
          final now = DateTime.now();
          final weekAgo = now.subtract(const Duration(days: 7));

          for (final grade in grades) {
            // Подсчет по предметам
            bySubject[grade.subject] = (bySubject[grade.subject] ?? 0) + 1;

            // Подсчет по системам оценок
            byGradeSystem[grade.gradeSystem] =
                (byGradeSystem[grade.gradeSystem] ?? 0) + 1;

            // Общая сумма для среднего балла (нормализуем к 5-балльной системе)
            if (grade.gradeSystem == '5') {
              totalScore += grade.score;
            } else {
              // Конвертируем 100-балльную в 5-балльную для усреднения
              totalScore += (grade.score / 20).clamp(1, 5);
            }

            // Подсчет недавних оценок
            if (grade.timestamp.isAfter(weekAgo)) {
              recentCount++;
            }
          }

          return {
            'total': grades.length,
            'avgScore': totalScore / grades.length,
            'bySubject': bySubject,
            'byGradeSystem': byGradeSystem,
            'recentCount': recentCount,
          };
        },
        loading:
            () => {
              'total': 0,
              'avgScore': 0.0,
              'bySubject': <String, int>{},
              'byGradeSystem': <String, int>{},
              'recentCount': 0,
            },
        error:
            (_, __) => {
              'total': 0,
              'avgScore': 0.0,
              'bySubject': <String, int>{},
              'byGradeSystem': <String, int>{},
              'recentCount': 0,
            },
      );
    });
