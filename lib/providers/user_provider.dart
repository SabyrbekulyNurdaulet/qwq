import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_service.dart';
import '../models/user.dart';

final userServiceProvider = Provider((ref) => UserService());

final usersProvider = StreamProvider<List<User>>((ref) {
  final userService = ref.watch(userServiceProvider);
  return userService.getAllUsers();
});
