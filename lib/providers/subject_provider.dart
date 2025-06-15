import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../services/subject_service.dart';
import '../core/auth_service.dart' as auth;
import '../providers/schedule_provider.dart'; // Исправленный импорт
import '../services/user_service.dart';
import '../models/user.dart';
import '../services/teacher_service.dart';
import '../models/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../providers/user_profile_provider.dart' as profile;

final subjectServiceProvider = Provider((ref) => SubjectService());
final userServiceProvider = Provider((ref) => UserService());
final teacherServiceProvider = Provider((ref) => TeacherService());

final _logger = Logger('SubjectProvider');

// Провайдер для получения всех предметов
final subjectsProvider = StreamProvider.autoDispose<Map<String, Subject>>((
  ref,
) {
  return FirebaseFirestore.instance.collection('subjects').snapshots().map((
    snapshot,
  ) {
    final subjects = <String, Subject>{};
    for (final doc in snapshot.docs) {
      try {
        subjects[doc.id] = Subject.fromJson(doc.data());
      } catch (e, stack) {
        _logger.severe('Error parsing subject ${doc.id}', e, stack);
      }
    }
    return subjects;
  });
});

// Провайдер для получения предмета по ID
final subjectByIdProvider = Provider.family<Subject?, String>((ref, subjectId) {
  final subjects = ref.watch(subjectsProvider);
  return subjects.when(
    data: (subjectsMap) => subjectsMap[subjectId],
    loading: () => null,
    error: (_, __) => null,
  );
});

// Провайдер для предметов текущего преподавателя
final teacherSubjectsProvider =
    StreamProvider.autoDispose<Map<String, Subject>>((ref) {
      final authState = ref.watch(auth.authStateProvider);
      final user = authState.valueOrNull;

      if (user == null) {
        _logger.info('No user found');
        return Stream.value({});
      }

      return FirebaseFirestore.instance
          .collection('subjects')
          .where('teacherId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
            final subjects = <String, Subject>{};
            for (final doc in snapshot.docs) {
              try {
                subjects[doc.id] = Subject.fromJson(doc.data());
              } catch (e, stack) {
                _logger.severe('Error parsing subject ${doc.id}', e, stack);
              }
            }
            return subjects;
          });
    });

// Провайдер для предметов текущей группы
final groupSubjectsProvider = StreamProvider.autoDispose<List<Subject>>((ref) {
  final user = ref.watch(auth.authStateProvider).valueOrNull;
  if (user?.groupId == null) return Stream.value([]);

  final subjectService = ref.watch(subjectServiceProvider);
  return subjectService.getSubjectsByGroup(user!.groupId!);
});

// ИСПРАВЛЕННЫЙ провайдер для получения предметов из расписания
final scheduleSubjectsProvider = Provider.autoDispose<Map<String, Subject>>((
  ref,
) {
  final subjectsAsync = ref.watch(subjectsProvider);
  return subjectsAsync.when(
    data: (subjects) => subjects,
    loading: () => {},
    error: (_, __) => {},
  );
});

// Альтернативный провайдер, если нужно использовать все предметы
final scheduleSubjectsFromAllProvider =
    FutureProvider.autoDispose<Map<String, Subject>>((ref) async {
      final allSubjectsAsync = ref.watch(subjectsProvider);

      return allSubjectsAsync.when(
        data: (allSubjects) => allSubjects,
        loading: () => <String, Subject>{},
        error: (error, stack) {
          print('Error loading all subjects: $error');
          return <String, Subject>{};
        },
      );
    });

// Кэш для хранения загруженных предметов
final _subjectsCache = <String, Subject>{};

// Провайдер для получения предметов по списку ID
final subjectsMapProvider = FutureProvider.autoDispose
    .family<Map<String, Subject>, List<String>>((ref, ids) async {
      if (ids.isEmpty) return {};
      final subjectService = ref.watch(subjectServiceProvider);
      try {
        return await subjectService.getSubjectsByIds(ids);
      } catch (e) {
        print('Error loading subjects by IDs: $e');
        return {};
      }
    });

// Провайдер для получения имени учителя по teacherId
final teacherNameProvider = FutureProvider.family<String, String>((
  ref,
  teacherId,
) async {
  if (teacherId.isEmpty) return 'Не указан';

  try {
    final teacherService = ref.read(teacherServiceProvider);
    final userService = ref.read(userServiceProvider);
    final teacher = await teacherService.getTeacherById(teacherId);
    if (teacher == null || teacher.userId.isEmpty) return 'Не указан';
    final user = await userService.getUserById(teacher.userId);
    return user?.fullName ?? 'Не указан';
  } catch (e) {
    print('Error loading teacher name: $e');
    return 'Ошибка загрузки';
  }
});

// Провайдер для получения предметов студента
final studentSubjectsProvider =
    StreamProvider.autoDispose<Map<String, Subject>>((ref) {
      final userProfile = ref.watch(profile.userProfileProvider);

      return userProfile.when(
        loading: () => Stream.value({}),
        error: (error, stack) {
          _logger.severe('Error loading user profile', error, stack);
          return Stream.value({});
        },
        data: (user) {
          if (user == null || user.groupId == null) {
            _logger.info('No user or groupId found');
            return Stream.value({});
          }

          return FirebaseFirestore.instance
              .collection('subjects')
              .where('groups', arrayContains: user.groupId)
              .snapshots()
              .map((snapshot) {
                final subjects = <String, Subject>{};
                for (final doc in snapshot.docs) {
                  try {
                    subjects[doc.id] = Subject.fromJson(doc.data());
                  } catch (e, stack) {
                    _logger.severe('Error parsing subject ${doc.id}', e, stack);
                  }
                }
                return subjects;
              });
        },
      );
    });

final subjectProvider = FutureProvider.family<Subject?, String>((
  ref,
  subjectId,
) async {
  final subjectService = ref.watch(subjectServiceProvider);
  return subjectService.getSubject(subjectId);
});
