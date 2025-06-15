import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/semester.dart';
import '../providers/schedule_provider.dart';

class SemesterSelector extends ConsumerWidget {
  final Semester? selectedSemester;
  final Function(Semester) onSemesterSelected;

  const SemesterSelector({
    super.key,
    required this.selectedSemester,
    required this.onSemesterSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSemestersAsync =
        ref.watch(semesterServiceProvider).getAllSemesters();

    return StreamBuilder<List<Semester>>(
      stream: allSemestersAsync,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        }

        final semesters = snapshot.data ?? [];
        // Найти выбранный семестр по id, если он есть в списке
        Semester? dropdownValue;
        if (selectedSemester?.id != null &&
            selectedSemester!.id.isNotEmpty &&
            semesters.isNotEmpty) {
          dropdownValue = semesters.firstWhere(
            (s) => s.id == selectedSemester?.id,
            orElse: () => semesters.first,
          );
        } else {
          dropdownValue = null;
        }
        return DropdownButtonFormField<Semester>(
          value: dropdownValue,
          decoration: const InputDecoration(
            labelText: 'Семестр',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          items:
              semesters.map((semester) {
                return DropdownMenuItem(
                  value: semester,
                  child: Text(semester.name),
                );
              }).toList(),
          onChanged: (semester) {
            if (semester != null) {
              onSemesterSelected(semester);
            }
          },
        );
      },
    );
  }
}
