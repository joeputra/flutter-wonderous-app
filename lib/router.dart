import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:playground_1/common_libs.dart';
import 'package:playground_1/logic/data/wonder_type.dart';
import 'package:playground_1/screens/home/wonders_home_screen.dart';
import 'package:playground_1/screens/intro/intro_screen.dart';
import 'package:playground_1/ui/screens/page_not_found/page_not_found.dart';
import 'package:playground_1/ui/screens/timeline/timeline_screen.dart';
// import 'package:playground_1/ui/screens/timeline/timeline_screen.dart';

class ScreenPaths {
  static String splash = '/';
  static String intro = '/welcome';
  static String home = '/home';
  static String settings = '/settings';

  static String wonderDetails(WonderType type, {required int tabIndex}) =>
      '$home/wonder/${type.name}?t=$tabIndex';

  /// Dynamically nested pages, always added on to the existing path
  static String video(String id) => _appendToCurrentPath('/video/$id');
  static String search(WonderType type) =>
      _appendToCurrentPath('/search/${type.name}');
  static String maps(WonderType type) =>
      _appendToCurrentPath('/maps/${type.name}');
  static String timeline(WonderType? type) =>
      _appendToCurrentPath('/timeline?type=${type?.name ?? ''}');
  static String artifact(String id, {bool append = true}) =>
      append ? _appendToCurrentPath('/artifact/$id') : '/artifact/$id';
  static String collection(String id) =>
      _appendToCurrentPath('/collection${id.isEmpty ? '' : '?id=$id'}');

  static String _appendToCurrentPath(String newPath) {
    final newPathUri = Uri.parse(newPath);
    final currentUri = appRouter.routeInformationProvider.value.uri;
    Map<String, dynamic> params = Map.of(currentUri.queryParameters);
    params.addAll(newPathUri.queryParameters);
    Uri? loc = Uri(
        path: '${currentUri.path}/${newPathUri.path}'.replaceAll('//', '/'),
        queryParameters: params);
    return loc.toString();
  }
}

AppRoute get _timelineRoute {
  return AppRoute(
    'timeline',
    (s) => TimelineScreen(
        type: _tryParseWonderType(s.uri.queryParameters['type']!)),
  );
}

final appRouter = GoRouter(
  redirect: _handleRedirect,
  errorPageBuilder: (context, state) =>
      MaterialPage(child: PageNotFound(state.uri.toString())),
  routes: [
    ShellRoute(
        builder: (context, router, navigator) {
          return WondersAppScaffold(child: navigator);
        },
        routes: [
          AppRoute(
              ScreenPaths.splash,
              (_) => Container(
                  color: $styles.colors.greyStrong)), // This will be hidden
          AppRoute(ScreenPaths.intro, (_) => const IntroScreen()),
          AppRoute(ScreenPaths.home, (_) => HomeScreen(), routes: [
            _timelineRoute,
            // _collectionRoute,
            // AppRoute(
            //   'wonder/:detailsType',
            //   (s) {
            //     int tab = int.tryParse(s.uri.queryParameters['t'] ?? '') ?? 0;
            //     return WonderDetailsScreen(
            //       type: _parseWonderType(s.pathParameters['detailsType']),
            //       tabIndex: tab,
            //     );
            //   },
            //   useFade: true,
            //   // Wonder sub-routes
            //   routes: [
            //     _timelineRoute,
            //     // _collectionRoute,
            //     // _artifactRoute,
            //     // Youtube Video
            //     AppRoute('video/:videoId', (s) {
            //       return FullscreenVideoViewer(id: s.pathParameters['videoId']!);
            //     }),

            //     // Search
            //     AppRoute(
            //       'search/:searchType',
            //       (s) {
            //         return ArtifactSearchScreen(type: _parseWonderType(s.pathParameters['searchType']));
            //       },
            //       routes: [
            //         _artifactRoute,
            //       ],
            //     ),

            //     // Maps
            //     // AppRoute(
            //     //     'maps/:mapsType',
            //     //     (s) => FullscreenMapsViewer(
            //     //           type: _parseWonderType(s.pathParameters['mapsType']),
            //     //         )),
            //   ],
            // ),
          ]),
        ]),
  ],
);

class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return CupertinoPage(child: pageContent);
          },
        );
  final bool useFade;
}

String? get initialDeeplink => _initialDeeplink;
String? _initialDeeplink;
String? _handleRedirect(BuildContext context, GoRouterState state) {
  // Prevent anyone from navigating away from `/` if app is starting up.
  if (!appLogic.isBootstrapComplete && state.uri.path != ScreenPaths.splash) {
    debugPrint('Redirecting from ${state.uri.path} to ${ScreenPaths.splash}.');
    _initialDeeplink ??= state.uri.toString();
    return ScreenPaths.splash;
  }
  if (appLogic.isBootstrapComplete && state.uri.path == ScreenPaths.splash) {
    debugPrint('Redirecting from ${state.uri.path} to ${ScreenPaths.home}');
    return ScreenPaths.home;
  }
  if (!kIsWeb) debugPrint('Navigate to: ${state.uri}');
  return null; // do nothing
}

WonderType? _tryParseWonderType(String value) =>
    WonderType.values.asNameMap()[value];
