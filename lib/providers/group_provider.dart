// lib/providers/group_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/group.dart';
import '../services/group_service.dart';

// Провайдер для получения всех групп из Firestore
final allGroupsProvider = StreamProvider<List<Group>>((ref) {
  return FirebaseFirestore.instance
      .collection('groups')
      .orderBy('name')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return Group.fromJson({...doc.data(), 'id': doc.id});
          } catch (e) {
            debugPrint('Error parsing group ${doc.id}: $e');
            return Group(
              id: doc.id,
              name: 'Ошибка загрузки',
              specialization: 'Неизвестно',
              year: 1,
            );
          }
        }).toList();
      });
});

// Провайдер для получения количества студентов в группе
final groupStudentCountProvider = FutureProvider.family<int, String>((
  ref,
  groupId,
) async {
  if (groupId.isEmpty) return 0;

  try {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('groupId', isEqualTo: groupId)
            .where('role', isEqualTo: 'student')
            .get();

    return snapshot.docs.length;
  } catch (e) {
    debugPrint('Error counting students in group $groupId: $e');
    return 0;
  }
});

// ИСПРАВЛЕННЫЙ провайдер для получения названия группы по ID
final groupNameProvider = FutureProvider.family<String, String>((
  ref,
  groupId,
) async {
  print('DEBUG: groupNameProvider called with groupId: $groupId');

  if (groupId.isEmpty) {
    print('DEBUG: groupId is empty');
    return 'Группа не указана';
  }

  try {
    final groupDoc =
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .get();

    print('DEBUG: Group document exists: ${groupDoc.exists}');

    if (!groupDoc.exists) {
      print('DEBUG: Group document does not exist for groupId: $groupId');
      return 'Группа не найдена';
    }

    final data = groupDoc.data()!;
    print('DEBUG: Group document data: $data');

    final name = data['name'] as String? ?? '';
    final year = data['year'] as int? ?? 0;
    final specialization = data['specialization'] as String? ?? '';

    if (name.isEmpty) {
      return 'Группа без названия';
    }

    // Формируем полное название группы
    String fullName = name;
    if (specialization.isNotEmpty && year > 0) {
      fullName = '$specialization $year курс, группа $name';
    } else if (specialization.isNotEmpty) {
      fullName = '$specialization, группа $name';
    } else if (year > 0) {
      fullName = '$year курс, группа $name';
    }

    print('DEBUG: Final group name: $fullName');
    return fullName;
  } catch (e, stackTrace) {
    print('DEBUG: Error getting group name for $groupId: $e');
    print('DEBUG: Stack trace: $stackTrace');
    return 'Ошибка загрузки группы: $e';
  }
});

final groupServiceProvider = Provider((ref) => GroupService());

// ИСПРАВЛЕННЫЙ провайдер для получения группы по ID
final groupProvider = FutureProvider.family<Group?, String>((
  ref,
  groupId,
) async {
  print('DEBUG: groupProvider called with groupId: $groupId');

  if (groupId.isEmpty) {
    print('DEBUG: groupId is empty');
    return null;
  }

  try {
    final doc =
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .get();

    print('DEBUG: Group document exists: ${doc.exists}');

    if (!doc.exists) {
      print('DEBUG: Group document does not exist for groupId: $groupId');
      return null;
    }

    final data = doc.data()!;
    print('DEBUG: Group document data: $data');

    final group = Group.fromJson({...data, 'id': doc.id});
    print('DEBUG: Created Group object: $group');
    return group;
  } catch (e, stackTrace) {
    print('DEBUG: Error getting group: $e');
    print('DEBUG: Stack trace: $stackTrace');
    return null;
  }
});
