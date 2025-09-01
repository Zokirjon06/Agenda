import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/task_detail_hive_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/divders.dart';
import 'package:agenda/layers/presentation/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class SearchHivePage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const SearchHivePage(
      {super.key, required this.language, required this.lightMode});

  @override
  State<SearchHivePage> createState() => _SearchHivePageState();
}

class _SearchHivePageState extends State<SearchHivePage> {
  final FocusNode _focusNode = FocusNode();
  String searchQuery = "";
  List<TaskModelHive> _filteredTasks = [];
  List<DebtsModel> _filteredDebts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<TaskModelHive> getAllTasksFromHive(String query) {
    try {
      final box = Hive.box<TaskModelHive>('tasksHiveBox');
      final allTasks = box.values.toList();

      if (query.isEmpty) {
        return allTasks;
      } else {
        return allTasks.where((task) =>
            task.task.toLowerCase().contains(query.toLowerCase()) ||
            task.priority.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    } catch (e) {
      debugPrint('Error searching tasks: $e');
      return [];
    }
  }

  List<DebtsModel> getFilteredUserDebts(String query) {
    try {
      final box = Hive.box<DebtsModel>('debtsBox');
      final allDebts = box.values.toList();

      if (query.isEmpty) {
        return allDebts;
      } else {
        return allDebts.where((debt) =>
            (debt.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (debt.goal?.toLowerCase().contains(query.toLowerCase()) ?? false)
        ).toList();
      }
    } catch (e) {
      debugPrint('Error searching debts: $e');
      return [];
    }
  }

  void _performSearch(String query) {
    setState(() {
      searchQuery = query;
      _filteredTasks = getAllTasksFromHive(query);
      _filteredDebts = getFilteredUserDebts(query);
    });
  }

  String getHintText() {
    switch (widget.language) {
      case 'eng':
        return 'Search...';
      case 'rus':
        return 'Поиск...';
      case 'uzb':
        return 'Qidirish...';
      default:
        return 'Search...';
    }
  }

  String getNoResultsText() {
    switch (widget.language) {
      case 'eng':
        return 'No results found.';
      case 'rus':
        return 'Результатов не найдено.';
      case 'uzb':
        return 'Natijalar topilmadi.';
      default:
        return 'No results found.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.lightMode ? AppColors.primary : AppColors.standartColor,
      appBar: AppBar(
        backgroundColor: widget.lightMode
            ? AppColors.homeBackgroundColor
            : AppColors.standartColor,
        title: Padding(
          padding: EdgeInsets.only(right: 15.w),
          child: TextFormField(
            focusNode: _focusNode,
            textCapitalization: TextCapitalization.words,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: getHintText(),
              hintStyle: const TextStyle(color: Colors.white),
              fillColor: widget.lightMode ? Colors.blue[200] : Colors.blueGrey,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 20.0),
            ),
            onChanged: _performSearch,
          ),
        ),
        titleSpacing: 0,
      ),
      body: searchQuery.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 80.sp,
                    color: Colors.white30,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    widget.language == 'eng'
                        ? 'Start typing to search...'
                        : widget.language == 'rus'
                            ? 'Начните вводить для поиска...'
                            : 'Qidirish uchun yozishni boshlang...',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_filteredDebts.isNotEmpty) _buildFilterUserDebts(),
                        if (_filteredTasks.isNotEmpty) _buildFilterTasks(),
                        if (_filteredDebts.isEmpty && _filteredTasks.isEmpty)
                          _buildNoResults(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 60.sp,
            color: Colors.white30,
          ),
          SizedBox(height: 20.h),
          Text(
            getNoResultsText(),
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white60,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterUserDebts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            widget.language == 'eng'
                ? 'Debts'
                : widget.language == 'rus'
                    ? 'Долги'
                    : 'Qarzlar',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredDebts.length,
          itemBuilder: (context, index) {
            final debt = _filteredDebts[index];
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      debt.name?.isNotEmpty == true
                          ? debt.name![0].toUpperCase()
                          : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    debt.name ?? 'Unknown',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${widget.language == 'eng' ? 'Debt' : widget.language == 'rus' ? "Долг" : 'Qarz'}: ${debt.money?.toMoney() ?? '0'} so\'m',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        debt.debt == 'get'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        size: 31.sp,
                        color: debt.debt == 'get' ? Colors.green : Colors.red,
                      ),
                      Text(
                          debt.debt == 'get'
                              ? (widget.language == 'eng'
                                  ? "They owe me"
                                  : widget.language == 'rus'
                                      ? "Мне должны"
                                      : "Menga qarzdor")
                              : (widget.language == 'eng'
                                  ? "I owe"
                                  : widget.language == 'rus'
                                      ? "Я должен"
                                      : "Qarzdorman"),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey))
                    ],
                  ),
                ),
                Dividers(lightMode: widget.lightMode, inden: false),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            widget.language == 'eng'
                ? 'Tasks'
                : widget.language == 'rus'
                    ? 'Задачи'
                    : 'Vazifalar',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredTasks.length,
          itemBuilder: (context, index) {
            final task = _filteredTasks[index];
            return Column(
              children: [
                ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TaskDetailHivePage(
                        task: task,
                        language: widget.language,
                        lightMode: widget.lightMode,
                      ),
                    ),
                  ),
                  leading: Icon(
                    Icons.task_alt_outlined,
                    size: 45.sp,
                    color: Colors.white70,
                  ),
                  title: Text(
                    task.task,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    widget.language == 'eng'
                        ? DateFormat.yMMMEd('en_US').format(task.date)
                        : widget.language == 'rus'
                            ? DateFormat.yMMMEd('ru_RU').format(task.date)
                            : DateFormat.yMMMEd('uz_UZ').format(task.date),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        task.status == 1 ? Icons.check_circle : Icons.edit,
                        color: task.status == 1 ? Colors.green : Colors.blue,
                      ),
                      Text(
                        task.status == 1
                            ? (widget.language == 'eng'
                                ? "Completed"
                                : widget.language == 'rus'
                                    ? "Выполнено"
                                    : "Bajarildi")
                            : (widget.language == 'eng'
                                ? "Task"
                                : widget.language == 'rus'
                                    ? "Задача"
                                    : "Vazifa"),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      )
                    ],
                  ),
                ),
                Dividers(lightMode: widget.lightMode, inden: false),
              ],
            );
          },
        ),
      ],
    );
  }
}
