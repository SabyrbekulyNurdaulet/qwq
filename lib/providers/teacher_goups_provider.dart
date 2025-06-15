// lib/providers/teacher_groups_provider.dart (ИСПРАВЛЕННАЯ ВЕРСИЯ)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group.dart';

// ИСПРАВЛЕННЫЙ провайдер для получения групп конкретного преподавателя
// на основе его расписания
final teacherGroupsProvider = FutureProvider.family<List<Group>, String>((
  ref,
  teacherId,
) async {
  print('DEBUG: teacherGroupsProvider: Getting groups for teacher $teacherId');

  if (teacherId.isEmpty) {
    print('DEBUG: teacherGroupsProvider: Empty teacherId');
    return [];
  }

  try {
    // Получаем все документы расписания
    final schedulesSnapshot =
        await FirebaseFirestore.instance.collection('schedules').get();

    print(
      'DEBUG: teacherGroupsProvider: Found ${schedulesSnapshot.docs.length} schedule documents',
    );

    // Собираем уникальные ID групп из всех расписаний, где teacherId совпадает
    final Set<String> groupIds = {};

    for (final scheduleDoc in schedulesSnapshot.docs) {
      final scheduleData = scheduleDoc.data();
      final lessons = scheduleData['lessons'] as List<dynamic>? ?? [];

      print(
        'DEBUG: teacherGroupsProvider: Processing ${lessons.length} lessons in document ${scheduleDoc.id}',
      );

      for (final lesson in lessons) {
        if (lesson['teacherId'] == teacherId) {
          final groupId = lesson['groupId']?.toString();
          if (groupId != null && groupId.isNotEmpty) {
            groupIds.add(groupId);
            print(
              'DEBUG: teacherGroupsProvider: Found group $groupId for teacher',
            );
          }
        }
      }
    }

    print('DEBUG: teacherGroupsProvider: Unique group IDs: $groupIds');

    if (groupIds.isEmpty) {
      print('DEBUG: teacherGroupsProvider: No groups found in schedule');
      return [];
    }

    // Загружаем полную информацию о группах
    final groups = <Group>[];

    // Получаем данные групп батчами (Firestore ограничивает whereIn до 10 элементов)
    final groupIdsList = groupIds.toList();
    for (int i = 0; i < groupIdsList.length; i += 10) {
      final batch = groupIdsList.skip(i).take(10).toList();

      final groupsSnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .where(FieldPath.documentId, whereIn: batch)
              .get();

      for (final groupDoc in groupsSnapshot.docs) {
        try {
          final group = Group.fromJson({...groupDoc.data(), 'id': groupDoc.id});
          groups.add(group);
          print('DEBUG: teacherGroupsProvider: Added group: ${group.name}');
        } catch (e) {
          print(
            'DEBUG: teacherGroupsProvider: Error parsing group ${groupDoc.id}: $e',
          );
        }
      }
    }

    // Сортируем группы по названию
    groups.sort((a, b) => a.name.compareTo(b.name));

    print('DEBUG: teacherGroupsProvider: Final groups count: ${groups.length}');
    return groups;
  } catch (e, stackTrace) {
    print('DEBUG: teacherGroupsProvider: Error: $e');
    print('DEBUG: teacherGroupsProvider: Stack trace: $stackTrace');
    return [];
  }
});

// Провайдер для получения названий групп преподавателя (для упрощенного отображения)
final teacherGroupNamesProvider = FutureProvider.family<List<String>, String>((
  ref,
  teacherId,
) async {
  final groups = await ref.watch(teacherGroupsProvider(teacherId).future);
  return groups.map((group) => group.name).toList();
});

// Провайдер для получения групп преподавателя с дополнительной информацией
final teacherGroupsWithInfoProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      teacherId,
    ) async {
      final groups = await ref.watch(teacherGroupsProvider(teacherId).future);

      return groups
          .map(
            (group) => {
              'group': group,
              'displayName':
                  '${group.name} (${group.specialization} ${group.year} курс)',
              'shortName': group.name,
            },
          )
          .toList();
    });
