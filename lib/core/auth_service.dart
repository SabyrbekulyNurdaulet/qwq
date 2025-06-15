// lib/core/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart'
    hide User; // Скрываем User из firebase_auth
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Для debugPrint

// Импортируем нашу модель User без псевдонима, если нет конфликтов
// или используем 'as app_user' если есть конфликт имен
import '../models/user.dart';

// --- Riverpod Провайдеры ---

// Провайдер для самого сервиса
final authServiceProvider = Provider<AuthService>((ref) {
  // Можно передать зависимости, если они нужны, например, ref
  return AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);
});

// Провайдер для стрима состояния аутентификации с данными пользователя
final authStateProvider = StreamProvider<User?>((ref) {
  // Следим за authServiceProvider, чтобы получить экземпляр AuthService
  final authService = ref.watch(authServiceProvider);
  return authService.userStream(); // Возвращаем стрим кастомного пользователя
});

// --- Класс Сервиса Аутентификации ---

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService(
    this._firebaseAuth,
    this._firestore,
  ); // Получаем зависимости через конструктор

  /// Стрим, который выдает нашего кастомного пользователя [User] или null.
  Stream<User?> userStream() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      debugPrint(
        '[AuthService] AuthState изменился. Firebase User ID: ${firebaseUser?.uid}',
      );
      if (firebaseUser == null) {
        return null;
      }
      // Если пользователь аутентифицирован, загружаем его полный профиль.
      final appUser = await _getUserData(firebaseUser.uid);

      // ВАЖНО: если у пользователя статус не 'active', мы не должны его пускать.
      // Но эту проверку мы уже делаем на экране входа. Здесь же мы можем добавить
      // дополнительную защиту: если профиль не найден или неактивен, возвращаем null.
      if (appUser == null || appUser.status != 'active') {
        debugPrint(
          '[AuthService] Пользователь ${firebaseUser.uid} не активен или его профиль не найден. Возвращаем null.',
        );
        // Можно также принудительно разлогинить, если appUser.status не active, для надежности.
        await signOut();
        return null;
      }

      return appUser;
    });
  }

  /// Вспомогательный метод для загрузки данных пользователя из Firestore.
  Future<User?> _getUserData(String uid) async {
    try {
      final DocumentReference userDocRef = _firestore
          .collection('users')
          .doc(uid);
      debugPrint('[AuthService] Пытаюсь получить документ: ${userDocRef.path}');
      final DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        debugPrint('[AuthService] Документ пользователя $uid существует.');
        // Получаем данные как Map<String, dynamic>
        final userData = userDoc.data() as Map<String, dynamic>;
        debugPrint('[AuthService] Данные пользователя $uid: $userData');

        // Явно добавляем ID документа в Map перед передачей в fromJson,
        // если User.fromJson ожидает поле 'id'.
        userData['id'] = uid;

        // Создаем наш объект User из данных Firestore
        return User.fromJson(userData);
      } else {
        // Документа нет - это может быть проблемой (например, ошибка при записи во время регистрации)
        debugPrint(
          '[AuthService] ОШИБКА: Документ пользователя $uid НЕ НАЙДЕН в Firestore.',
        );
        return null;
      }
    } on FirebaseException catch (e) {
      // Ошибка при чтении из Firestore (например, нет прав доступа)
      debugPrint(
        '[AuthService] ОШИБКА Firestore при получении данных пользователя $uid: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      // Любая другая неожиданная ошибка
      debugPrint(
        '[AuthService] НЕИЗВЕСТНАЯ ОШИБКА при получении данных пользователя $uid: $e',
      );
      return null;
    }
  }

  /// Вход пользователя по email и паролю.
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      debugPrint('[AuthService] Попытка входа для: $email');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // НОВАЯ ЛОГИКА: Проверяем статус пользователя после входа
      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        final userData = await _getUserData(firebaseUser.uid);
        
        if (userData == null) {
          // Пользователь не найден в Firestore
          await signOut();
          throw Exception('Данные пользователя не найдены. Обратитесь к администратору.');
        }
        
        if (userData.status == 'pending_approval') {
          // Аккаунт ожидает подтверждения
          await signOut();
          throw Exception('Ваш аккаунт ожидает подтверждения администратором.');
        }
        
        if (userData.status == 'rejected') {
          // Аккаунт отклонен
          await signOut();
          throw Exception('Ваш аккаунт был отклонен администратором.');
        }
        
        if (userData.status == 'blocked') {
          // Аккаунт заблокирован
          await signOut();
          throw Exception('Ваш аккаунт заблокирован.');
        }
        
        if (userData.status != 'approved') {
          // Неизвестный статус
          await signOut();
          throw Exception('Статус вашего аккаунта не позволяет войти в систему.');
        }
      }
      
      debugPrint('[AuthService] Вход успешен для: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      // Обрабатываем специфичные ошибки Firebase Auth
      debugPrint(
        '[AuthService] ОШИБКА FirebaseAuth при входе: ${e.code} - ${e.message}',
      );
      
      // Преобразуем коды ошибок Firebase в понятные сообщения
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Пользователь с таким email не найден.';
          break;
        case 'wrong-password':
          errorMessage = 'Неверный пароль.';
          break;
        case 'invalid-email':
          errorMessage = 'Некорректный формат email.';
          break;
        case 'user-disabled':
          errorMessage = 'Аккаунт отключен.';
          break;
        case 'too-many-requests':
          errorMessage = 'Слишком много попыток входа. Попробуйте позже.';
          break;
        default:
          errorMessage = 'Ошибка входа: ${e.message}';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('[AuthService] НЕИЗВЕСТНАЯ ОШИБКА при входе: $e');
      // Если это уже наше кастомное исключение, пробрасываем его дальше
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Произошла неизвестная ошибка при входе.');
    }
  }

  /// Регистрация нового пользователя с email, паролем, именем и ролью.
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
    // --- Принимаем раздельные ФИО ---
    String lastName,
    String firstName,
    String? patronymic, // Отчество опционально
    // --------------------------------
    String role,
  ) async {
    try {
      debugPrint('[AuthService] Попытка регистрации для: $email');
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        debugPrint(
          '[AuthService] Пользователь создан в Auth: ${firebaseUser.uid}',
        );
        // --- Сохраняем раздельные ФИО в Firestore ---
        final userData = {
          'lastName': lastName.trim(), // Убираем лишние пробелы
          'firstName': firstName.trim(),
          'patronymic':
              patronymic?.trim() ?? '', // Сохраняем пустоту, если null
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          // Добавь сюда другие поля по умолчанию, если нужно (groupId, course и т.д.
          // могут добавляться позже админом или при привязке к группе)
        };
        // ------------------------------------------

        try {
          await _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              // Добавляем 'id' в данные перед сохранением, если fromJson его ожидает
              // .set({...userData, 'id': firebaseUser.uid});
              .set(userData); // Используем set
          debugPrint(
            '[AuthService] Данные пользователя ${firebaseUser.uid} сохранены в Firestore.',
          );
        } on FirebaseException catch (e) {
          debugPrint(
            '[AuthService] ОШИБКА Firestore при сохранении данных пользователя ${firebaseUser.uid}: ${e.code} - ${e.message}',
          );
          // ... (обработка ошибки сохранения) ...
        }
        return credential;
      } else {
        // Это не должно произойти, если createUserWithEmailAndPassword не выбросил исключение
        debugPrint(
          '[AuthService] ОШИБКА: credential.user == null после регистрации.',
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      // Обрабатываем ошибки создания пользователя (слабый пароль, email уже используется и т.д.)
      debugPrint(
        '[AuthService] ОШИБКА FirebaseAuth при регистрации: ${e.code} - ${e.message}',
      );
      return null; // Возвращаем null при ошибке
    } catch (e) {
      debugPrint('[AuthService] НЕИЗВЕСТНАЯ ОШИБКА при регистрации: $e');
      return null;
    }
  }

  /// Выход пользователя.
  Future<void> signOut() async {
    try {
      debugPrint('[AuthService] Выход пользователя...');
      await _firebaseAuth.signOut();
      debugPrint('[AuthService] Выход выполнен.');
    } catch (e) {
      debugPrint('[AuthService] ОШИБКА при выходе: $e');
    }
  }

  // --- Другие методы сервиса (если нужны) ---
  // Например: сброс пароля, обновление профиля и т.д.
}
