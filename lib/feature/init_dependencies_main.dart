part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  // SharedPreferences sharedPreferences = SharedPreferences();
  serviceLocator.registerLazySingleton(() => Dio());
  _initChat();
  _initHistory();
  _initProfile();
  _initSignup();
  _initSignin();
}

_initSignin() {
  serviceLocator
    ..registerLazySingleton(() => SigninApi())
    ..registerLazySingleton(() => SigninServices(serviceLocator()))
    ..registerLazySingleton(() => SigninRepository(serviceLocator()))
    ..registerLazySingleton(() => SigninBloc(serviceLocator()));
}

_initSignup() {
  serviceLocator
    ..registerLazySingleton(() => SignUpApi())
    ..registerLazySingleton(() => SignUpServices(serviceLocator()))
    ..registerLazySingleton(() => SignUpRepository(serviceLocator()))
    ..registerLazySingleton(() => SignUpBloc(serviceLocator()));
}

_initProfile() {
  serviceLocator
    ..registerLazySingleton(() => ProfileApi())
    ..registerLazySingleton(() => ProfileServices(serviceLocator()))
    ..registerLazySingleton(() => ProfileRepository(serviceLocator()))
    ..registerLazySingleton(() => ProfileBloc(serviceLocator()));
}

_initHistory() {
  serviceLocator
    ..registerLazySingleton(() => HistoryApi())
    ..registerLazySingleton(
        () => HistoryServices(api: serviceLocator(), dio: serviceLocator()))
    ..registerLazySingleton(() => HistoryRepository(service: serviceLocator()))
    ..registerLazySingleton(() => HistoryBloc(repository: serviceLocator()));
}

_initChat() {
  serviceLocator
    //Api
    ..registerLazySingleton(() => ChatApi(serviceLocator()))
    ..registerLazySingleton(() => FirebaseChatApi())
    //Services
    ..registerLazySingleton(
        () => ChatServices(api: serviceLocator(), dio: serviceLocator()))
    ..registerLazySingleton(() => FirebaseServices(api: serviceLocator()))
    //Repository
    ..registerFactory(() => HomeRepository(service: serviceLocator()))
    ..registerLazySingleton(() => FirebaseRepository(service: serviceLocator()))
    //Bloc
    ..registerLazySingleton(() => ChatBloc(
        repository: serviceLocator(), firebaseRepository: serviceLocator()))
    ..registerLazySingleton(() => UploadImageBloc(
          repository: serviceLocator(),
        ));
}
