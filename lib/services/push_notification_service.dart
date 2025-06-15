// lib/services/push_notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Инициализация push-уведомлений
  static Future<void> initialize() async {
    try {
      // Запрос разрешений на уведомления
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('Пользователь разрешил уведомления');
        
        // Получение FCM токена
        String? token = await _messaging.getToken();
        if (token != null) {
          debugPrint('FCM Token: $token');
          await _saveTokenToFirestore(token);
        }
        
        // Обновление токена при изменении
        _messaging.onTokenRefresh.listen(_saveTokenToFirestore);
        
        // Настройка обработчиков уведомлений
        _setupMessageHandlers();
        
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Пользователь запретил уведомления');
      }
    } catch (e) {
      debugPrint('Ошибка инициализации push-уведомлений: $e');
    }
  }

  // Сохранение токена в Firestore
  static Future<void> _saveTokenToFirestore(String token) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': token,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('FCM токен сохранен в Firestore');
      }
    } catch (e) {
      debugPrint('Ошибка сохранения FCM токена: $e');
    }
  }

  // Настройка обработчиков сообщений
  static void _setupMessageHandlers() {
    // Обработка уведомлений когда приложение на переднем плане
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Получено уведомление на переднем плане: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Обработка уведомлений когда приложение в фоне или закрыто
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Приложение открыто через уведомление: ${message.notification?.title}');
      _handleNotificationTap(message);
    });

    // Обработка уведомлений когда приложение полностью закрыто
   _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('Приложение запущено через уведомление: ${message.notification?.title}');
        _handleNotificationTap(message);
      }
    });
  }

  // Показ локального уведомления (когда приложение активно)
  static void _showLocalNotification(RemoteMessage message) {
    // Здесь можно использовать flutter_local_notifications для показа уведомления
    // Или показать SnackBar/Dialog в зависимости от контекста приложения
    debugPrint('Показываем локальное уведомление: ${message.notification?.body}');
  }

  // Обработка нажатия на уведомление
  static void _handleNotificationTap(RemoteMessage message) {
    // Навигация в зависимости от типа уведомления
    final data = message.data;
    
    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'news':
          // Навигация к новостям
          debugPrint('Переход к новостям');
          break;
        case 'grades':
          // Навигация к оценкам
          debugPrint('Переход к оценкам');
          break;
        case 'attendance':
          // Навигация к посещаемости
          debugPrint('Переход к посещаемости');
          break;
        case 'account_approved':
          // Уведомление об одобрении аккаунта
          debugPrint('Аккаунт одобрен');
          break;
        default:
          debugPrint('Неизвестный тип уведомления: ${data['type']}');
      }
    }
  }

  // Подписка на топики для массовых уведомлений
  static Future<void> subscribeToTopics() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Получаем роль пользователя
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        final role = userDoc.data()?['role'] as String?;
        
        if (role != null && role != 'pending_approval') {
          // Подписываемся на общие уведомления
          await _messaging.subscribeToTopic('all_users');
          
          // Подписываемся на уведомления для конкретной роли
          await _messaging.subscribeToTopic(role);
          
          debugPrint('Подписка на топики: all_users, $role');
        }
      }
    } catch (e) {
      debugPrint('Ошибка подписки на топики: $e');
    }
  }

  // Отписка от топиков
  static Future<void> unsubscribeFromTopics() async {
    try {
      await _messaging.unsubscribeFromTopic('all_users');
      await _messaging.unsubscribeFromTopic('student');
      await _messaging.unsubscribeFromTopic('teacher');
      debugPrint('Отписка от всех топиков');
    } catch (e) {
      debugPrint('Ошибка отписки от топиков: $e');
    }
  }
}

// Обработчик фоновых сообщений (должен быть top-level функцией)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Обработка фонового сообщения: ${message.messageId}');
  // Здесь можно выполнить дополнительную логику для фоновых уведомлений
}

