import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assignment.dart';
import '../services/assignment_service.dart';

final assignmentServiceProvider = Provider((ref) => AssignmentService());

final assignmentsProvider = StreamProvider.autoDispose<List<Assignment>>((ref) {
  final assignmentService = ref.watch(assignmentServiceProvider);
  return assignmentService.getAssignments();
});
