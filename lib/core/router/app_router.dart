import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
            page: HistoryRoute.page,
            transitionsBuilder: TransitionsBuilders.slideLeft),
        // AutoRoute(
        //   page: ProfileRoute.page,
        // ),
        CustomRoute(
            page: ProfileRoute.page,
            transitionsBuilder: TransitionsBuilders.slideLeft),
        FirebaseAuth.instance.currentUser == null
            ? CustomRoute(
                page: SignInRoute.page,
                transitionsBuilder: TransitionsBuilders.slideRight,
                path: '/')
            : CustomRoute(
                page: SignInRoute.page,
                transitionsBuilder: TransitionsBuilders.slideRight,
              ),
        CustomRoute(
            page: SignUpRoute.page,
            transitionsBuilder: TransitionsBuilders.slideLeft),
        FirebaseAuth.instance.currentUser == null
            ? AutoRoute(page: ChatRoute.page)
            : AutoRoute(page: ChatRoute.page, path: '/'),
      ];
}
