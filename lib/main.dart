import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_widget/home_widget.dart';
import 'core/router/app_router.dart';
import 'feature/auth/signin/presentation/bloc/signin_bloc.dart';
import 'feature/auth/signup/presentation/bloc/signup_bloc.dart';
import 'feature/chat/presentation/bloc/chat_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'feature/chat/presentation/bloc/upload_image_bloc/upload_image_bloc.dart';
import 'feature/code_verification/bloc/code_verification_bloc.dart';
import 'feature/history/presentation/bloc/history_bloc.dart';
import 'feature/init_dependencies.dart';
import 'feature/profile/presentation/bloc/profile_bloc.dart';
import 'firebase_options.dart';
// import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');
  // Register an Interactivity Callback. It is necessary that this method is static and public
  // await HomeWidget.registerInteractivityCallback(interactiveCallback);
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  initDependency();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => serviceLocator<ChatBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<HistoryBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<ProfileBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<SignUpBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<SigninBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<UploadImageBloc>(),
      ),
      BlocProvider(
        create: (context) => CodeVerificationBloc(),
      ),
    ],
    child: MyApp(),
  ));
}

/// Callback invoked by HomeWidget Plugin when performing interactive actions
/// The @pragma('vm:entry-point') Notification is required so that the Plugin can find it
// @pragma('vm:entry-point')
// Future<void> interactiveCallback(Uri? uri) async {
//   // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
//   await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');

//   // We check the host of the uri to determine which action should be triggered.
//   if (uri?.host == 'increment') {
//     // await _increment(){};
//   } else if (uri?.host == 'clear') {
//     // await _clear();
//   }
// }

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _appRouter.config(),
          );
        });
  }
}
