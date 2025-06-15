// lib/services/group_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group.dart';

class GroupService {
  final _firestore = FirebaseFirestore.instance;

  Future<Group?> getGroup(String groupId) async {
    print('DEBUG: GroupService: Getting group with ID: $groupId');
    try {
      final doc = await _firestore.collection('groups').doc(groupId).get();
      if (!doc.exists) {
        print('DEBUG: GroupService: Group document does not exist');
        return null;
      }

      final data = doc.data()!;
      print('DEBUG: GroupService: Group data: $data');

      // Добавляем id к данным перед парсингом
      final groupData = {...data, 'id': doc.id};

      // Проверяем обязательные поля
      if (groupData['name'] == null ||
          groupData['specialization'] == null ||
          groupData['year'] == null) {
        print('DEBUG: GroupService: Missing required fields in group data');
        return null;
      }

      final group = Group.fromJson(groupData);
      print('DEBUG: GroupService: Created Group object: ${group.fullName}');
      return group;
    } catch (e, stackTrace) {
      print('DEBUG: GroupService: Error getting group: $e');
      print('DEBUG: GroupService: Stack trace: $stackTrace');
      return null;
    }
  }

  // Получить все группы
  Stream<List<Group>> getAllGroups() {
    return _firestore
        .collection('groups')
        .orderBy('year')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return Group.fromJson({...doc.data(), 'id': doc.id});
            } catch (e) {
              print('DEBUG: GroupService: Error parsing group ${doc.id}: $e');
              // Возвращаем группу с минимальными данными в случае ошибки
              return Group(
                id: doc.id,
                name: 'Ошибка загрузки',
                specialization: 'Неизвестно',
                year: 1,
              );
            }
          }).toList();
        });
  }

  // Получить группы по курсу
  Stream<List<Group>> getGroupsByYear(int year) {
    return _firestore
        .collection('groups')
        .where('year', isEqualTo: year)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return Group.fromJson({...doc.data(), 'id': doc.id});
            } catch (e) {
              print('DEBUG: GroupService: Error parsing group ${doc.id}: $e');
              return Group(
                id: doc.id,
                name: 'Ошибка загрузки',
                specialization: 'Неизвестно',
                year: year,
              );
            }
          }).toList();
        });
  }

  // Получить группы по специализации
  Stream<List<Group>> getGroupsBySpecialization(String specialization) {
    return _firestore
        .collection('groups')
        .where('specialization', isEqualTo: specialization)
        .orderBy('year')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return Group.fromJson({...doc.data(), 'id': doc.id});
            } catch (e) {
              print('DEBUG: GroupService: Error parsing group ${doc.id}: $e');
              return Group(
                id: doc.id,
                name: 'Ошибка загрузки',
                specialization: specialization,
                year: 1,
              );
            }
          }).toList();
        });
  }
}
