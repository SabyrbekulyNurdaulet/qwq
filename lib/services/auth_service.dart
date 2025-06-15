import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получение текущего пользователя
  app_user.User? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;

    // Note: This is a temporary user object, actual data should be fetched from Firestore
    return app_user.User(
      uid: user.uid,
      email: user.email ?? '',
      firstName: user.displayName?.split(' ').first ?? '',
      lastName: user.displayName?.split(' ').last ?? '',
      role: 'student', // Default role, should be fetched from Firestore
      createdAt: user.metadata.creationTime,
      lastLoginAt: user.metadata.lastSignInTime,
    );
  }

  // Поток изменений состояния аутентификации
  Stream<app_user.User?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return null;

      final userData = app_user.User.fromJson(userDoc.data()!);
      if (!userData.isActivated) {
        await _auth.signOut();
        return null;
      }

      return userData;
    });
  }

  // Регистрация
  Future<app_user.User> register(String email, String password) async {
    try {
      // Создаем пользователя в Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Создаем документ пользователя в Firestore
      final newUser = app_user.User(
        uid: user.uid,
        email: email,
        firstName: '', // These fields should be filled in by the user later
        lastName: '',
        role: 'student', // Default role
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

      return newUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'Пароль слишком слабый';
      } else if (e.code == 'email-already-in-use') {
        throw 'Этот email уже используется';
      }
      throw 'Ошибка при регистрации: ${e.message}';
    }
  }

  // Вход
  Future<app_user.User> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Получаем данные пользователя из Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        throw 'Пользователь не найден';
      }

      final userData = app_user.User.fromJson(userDoc.data()!);

      // Проверяем статус активации
      if (!userData.isActivated) {
        await _auth.signOut();
        throw 'Аккаунт ожидает подтверждения администратором';
      }

      // Обновляем время последнего входа
      await _firestore.collection('users').doc(user.uid).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      return userData;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Пользователь не найден';
      } else if (e.code == 'wrong-password') {
        throw 'Неверный пароль';
      }
      throw 'Ошибка при входе: ${e.message}';
    }
  }

  // Выход
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Сброс пароля
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw 'Ошибка при сбросе пароля: ${e.message}';
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
