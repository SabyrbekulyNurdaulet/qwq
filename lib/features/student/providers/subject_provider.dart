import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycollege/models/subject.dart';
import 'package:mycollege/providers/user_profile_provider.dart';
import 'package:mycollege/services/subject_service.dart';
import 'package:mycollege/services/teacher_service.dart';
import 'package:mycollege/services/user_service.dart';

final subjectServiceProvider = Provider((ref) => SubjectService());
final userServiceProvider = Provider((ref) => UserService());
final teacherServiceProvider = Provider((ref) => TeacherService());

// Провайдер для получения всех предметов
final subjectsProvider = StreamProvider<Map<String, Subject>>((ref) {
  return FirebaseFirestore.instance.collection('subjects').snapshots().map((
    snapshot,
  ) {
    final subjects = <String, Subject>{};
    for (var doc in snapshot.docs) {
      try {
        subjects[doc.id] = Subject.fromJson({...doc.data(), 'id': doc.id});
      } catch (e) {
        print('Error parsing subject ${doc.id}: $e');
        // Пропускаем некорректные документы
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
final teacherSubjectsProvider = StreamProvider.autoDispose<List<Subject>>((
  ref,
) {
  final subjectService = ref.watch(subjectServiceProvider);
  return subjectService.getSubjectsByTeacher(
    ref.watch(userProfileProvider).valueOrNull?.uid ?? '',
  );
});

// Провайдер для предметов текущей группы
final groupSubjectsProvider = StreamProvider.autoDispose<List<Subject>>((ref) {
  final user = ref.watch(userProfileProvider).valueOrNull;
  if (user?.groupId == null) return Stream.value([]);

  final subjectService = ref.watch(subjectServiceProvider);
  return subjectService.getSubjectsByGroup(user!.groupId!);
});

// Провайдер для получения имени учителя по teacherId
final teacherNameProvider = FutureProvider.family<String, String>((
  ref,
  teacherId,
) async {
  print('DEBUG: Loading teacher name for teacherId: $teacherId');

  if (teacherId.isEmpty) {
    print('DEBUG: teacherId is empty');
    return 'Не указан';
  }

  try {
    // Ищем пользователя напрямую в коллекции users
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(teacherId)
            .get();

    if (!doc.exists) {
      print('DEBUG: User not found for teacherId: $teacherId');
      return 'Преподаватель не найден';
    }

    final data = doc.data();
    if (data == null) {
      print('DEBUG: User data is null for teacherId: $teacherId');
      return 'Данные не найдены';
    }

    // Попробуем разные варианты имени
    String name = '';

    // Вариант 1: fullName
    if (data['fullName'] != null && data['fullName'].toString().isNotEmpty) {
      name = data['fullName'].toString();
    }
    // Вариант 2: firstName + lastName
    else {
      final firstName = data['firstName']?.toString() ?? '';
      final lastName = data['lastName']?.toString() ?? '';
      final middleName = data['middleName']?.toString() ?? '';

      name = '$lastName $firstName $middleName'.trim();
    }

    if (name.isEmpty) {
      print('DEBUG: Name is empty for user: $teacherId, data: $data');
      return 'Имя не указано';
    }

    print('DEBUG: Teacher name found: $name');
    return name;
  } catch (e, stackTrace) {
    print('DEBUG: Error loading teacher name: $e');
    print('DEBUG: Stack trace: $stackTrace');
    return 'Ошибка загрузки';
  }
});
