import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth_service.dart';
import '../../routes/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Импорт нужных страниц
import 'teacher_schedule_page.dart';
import 'pages/grades_page.dart';
import 'pages/attendance_page.dart';
import 'pages/profile_page.dart';
import '../../features/chat/chats_page.dart';
import '../../features/news/news_feed_page.dart';

class TeacherHomeScreen extends ConsumerStatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  ConsumerState<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends ConsumerState<TeacherHomeScreen> {
  int _selectedIndex = 0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    // Получаем текущий userId
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        _userId = user?.uid;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Получаем действия для AppBar в зависимости от текущей страницы
  List<Widget>? _getAppBarActions() {
    switch (_selectedIndex) {
      case 5: // ProfilePage
        final authState = ref.watch(authStateProvider);
        final user = authState.valueOrNull;
        if (user != null) {
          return [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Редактировать профиль',
              onPressed: () {
                AppRouter.push(context, '/home/profile/edit', extra: user);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Настройки',
              onPressed: () {
                AppRouter.push(context, '/settings');
              },
            ),
          ];
        }
        return null;
      default:
        return null; // Убираем кнопку выхода из всех остальных страниц
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      if (_userId != null) TeacherSchedulePage(teacherId: _userId!),
      const GradesPage(),
      const AttendancePage(),
      if (_userId != null)
        ChatsPage(
          currentUserId: _userId!,
          showAppBar: false,
          showAddButton: true,
        ),
      const NewsFeedPage(showAppBar: false),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: _getAppBarActions(),
      ),
      body:
          pages.isNotEmpty && _selectedIndex < pages.length
              ? pages[_selectedIndex]
              : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Добавляем для 6 элементов
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Расписание',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Оценки'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Посещаемость',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Чаты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Новости',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }

  final List<String> _titles = [
    'Расписание',
    'Оценки',
    'Посещаемость',
    'Чаты',
    'Новости',
    'Профиль',
  ];
}
