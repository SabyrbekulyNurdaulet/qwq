import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/assignment.dart';
import '../../../providers/assignment_provider.dart';

class AssignmentEditPage extends ConsumerStatefulWidget {
  final Assignment? assignment;

  const AssignmentEditPage({super.key, this.assignment});

  @override
  ConsumerState<AssignmentEditPage> createState() => _AssignmentEditPageState();
}

class _AssignmentEditPageState extends ConsumerState<AssignmentEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.assignment?.title);
    _descriptionController = TextEditingController(
      text: widget.assignment?.description,
    );
    _dueDate = widget.assignment?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveAssignment() async {
    if (!_formKey.currentState!.validate()) return;

    final assignment = Assignment(
      id: widget.assignment?.id ?? '',
      teacherId:
          'current_teacher_id', // TODO: Получить ID текущего преподавателя
      groupId: 'current_group_id', // TODO: Получить ID текущей группы
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,
      scheduleEntryId: widget.assignment?.scheduleEntryId,
      createdAt: widget.assignment?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.assignment == null) {
        await ref.read(assignmentServiceProvider).addAssignment(assignment);
      } else {
        await ref.read(assignmentServiceProvider).updateAssignment(assignment);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.assignment == null ? 'Новое задание' : 'Редактировать задание',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите описание';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Срок сдачи'),
              subtitle: Text(
                '${_dueDate.day}.${_dueDate.month}.${_dueDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _dueDate = date);
                }
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveAssignment,
              child: Text(widget.assignment == null ? 'Создать' : 'Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
