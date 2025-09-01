import 'package:agenda/layers/presentation/pages/audio/add/recorder_add.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/add_task_page.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/task_list_page.dart';
import 'package:agenda/layers/presentation/pages/debts/add_debts/add_debts_home_page.dart';
import 'package:agenda/layers/presentation/pages/debts/debts_list_page.dart';
import 'package:agenda/layers/presentation/pages/main/home_page.dart';
import 'package:agenda/layers/presentation/pages/search/search_page.dart';
import 'package:agenda/layers/presentation/pages/settings/settings_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/debts_item.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/vois_recorder_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedLanguage = 'eng';
  final FocusNode _focusNode = FocusNode();

  bool _lightMode = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _loadThemeMode();
    _loadLanguage();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    _tabController.dispose();
    super.dispose();
  }

  // Function to load theme mode
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lightMode = prefs.getBool('themeMode') ?? true;
    });
  }

  void _saveLightMode(bool lightMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('themeMode', lightMode);
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'eng';
    });
  }

  void _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', language);
  }

  // Main widget build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _lightMode ? AppColors.homeBackgroundColor : AppColors.standartColor,
      appBar: AppBar(
        title: _getAppBarTitle(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => SearchPage(
                          language: _selectedLanguage!,
                          lightMode: _lightMode,
                        )),
              );
            },
            icon: const Icon(Icons.search),
            iconSize: 25.sp,
            color: Colors.white,
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50.h),
          child: TabBar(
            controller: _tabController,
            // indicatorColor: _lightMode
            //     ? Colors.white
            //     : Colors.blue[300], // Tanlangan tab ostidagi chiziq rangi
            indicatorColor: Colors.white,
            indicatorWeight: 4.h, // Chiziqning qalinligi
            labelColor:Colors.white,
            // labelColor: _lightMode ? Colors.white : Colors.blue[300],
            unselectedLabelColor: Colors.white38,
            indicatorSize: TabBarIndicatorSize.label,
            tabAlignment: TabAlignment.center,
            // padding: EdgeInsets.symmetric(horizontal: 10.h),
            indicatorPadding:
                const EdgeInsets.symmetric(horizontal: 0), // Chiziqning eni
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                  child: Text(
                _selectedLanguage == 'eng'
                    ? "Debts"
                    : _selectedLanguage == 'rus'
                        ? "Долги"
                        : 'Qarzlar',
                style: TextStyle(fontSize: 18.sp,),
              )),
              Tab(
                  child: Text(
                _selectedLanguage == 'eng'
                    ? "Tasks"
                    : _selectedLanguage == 'rus'
                        ? "Задачи"
                        : "Vazifalar",
                style: TextStyle(fontSize: 18.sp),
              )),
              Tab(
                  child: Text(
                _selectedLanguage == 'eng'
                    ? "Voice Recordings"
                    : _selectedLanguage == 'rus'
                        ? "Записи голоса"
                        : 'Ovozli yozuvlar',
                style: TextStyle(fontSize: 18.sp),
              )),
            ],
          ),
        ),
     
      // backgroundColor:
      //       _lightMode ? AppColors.primary : AppColors.standartColor,
      //   elevation: 1,
      //   scrolledUnderElevation: 1,


         foregroundColor: Colors.white,
           backgroundColor:  _lightMode ? AppColors.primary : const Color(0xff005a80),
           elevation: 3,
           shadowColor: Colors.black,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.standartColor, // Status bar rangini o'zgartirish
                statusBarIconBrightness: Brightness.light, // Ikonalar rangini o'zgartirish
              ),
       

        //  shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(10.r), // AppBarning Qirrani yumaloq qilish
        //   ),
        // ),
      ),
      drawer: TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(
          begin: const Offset(-1, 0), // Chapdan chiqishi uchun
          end: Offset.zero,
        ),
        duration: const Duration(milliseconds: 200),
        builder: (context, offset, child) {
          return FractionalTranslation(
            translation: offset,
            child: child,
          );
        },
        child: Drawer(
          backgroundColor:
              _lightMode ? AppColors.primary : AppColors.standartColor,
          child: ListView(
            // padding: EdgeInsets.zero,
            children: [
              Gap(30.h),
              Container(
                color: _lightMode ? AppColors.primary : AppColors.standartColor,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedLanguage == 'eng'
                              ? 'Agenda'
                              : _selectedLanguage == 'rus'
                                  ? 'Повестка дня'
                                  : 'Kun tartibi',
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Colors.white),
                        ),
                        IconButton(
                            onPressed: () {
                              _toggleTheme();
                              _saveLightMode(_lightMode);
                            },
                            icon: Icon(
                              _lightMode ? Icons.sunny : Icons.nights_stay,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ],
                ),
              ),

              // language uchun kodlar
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white10,
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedLanguage = 'eng';
                          _saveLanguage('eng');
                        });
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          const CircleBorder(), // To'liq yumaloq shakl
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(15), // Tugmani kattalashtirish
                        ),
                        backgroundColor: _selectedLanguage == 'eng'
                            ? WidgetStateProperty.all(Colors.white24)
                            : null,
                      ),
                      child: const Text(
                        'En',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _selectedLanguage = 'rus';
                          _saveLanguage('rus');
                        });
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          const CircleBorder(), // To'liq yumaloq shakl
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(15), // Tugmani kattalashtirish
                        ),
                        backgroundColor: _selectedLanguage == 'rus'
                            ? WidgetStateProperty.all(Colors.white24)
                            : null,
                      ),
                      child: const Text(
                        'Ru',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _selectedLanguage = 'uzb';
                          _saveLanguage('uzb');
                        });
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          const CircleBorder(), // To'liq yumaloq shakl
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(15), // Tugmani kattalashtirish
                        ),
                        backgroundColor: _selectedLanguage == 'uzb'
                            ? WidgetStateProperty.all(Colors.white24)
                            : null,
                      ),
                      child: const Text(
                        'O\'z',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _selectedLanguage = 'uz';
                          _saveLanguage('uz');
                        });
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          const CircleBorder(), // To'liq yumaloq shakl
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(15), // Tugmani kattalashtirish
                        ),
                        backgroundColor: _selectedLanguage == 'uz'
                            ? WidgetStateProperty.all(Colors.white24)
                            : null,
                      ),
                      child: const Text(
                        'Уз',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(10.h),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: const Icon(Icons.attach_money_sharp,
                        color: Colors.white)),
                title: Text(
                  _selectedLanguage == 'eng'
                      ? "Debts"
                      : _selectedLanguage == 'rus'
                          ? "Долги"
                          : 'Qarzlar',
                  style: TextStyle(fontSize: 18.sp),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DebtsListScreenPage(
                          language: _selectedLanguage!,
                          ))); // Drawer-ni yopadi
                },
              ),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: const Icon(Icons.task_alt_outlined, color: Colors.white)),
                title: Text(
                  _selectedLanguage == 'eng'
                      ? "Tasks"
                      : _selectedLanguage == 'rus'
                          ? "Задачи"
                          : "Vazifalar",
                  style: TextStyle(fontSize: 18.sp),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TaskListScreenPage(
                          language: _selectedLanguage!,
                          lightMode: _lightMode))); // Drawer-ni yopadi
                },
              ),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: const Icon(Icons.settings, color: Colors.white)),
                title: const Text('Sozlamalar',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsPage(
                            language: _selectedLanguage!,
                            lightMode: _lightMode,
                          )));
                },
              ),
            ],
          ),
        ),
      ),
     
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
                animation: _tabController.animation!,
                builder: (context, child) {
                  switch (_tabController.index) {
                    case 0:
                      return SingleChildScrollView(
                        child: DebtsItem(
                          language: _selectedLanguage!,
                          lightMode: _lightMode,
                          random: true,
                          debt: 'debts',
                        ),
                      );
                    case 1:
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            DayPage(
                              language: _selectedLanguage!,
                              lightMode: _lightMode,
                              random: false,
                            ),
                          ],
                        ),
                      );
                    default:
                      return VoisItem(
                          language: _selectedLanguage!, lightMode: _lightMode);
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddRecordingPage(
                    language: _selectedLanguage!, lightMode: _lightMode))),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
            ),
            child: Icon(
              Icons.mic,
              color: Colors.blue,
              size: 25.sp,
            ),
          ),
          Gap(10.h),
          MyFloatinacshinbutton(onPressed: () {
            _showBottomSheet(context);
          }),
        ],
      ),
    );
  }

  // AppBar uchun
  Widget _getAppBarTitle() {
    String title = '';
    title = _getTitleForPage('Agenda', 'Повестка дня', 'Kun tartibi');

    return Text(
      title,
      style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.white),
    );
  }

  String _getTitleForPage(String engTitle, String rusTitle, String uzbTitle) {
    switch (_selectedLanguage) {
      case 'eng':
        return engTitle;
      case 'rus':
        return rusTitle;
      case 'uzb':
        return uzbTitle;
      default:
        return engTitle;
    }
  }

  // Orqa fon rangini o'zgartirish
  void _toggleTheme() {
    setState(() {
      _lightMode = !_lightMode; // Temani almashtirish
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      backgroundColor: AppColors.homeBackgroundColor,
      // backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(15.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddTaskPage(
                            language: _selectedLanguage!,
                            lightMode: _lightMode,
                            pop: true)));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: const Color(0xffF5F5F5),
                  ),
                  child: Text(
                    'Yangi vazifa',
                    style: TextStyle(
                      color: const Color(0xff0C75AF),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Gap(15.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddDebtsHomePage(
                            language: _selectedLanguage!,
                            lightMode: _lightMode,
                            pop: true)));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: const Color(0xff0C75AF),
                    // backgroundColor: Colors.blue
                  ),
                  child: Text(
                    'Yangi qarz',
                    style: TextStyle(
                      color: const Color(0xffF5F5F5),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Gap(10.h),
            ],
          ),
        );
      
      
     
      },
    );
  }
}
