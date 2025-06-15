// lib/providers/teacher_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Единый провайдер для получения имени преподавателя
final teacherNameByIdProvider = FutureProvider.family<String, String>((
  ref,
  teacherId,
) async {
  // Добавляем отладочную информацию
  print('DEBUG: teacherNameByIdProvider called with teacherId: $teacherId');

  if (teacherId.isEmpty) {
    print('DEBUG: teacherId is empty');
    return 'Не указан';
  }

  try {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(teacherId)
            .get();

    print('DEBUG: Document exists: ${doc.exists}');

    if (!doc.exists) {
      print('DEBUG: Document does not exist for teacherId: $teacherId');
      return 'Преподаватель не найден';
    }

    final data = doc.data();
    print('DEBUG: Document data: $data');

    if (data == null) {
      print('DEBUG: Document data is null');
      return 'Данные не найдены';
    }

    // Используем правильные поля из вашей модели User
    final lastName = data['lastName']?.toString() ?? '';
    final firstName = data['firstName']?.toString() ?? '';
    final patronymic = data['patronymic']?.toString() ?? '';

    print(
      'DEBUG: lastName: $lastName, firstName: $firstName, patronymic: $patronymic',
    );

    // Формируем ФИО
    final nameComponents = <String>[];
    if (lastName.isNotEmpty) nameComponents.add(lastName);
    if (firstName.isNotEmpty) nameComponents.add(firstName);
    if (patronymic.isNotEmpty) nameComponents.add(patronymic);

    final fullName = nameComponents.join(' ').trim();
    print('DEBUG: Final fullName: $fullName');

    return fullName.isEmpty ? 'Имя не указано' : fullName;
  } catch (e, stackTrace) {
    print('DEBUG: Error loading teacher name: $e');
    print('DEBUG: Stack trace: $stackTrace');
    return 'Ошибка загрузки: $e';
  }
});

// Простой провайдер без сложного кеширования
final teacherNameSimpleProvider = FutureProvider.family<String, String>((
  ref,
  teacherId,
) async {
  return ref.watch(teacherNameByIdProvider(teacherId).future);
});
