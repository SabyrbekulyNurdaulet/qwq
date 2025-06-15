// lib/features/student/edit_profile_page.dart (Улучшенная версия)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../models/user.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final User initialUser;

  const EditProfilePage({super.key, required this.initialUser});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для редактируемых полей
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _patronymicController;
  late TextEditingController _phoneController;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры начальными данными
    _lastNameController = TextEditingController(
      text: widget.initialUser.lastName,
    );
    _firstNameController = TextEditingController(
      text: widget.initialUser.firstName,
    );
    _patronymicController = TextEditingController(
      text: widget.initialUser.middleName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.initialUser.phone ?? '',
    );
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _patronymicController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Ошибка: Пользователь не найден.";
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
        );
      }
      return;
    }

    final updatedLastName = _lastNameController.text.trim();
    final updatedFirstName = _firstNameController.text.trim();
    final updatedPatronymic = _patronymicController.text.trim();
    final updatedPhone = _phoneController.text.trim();

    // Собираем только обновляемые поля
    final Map<String, dynamic> updatedData = {
      'lastName': updatedLastName,
      'firstName': updatedFirstName,
      'patronymic': updatedPatronymic.isEmpty ? null : updatedPatronymic,
      'phone': updatedPhone.isEmpty ? null : updatedPhone,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Профиль успешно обновлен!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(); // Закрываем текущий экран
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Не удалось обновить профиль.';
      });
      debugPrint("Profile update error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_errorMessage\n$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Сохранить изменения',
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                  // Заголовок профиля
                  _buildProfileHeader(colorScheme, textTheme),
                  const SizedBox(height: 24),

                  // Редактируемые поля
                  _buildEditableSection(colorScheme, textTheme),
                  const SizedBox(height: 24),

                  // Не редактируемые поля (для справки)
                  _buildReadOnlySection(colorScheme, textTheme),
                  const SizedBox(height: 24),

                  // Кнопка сохранения (дублируем внизу для удобства)
                  _buildSaveButton(colorScheme),
                ]
                .animate(interval: 80.ms)
                .fadeIn(duration: 250.ms)
                .slideX(begin: 0.1),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Аватар (пока только отображение)
            CircleAvatar(
              radius: 40,
              backgroundColor: colorScheme.secondaryContainer,
              backgroundImage:
                  (widget.initialUser.photoURL != null &&
                          widget.initialUser.photoURL!.isNotEmpty)
                      ? NetworkImage(widget.initialUser.photoURL!)
                      : null,
              child:
                  (widget.initialUser.photoURL == null ||
                          widget.initialUser.photoURL!.isEmpty)
                      ? Icon(
                        Icons.person,
                        size: 40,
                        color: colorScheme.onSecondaryContainer,
                      )
                      : null,
            ),
            const SizedBox(height: 12),
            Text(
              'Редактирование профиля',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.initialUser.email,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_outlined, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Редактируемые данные",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Фамилия',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Пожалуйста, введите фамилию';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Пожалуйста, введите имя';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _patronymicController,
              decoration: const InputDecoration(
                labelText: 'Отчество',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlySection(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Информация для справки",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              icon: Icons.group_outlined,
              label: 'Группа',
              value: widget.initialUser.groupId ?? 'Не указана',
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _buildReadOnlyField(
              icon: Icons.email_outlined,
              label: 'Email',
              value: widget.initialUser.email,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(ColorScheme colorScheme) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveProfile,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      child:
          _isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : const Text('Сохранить изменения'),
    );
  }
}
