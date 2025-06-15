import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/grade.dart';
import '../services/grades_service.dart';

final gradesServiceProvider = Provider<GradesService>((ref) => GradesService());

final gradesProvider = FutureProvider<List<Grade>>((ref) async {
  final gradesService = ref.watch(gradesServiceProvider);
  return gradesService.getGrades();
});
