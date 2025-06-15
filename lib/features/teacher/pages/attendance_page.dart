import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/group.dart';
import '../../../models/user.dart' as app_user;
import '../../../models/subject.dart';
import '../../../providers/teacher_goups_provider.dart';
import '../../../providers/teacher_subjects_provider.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  Group? selectedGroup;
  app_user.User? selectedStudent;
  Subject? selectedSubject;
  DateTime selectedDate = DateTime.now();
  String attendanceStatus = 'present'; // present, absent, excused
  final _commentController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<List<app_user.User>> _getStudentsByGroup(String groupId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('groupId', isEqualTo: groupId)
            .where('role', isEqualTo: 'student')
            .where('status', isEqualTo: 'active')
            .get();
    return snapshot.docs
        .map((doc) => app_user.User.fromJson({...doc.data(), 'uid': doc.id}))
        .toList();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('ru', 'RU'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveAttendance() async {
    if (selectedGroup == null ||
        selectedStudent == null ||
        selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Выберите группу, студента и предмет'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    setState(() => isLoading = true);
    try {
      final teacherId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final comment = _commentController.text.trim();
      await FirebaseFirestore.instance.collection('journalEntries').add({
        'journalId': '', // Можно реализовать поиск/создание журнала, если нужно
        'studentId': selectedStudent!.uid,
        'groupId': selectedGroup!.id,
        'subjectId': selectedSubject!.id,
        'teacherId': teacherId,
        'date': Timestamp.fromDate(selectedDate),
        'attendanceStatus': attendanceStatus,
        'present': attendanceStatus == 'present',
        'comment': comment.isEmpty ? null : comment,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Посещение успешно сохранено'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          selectedStudent = null;
          _commentController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacherId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Дата
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: colorScheme.primary,
                  ),
                  title: Text(
                    'Дата занятия: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 16),
              // Группа
              Consumer(
                builder: (context, ref, child) {
                  final teacherGroupsAsync = ref.watch(
                    teacherGroupsProvider(teacherId),
                  );
                  return teacherGroupsAsync.when(
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error:
                        (error, stack) => Text('Ошибка загрузки групп: $error'),
                    data:
                        (groups) => DropdownButtonFormField<Group>(
                          decoration: const InputDecoration(
                            labelText: 'Группа',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.group),
                          ),
                          isExpanded: true,
                          value: selectedGroup,
                          items:
                              groups
                                  .map(
                                    (g) => DropdownMenuItem<Group>(
                                      value: g,
                                      child: Text(
                                        g.fullName.isNotEmpty
                                            ? g.fullName
                                            : 'Без названия',
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (g) {
                            setState(() {
                              selectedGroup = g;
                              selectedStudent = null;
                              selectedSubject = null;
                            });
                          },
                        ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Студент
              if (selectedGroup != null)
                FutureBuilder<List<app_user.User>>(
                  future: _getStudentsByGroup(selectedGroup!.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Ошибка загрузки студентов: ${snapshot.error}',
                      );
                    }
                    final students = snapshot.data ?? [];
                    return DropdownButtonFormField<app_user.User>(
                      decoration: const InputDecoration(
                        labelText: 'Студент',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      isExpanded: true,
                      value: selectedStudent,
                      items:
                          students
                              .map(
                                (s) => DropdownMenuItem<app_user.User>(
                                  value: s,
                                  child: Text(
                                    s.fullName.isNotEmpty
                                        ? s.fullName
                                        : 'Без имени',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (s) {
                        setState(() {
                          selectedStudent = s;
                        });
                      },
                    );
                  },
                ),
              const SizedBox(height: 16),
              // Предмет
              if (selectedGroup != null)
                Consumer(
                  builder: (context, ref, child) {
                    final teacherSubjectsAsync = ref.watch(
                      teacherSubjectsProvider(teacherId),
                    );
                    return teacherSubjectsAsync.when(
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error:
                          (error, stack) =>
                              Text('Ошибка загрузки предметов: $error'),
                      data:
                          (subjects) => DropdownButtonFormField<Subject>(
                            decoration: const InputDecoration(
                              labelText: 'Предмет',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.book),
                            ),
                            isExpanded: true,
                            value: selectedSubject,
                            items:
                                subjects
                                    .map(
                                      (s) => DropdownMenuItem<Subject>(
                                        value: s,
                                        child: Text(
                                          s.name.isNotEmpty
                                              ? s.name
                                              : 'Без названия',
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (s) {
                              setState(() {
                                selectedSubject = s;
                              });
                            },
                          ),
                    );
                  },
                ),
              const SizedBox(height: 16),
              // Статус посещения
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Статус посещения:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RadioListTile<String>(
                        title: const Text('Присутствовал'),
                        value: 'present',
                        groupValue: attendanceStatus,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => attendanceStatus = val);
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Отсутствовал'),
                        value: 'absent',
                        groupValue: attendanceStatus,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => attendanceStatus = val);
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Уважительная причина'),
                        value: 'excused',
                        groupValue: attendanceStatus,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => attendanceStatus = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Комментарий
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Комментарий (необязательно)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              // Кнопка сохранения
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _saveAttendance,
                  icon:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.save),
                  label: const Text('Сохранить посещение'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
