import 'package:agenda/firebase_options.dart';
import 'package:agenda/layers/domain/auth/repository/login/login_repository_impl.dart';
import 'package:agenda/layers/domain/auth/repository/register/register_repository_impl.dart';
import 'package:agenda/layers/domain/auth/usecase/login_usecase.dart';
import 'package:agenda/layers/domain/auth/usecase/register_usecase.dart';
import 'package:agenda/layers/application/auth/register/register_cubit.dart';
import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
import 'package:agenda/layers/domain/models/hive_model/vois_recording_model/vois_recording_model.dart';
import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/presentation/pages/hive/helpers/hive_initialization.dart';
import 'package:agenda/layers/application/auth/login/login_cubit.dart';
import 'package:agenda/layers/presentation/pages/splash/splash_language_page.dart';
import 'package:agenda/layers/presentation/pages/splash/splash_page.dart';
import 'package:agenda/layers/presentation/pages/style/theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  // Register Hive adapters only if not already registered
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DebtsModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(DebtsDetailModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(TaskModelHiveAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(TaskTypeModelHiveAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(VoiceRecordingModelAdapter());
  }

  // Initialize Hive boxes and create default data
  await HiveInitialization.initializeBoxes();

  await initializeDateFormatting('uz', null);

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox("language");
  runApp(
    DevicePreview(
      // enabled: !kReleaseMode,
      enabled: false,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //
  late LoginUsecase _loginUsecase;
  late RegisterUsecase _registerUsecase;
  var lang = Hive.box("language");

  @override
  void initState() {
    // print('Malumotlar ${lang.values.first}');
    final loginRepo = LoginRepoImpl();
    _loginUsecase = LoginUsecase(loginRepo);

    final registerRepo = RegisterRepoImpl();
    _registerUsecase = RegisterUsecase(registerRepo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => LoginCubit(loginUsecase: _loginUsecase)),
            BlocProvider(
                create: (context) =>
                    RegisterCubit(registerUsecase: _registerUsecase)),
          ],
          child: MaterialApp(
              theme: AppTheme.theme,
              debugShowCheckedModeBanner: false,
              darkTheme: ThemeData.dark(),
              themeMode: ThemeMode.dark,
              home: lang.values.isEmpty ? const SplashLanguagePage() : const SplashPage()
              )),
    );
  }
}

// class MyApp1 extends StatelessWidget {
//   const MyApp1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(providers: [
//       BlocProvider(create: (context) => sl<SignInCubit>()),
//       BlocProvider(create: (context) => sl<SignUpCubit>()),
//       BlocProvider(create: (context) => sl<SignInWithGoogleCubit>()),
//     ], child: const HomePage());
//   }
// }
