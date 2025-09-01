import 'package:agenda/layers/presentation/pages/hive/home_screen_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/helpers/hive_initialization.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsHivePage extends StatefulWidget {
  final String language;
  const SettingsHivePage({super.key, required this.language});

  @override
  State<SettingsHivePage> createState() => _SettingsHivePageState();
}

class _SettingsHivePageState extends State<SettingsHivePage> {
  String _selectedLanguage = 'uzb';
  bool _darkMode = true;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.language;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'uzb';
      _darkMode = prefs.getBool('darkMode') ?? true;
    });
  }

  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      _selectedLanguage = language;
    });
  }

  Future<void> _saveDarkMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', darkMode);
    setState(() {
      _darkMode = darkMode;
    });
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.another,
        title: Text(
          _selectedLanguage == 'eng'
              ? 'Clear All Data'
              : _selectedLanguage == 'rus'
                  ? 'Очистить все данные'
                  : 'Barcha ma\'lumotlarni tozalash',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          _selectedLanguage == 'eng'
              ? 'Are you sure you want to delete all tasks and debts? This action cannot be undone.'
              : _selectedLanguage == 'rus'
                  ? 'Вы уверены, что хотите удалить все задачи и долги? Это действие нельзя отменить.'
                  : 'Haqiqatan ham barcha vazifalar va qarzlarni o\'chirmoqchimisiz? Bu amalni bekor qilib bo\'lmaydi.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              _selectedLanguage == 'eng'
                  ? 'Cancel'
                  : _selectedLanguage == 'rus'
                      ? 'Отмена'
                      : 'Bekor qilish',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              _selectedLanguage == 'eng'
                  ? 'Delete All'
                  : _selectedLanguage == 'rus'
                      ? 'Удалить все'
                      : 'Barchasini o\'chirish',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await HiveInitialization.clearAllData();

        _showSnackBar(
          _selectedLanguage == 'eng'
              ? 'All data cleared successfully'
              : _selectedLanguage == 'rus'
                  ? 'Все данные успешно очищены'
                  : 'Barcha ma\'lumotlar muvaffaqiyatli tozalandi',
        );
      } catch (e) {
        _showSnackBar('Error: ${e.toString()}');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        title: Text(
          _selectedLanguage == 'eng'
              ? 'Settings'
              : _selectedLanguage == 'rus'
                  ? 'Настройки'
                  : 'Sozlamalar',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        actions: [
       
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20.h),

            // Language Settings
            _buildSettingsSection(
              title: _selectedLanguage == 'eng'
                  ? 'Language'
                  : _selectedLanguage == 'rus'
                      ? 'Язык'
                      : 'Til',
              child: Column(
                children: [
                  _buildLanguageOption('uzb', 'O\'zbekcha'),
                  _buildLanguageOption('eng', 'English'),
                  _buildLanguageOption('rus', 'Русский'),
                ],
              ),
            ),

            Gap(30.h),

            // Theme Settings
            _buildSettingsSection(
              title: _selectedLanguage == 'eng'
                  ? 'Appearance'
                  : _selectedLanguage == 'rus'
                      ? 'Внешний вид'
                      : 'Ko\'rinish',
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _selectedLanguage == 'eng'
                      ? 'Dark Mode'
                      : _selectedLanguage == 'rus'
                          ? 'Темная тема'
                          : 'Qorong\'u rejim',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  _selectedLanguage == 'eng'
                      ? 'Use dark theme for better night viewing'
                      : _selectedLanguage == 'rus'
                          ? 'Использовать темную тему для лучшего просмотра ночью'
                          : 'Kechqurun yaxshi ko\'rish uchun qorong\'u rejimdan foydalaning',
                  style: const TextStyle(color: Colors.white60),
                ),
                value: _darkMode,
                onChanged: _saveDarkMode,
              ),
            ),

            Gap(30.h),

            // Data Management
            _buildSettingsSection(
              title: _selectedLanguage == 'eng'
                  ? 'Data Management'
                  : _selectedLanguage == 'rus'
                      ? 'Управление данными'
                      : 'Ma\'lumotlarni boshqarish',
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.info_outline, color: Colors.blue),
                    title: Text(
                      _selectedLanguage == 'eng'
                          ? 'About Hive Storage'
                          : _selectedLanguage == 'rus'
                              ? 'О локальном хранилище'
                              : 'Mahalliy saqlash haqida',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _selectedLanguage == 'eng'
                          ? 'All data is stored locally on your device'
                          : _selectedLanguage == 'rus'
                              ? 'Все данные хранятся локально на вашем устройстве'
                              : 'Barcha ma\'lumotlar qurilmangizda mahalliy saqlanadi',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                  Gap(10.h),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: Text(
                      _selectedLanguage == 'eng'
                          ? 'Clear All Data'
                          : _selectedLanguage == 'rus'
                              ? 'Очистить все данные'
                              : 'Barcha ma\'lumotlarni tozalash',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _selectedLanguage == 'eng'
                          ? 'Delete all tasks and debts permanently'
                          : _selectedLanguage == 'rus'
                              ? 'Удалить все задачи и долги навсегда'
                              : 'Barcha vazifalar va qarzlarni butunlay o\'chirish',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    onTap: _clearAllData,
                  ),
                ],
              ),
            ),

            Gap(30.h),

            // App Information
            _buildSettingsSection(
              title: _selectedLanguage == 'eng'
                  ? 'App Information'
                  : _selectedLanguage == 'rus'
                      ? 'Информация о приложении'
                      : 'Ilova haqida',
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.storage, color: Colors.green),
                    title: Text(
                      _selectedLanguage == 'eng'
                          ? 'Storage Type'
                          : _selectedLanguage == 'rus'
                              ? 'Тип хранилища'
                              : 'Saqlash turi',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Hive (Local Database)',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.offline_bolt, color: Colors.orange),
                    title: Text(
                      _selectedLanguage == 'eng'
                          ? 'Offline Support'
                          : _selectedLanguage == 'rus'
                              ? 'Поддержка офлайн'
                              : 'Oflayn qo\'llab-quvvatlash',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _selectedLanguage == 'eng'
                          ? 'Works without internet connection'
                          : _selectedLanguage == 'rus'
                              ? 'Работает без подключения к интернету'
                              : 'Internet aloqasisiz ishlaydi',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Gap(15.h),
          child,
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      value: code,
      groupValue: _selectedLanguage,
      onChanged: (value) {
        if (value != null) {
          _saveLanguage(value);
        }
      },
    );
  }
}
