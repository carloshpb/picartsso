// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData, child: HomeScreen(key: args.key));
    },
    TransferStyleRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const TransferStyleScreen());
    },
    FullSizePicRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const FullSizePicScreen());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(HomeRoute.name, path: '/'),
        RouteConfig(TransferStyleRoute.name, path: '/transfer-style-screen'),
        RouteConfig(FullSizePicRoute.name, path: '/full-size-pic-screen')
      ];
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({Key? key})
      : super(HomeRoute.name, path: '/', args: HomeRouteArgs(key: key));

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [TransferStyleScreen]
class TransferStyleRoute extends PageRouteInfo<void> {
  const TransferStyleRoute()
      : super(TransferStyleRoute.name, path: '/transfer-style-screen');

  static const String name = 'TransferStyleRoute';
}

/// generated route for
/// [FullSizePicScreen]
class FullSizePicRoute extends PageRouteInfo<void> {
  const FullSizePicRoute()
      : super(FullSizePicRoute.name, path: '/full-size-pic-screen');

  static const String name = 'FullSizePicRoute';
}
