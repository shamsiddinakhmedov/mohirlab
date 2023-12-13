import 'package:auto_route/auto_route.dart';
import 'package:gulim/presentation/home/home/home_page.dart';
import 'package:gulim/presentation/main/main_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: MainRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page),
  ];
}
